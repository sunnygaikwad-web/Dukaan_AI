import firebase_admin
from firebase_admin import credentials, firestore
from app.core.config import settings
import logging
import os
logger = logging.getLogger(__name__)

db = None

def init_firebase():
    global db
    cred = None

    # Try loading service account file
    candidate_paths = [
        settings.firebase_credentials_path,
        os.path.join(os.path.dirname(__file__), "..", "..", "service_account.json"),
        os.path.join(os.getcwd(), "service_account.json"),
        os.path.join(os.getcwd(), "backend", "service_account.json"),
    ]
    for path in candidate_paths:
        if path and os.path.exists(path):
            try:
                cred = credentials.Certificate(path)
                logger.info(f"Loaded Firebase service account credentials from {path}")
                break
            except Exception as e:
                logger.warning(f"Failed to load credentials from {path}: {e}")

    # Fallback to explicit env vars
    if not cred and settings.firebase_project_id and settings.firebase_client_email and settings.firebase_private_key:
        try:
            cred = credentials.Certificate({
                "type": "service_account",
                "project_id": settings.firebase_project_id,
                "private_key": settings.firebase_private_key.replace('\\n', '\n'),
                "client_email": settings.firebase_client_email,
                "token_uri": "https://oauth2.googleapis.com/token",
            })
        except Exception as e:
            logger.error(f"Error parsing Firebase credentials from env: {e}")

    if cred:
        try:
            if not firebase_admin._apps:
                firebase_admin.initialize_app(cred)
            db = firestore.client()
            logger.info("Firebase Firestore initialized successfully in LIVE mode.")
            return
        except Exception as e:
            logger.error(f"Failed to initialize Firebase app: {e}")
            db = MockFirestore()
    else:
        logger.warning("Firebase credentials not found. Falling back to MOCK database mode.")
        db = MockFirestore()

# A simple mock firestore to ensure the app works in Demo mode without a real DB
class MockFirestore:
    def __init__(self):
        self._collections = {}

    def collection(self, name):
        if name not in self._collections:
            self._collections[name] = MockCollection(name)
        return self._collections[name]

class MockCollection:
    def __init__(self, name):
        self.name = name
        self._documents = {}

    def document(self, doc_id=None):
        import uuid
        if not doc_id:
            doc_id = str(uuid.uuid4())
        if doc_id not in self._documents:
            self._documents[doc_id] = MockDocument(doc_id)
        return self._documents[doc_id]
        
    def stream(self):
        return [doc for doc in self._documents.values() if doc.exists]

class MockDocument:
    def __init__(self, doc_id):
        self.id = doc_id
        self._data = {}
        self.exists = False

    def set(self, data):
        self._data = data
        self.exists = True
        
    def update(self, data):
        if self.exists:
            self._data.update(data)
            
    def get(self):
        return self
        
    def to_dict(self):
        return self._data
