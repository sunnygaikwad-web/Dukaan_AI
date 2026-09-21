# ShilpSetu AI — Complete Project Documentation

## Overview
ShilpSetu AI is an AI-powered virtual business manager for marginalized artisans. It transforms physical handicrafts into professional digital listings and connects artisans with B2B buyers.

**Tagline:** *From Artisan Hands to Digital Markets.*

---

## Firebase Setup (REQUIRED BEFORE RUNNING)

### Step 1 — Go to Firebase Console
https://console.firebase.google.com

### Step 2 — Create/Open Project
- Create a project named `shilpsetu-ai`
- Package name: **`in.gov.shilpsetu.shilpsetu_ai`**

### Step 3 — Add Android App & Download Config
1. In your project, click **Add App → Android**
2. Enter package name: `in.gov.shilpsetu.shilpsetu_ai`
3. Click **Register App**
4. **Download `google-services.json`**
5. Place it at: `mobile_app/android/app/google-services.json`

### Step 4 — Enable Services in Firebase Console
| Service | How to Enable |
|---------|--------------|
| **Authentication** | Build → Authentication → Sign-in method → Enable **Email/Password** and **Phone** |
| **Firestore Database** | Build → Firestore Database → Create database → **Start in test mode** |
| **Firebase Storage** | Build → Storage → Get started → **Start in test mode** |

### Step 5 — Backend Service Account (for Python FastAPI)
1. Firebase Console → ⚙️ Project Settings → **Service accounts** tab
2. Click **Generate new private key**
3. Save the downloaded JSON file
4. Open `backend/.env` and fill in:
```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxx@your-project-id.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_KEY_HERE\n-----END PRIVATE KEY-----\n"
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
```

### Step 6 — Gemini AI API Key (for Live AI Mode)
1. Go to: https://makersuite.google.com/app/apikey
2. Create an API key
3. Add to `backend/.env`:
```env
AI_MODE=live
AI_PROVIDER=gemini
AI_API_KEY=your_gemini_api_key_here
```

---

## Running the App (Demo Mode — No Firebase Needed)

### Backend
```bash
cd backend
pip install -r requirements.txt
# .env already has AI_MODE=demo, so no API keys needed
uvicorn app.main:app --reload
```

### Flutter App
```bash
cd mobile_app
flutter pub get
flutter run
```

> ✅ The app works fully in **Demo Mode** without any Firebase credentials.

---

## Project Structure
```
ShilpSetu_AI/
├── backend/
│   ├── app/
│   │   ├── main.py              ← FastAPI entry point
│   │   ├── api/
│   │   │   ├── products.py      ← Product endpoints
│   │   │   ├── buyers.py        ← Buyer endpoints
│   │   │   ├── artisans.py      ← Artisan endpoints
│   │   │   └── digital_mela.py  ← Digital Mela endpoints
│   │   ├── ai/
│   │   │   └── ai_provider.py   ← Gemini + Demo abstraction
│   │   ├── services/
│   │   │   ├── product_service.py
│   │   │   └── buyer_matching_service.py
│   │   ├── models/
│   │   │   └── schemas.py       ← Pydantic models
│   │   ├── database/
│   │   │   └── firebase.py      ← Firestore + MockDB
│   │   └── core/
│   │       └── config.py        ← Settings from .env
│   ├── .env                     ← Your credentials here
│   └── requirements.txt
│
└── mobile_app/
    ├── lib/
    │   ├── main.dart             ← App entry + routing
    │   ├── core/
    │   │   ├── theme/app_theme.dart
    │   │   └── constants.dart
    │   ├── models/
    │   │   ├── artisan_model.dart
    │   │   ├── product_model.dart
    │   │   └── buyer_model.dart
    │   ├── services/
    │   │   ├── api_service.dart
    │   │   └── local_storage_service.dart
    │   └── features/
    │       ├── auth/screens/
    │       │   ├── splash_screen.dart
    │       │   ├── welcome_screen.dart
    │       │   ├── language_select_screen.dart
    │       │   └── profile_setup_screen.dart
    │       ├── artisan/screens/
    │       │   ├── home_screen.dart
    │       │   └── profile_screen.dart
    │       ├── products/screens/
    │       │   ├── add_product_screen.dart
    │       │   ├── ai_studio_screen.dart
    │       │   ├── voice_cataloger_screen.dart
    │       │   ├── catalog_preview_screen.dart
    │       │   ├── my_products_screen.dart
    │       │   └── publish_success_screen.dart
    │       ├── buyers/screens/
    │       │   ├── buyer_portal_screen.dart
    │       │   └── buyer_matching_screen.dart
    │       └── digital_mela/screens/
    │           └── digital_mela_screen.dart
    └── android/app/google-services.json  ← REPLACE WITH YOUR FILE
```

---

## Demo Flow (SIH Presentation)

1. **Launch** → See animated splash → "Welcome to ShilpSetu"
2. **Language** → Select Marathi
3. **Profile** → Enter Savita Patil's details
4. **Home** → See dashboard with stats, products, opportunities
5. **Add Product** → Take photo or pick from gallery
6. **AI Studio** → Watch 5-stage processing animation → Before/After comparison
7. **Voice** → Tap mic → Sample Marathi transcript appears
8. **Catalog** → AI generates trilingual (EN/MR/HI) title, description, heritage story
9. **Pricing** → See ₹8,499 recommended with "Why this price?" breakdown
10. **Publish** → Success screen with confetti emoji 🎉
11. **Buyers tab** → See 4 buyers with 92%, 78%, 65%, 58% match scores
12. **Digital Mela** → Showcase 6 themed collections

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Health + mode info |
| POST | `/api/products/generate-catalog` | AI catalog generation |
| POST | `/api/products/recommend-price` | AI price recommendation |
| POST | `/api/products/enhance-image` | Image enhancement |
| POST | `/api/products` | Save product to DB |
| GET | `/api/products` | List products |
| GET | `/api/products/{id}` | Get single product |
| POST | `/api/buyers/match` | AI buyer matching |
| GET | `/api/buyers/recommended` | Get all buyers |
| POST | `/api/buyers/bulk-order-request` | Submit bulk order |
| GET | `/api/artisans/{id}` | Get artisan profile |
| POST | `/api/artisans` | Create artisan |
| GET | `/api/digital-mela` | Get Mela events |
