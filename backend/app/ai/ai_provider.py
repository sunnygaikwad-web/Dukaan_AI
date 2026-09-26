"""AI Abstraction Layer — supports 'live' (Gemini) and 'demo' mode."""
import json
import logging
from typing import Optional
from app.core.config import settings

logger = logging.getLogger(__name__)


class AIProvider:
    """Abstract AI provider interface."""

    async def generate_catalog(self, transcript: str, artisan_location: str,
                               language: str, image_base64: Optional[str] = None) -> dict:
        raise NotImplementedError

    async def recommend_price(self, category: str, material: str,
                              craft_type: str, production_cost: float,
                              labor_hours: float, desired_margin: float) -> dict:
        raise NotImplementedError

    async def match_buyers(self, product_metadata: dict,
                           buyers: list) -> list:
        raise NotImplementedError

    async def generate_heritage_story(self, product_name: str,
                                       craft_type: str, origin: str) -> str:
        raise NotImplementedError

    async def transcribe_voice(self, audio_bytes: bytes, language: str = "mr",
                               craft_type: Optional[str] = None) -> str:
        raise NotImplementedError


# ─── Demo (Deterministic) Provider ───────────────────────────────────────────

class DemoAIProvider(AIProvider):
    """Returns realistic, deterministic mock AI responses for hackathon demos."""

    CRAFT_CATALOGS = {
        "textiles": {
            "en": {
                "title": "Handwoven Paithani Silk Saree",
                "short_desc": "Premium handloom silk saree featuring traditional peacock motifs.",
                "description": "This exquisite Paithani silk saree is completely handwoven by master artisans in Maharashtra. Made with pure silk threads, it features the iconic peacock (mor) design on the pallu. Perfect for weddings, festivals, and special occasions.",
                "heritage_story": "Paithani is one of the richest silk sarees in India, named after the Paithan town in Maharashtra. Traditionally woven with pure gold and silk threads by skilled weavers, it is considered a symbol of Maharashtrian culture and heritage.",
                "keywords": ["Paithani", "Silk Saree", "Handloom", "Maharashtra", "Traditional"],
                "seo_title": "Handwoven Paithani Silk Saree | Maharashtra Handloom | ShilpSetu",
                "meta_description": "Authentic handwoven Paithani silk saree from Maharashtra with traditional peacock motifs.",
            },
            "mr": {
                "title": "हाताने विणलेली पैठणी रेशीम साडी",
                "short_desc": "पारंपरिक मोराच्या डिझाइनसह प्रीमियम हँडलूम रेशीम साडी.",
                "description": "ही अतिशय सुंदर पैठणी साडी महाराष्ट्रातील कुशल कारागिरांनी पूर्णपणे हाताने विणलेली आहे. शुद्ध रेशमाच्या धाग्यांपासून बनवलेली, याच्या पदरावर आयकॉनिक मोराची डिझाइन आहे.",
                "heritage_story": "पैठणी ही भारतातील सर्वात श्रीमंत रेशीम साड्यांपैकी एक आहे, जी महाराष्ट्रातील पैठण शहरावरून नाव घेतलेली आहे. परंपरागतपणे शुद्ध सोने आणि रेशीम धाग्यांनी विणलेली.",
                "keywords": ["पैठणी", "रेशीम साडी", "हँडलूम", "महाराष्ट्र"],
            },
            "hi": {
                "title": "हाथ से बुनी हुई पैठणी सिल्क साड़ी",
                "short_desc": "पारंपरिक मोर डिजाइन वाली प्रीमियम हैंडलूम सिल्क साड़ी।",
                "description": "यह खूबसूरत पैठणी सिल्क साड़ी महाराष्ट्र के कुशल कारीगरों द्वारा पूरी तरह से हाथ से बुनी गई है। शुद्ध रेशम के धागों से बनी, इसके पल्लू पर प्रतिष्ठित मोर डिजाइन है।",
                "heritage_story": "पैठणी भारत की सबसे समृद्ध सिल्क साड़ियों में से एक है, जिसका नाम महाराष्ट्र के पैठण शहर पर रखा गया है। परंपरागत रूप से शुद्ध सोने और रेशम के धागों से बुनी जाती है।",
                "keywords": ["पैठणी", "सिल्क साड़ी", "हैंडलूम", "महाराष्ट्र"],
            },
            "category": "Textiles",
            "subcategory": "Saree",
            "craft_type": "Paithani",
            "material": "Silk",
            "color": "Purple & Gold",
            "origin": "Maharashtra",
            "region": "Marathwada",
        },
        "pottery": {
            "en": {
                "title": "Royal Terracotta Incense Burner & Floral Urn",
                "short_desc": "Handcrafted terracotta incense burner made with natural river clay.",
                "description": "Skillfully thrown on traditional potters wheels and embellished with floral openwork. Naturally fired using rice husk for an earthy terracotta finish.",
                "heritage_story": "Pottery is one of India's oldest craft legacies, dating back to the Indus Valley civilization. Each vessel is shaped to promote sacred rituals and air circulation.",
                "keywords": ["Terracotta", "Clay Pottery", "Handmade Urn", "Incense Burner", "Rural Craft"],
            },
            "mr": {
                "title": "पारंपरिक मातीची कलात्मक धूपदानी व कलश",
                "short_desc": "नदीच्या गाळाच्या मातीपासून चाकावर बनवलेली धूपदानी.",
                "description": "कुंभाराच्या चाकावर सुबक हातांनी घडवलेली आणि नैसर्गिकरीत्या भाजलेली पारंपरिक धूपदानी.",
                "heritage_story": "भारतीय मातीकाम ही सिंधू संस्कृतीपासून चालत आलेली प्राचीन कला आहे. घरामध्ये शुद्धता आणि सकारात्मक ऊर्जेसाठी धूपदानी वापरली जाते.",
                "keywords": ["मातीकाम", "धूपदानी", "पारंपरिक कला", "हस्तशिल्प"],
            },
            "hi": {
                "title": "प्रामाणिक हस्तनिर्मित मिट्टी की धूपदानी व कलश",
                "short_desc": "प्राकृतिक नदी की मिट्टी से चाक पर निर्मित धूपदानी।",
                "description": "कुम्हार के चाक पर बनाई गई सुंदर मिट्टी की धूपदानी। पारंपरिक भट्टी में पकाई गई पर्यावरण-अनुकूल कलाकृति।",
                "heritage_story": "भारत में मिट्टी के बर्तन बनाने की परंपरा हजारों साल पुरानी है। यह पवित्र सुगंध और घर की सुंदरता बढ़ाती है।",
                "keywords": ["मिट्टी के बर्तन", "धूपदानी", "टेराकोटा", "हस्तशिल्प"],
            },
            "category": "Pottery",
            "subcategory": "Terracotta",
            "craft_type": "Terracotta Pottery",
            "material": "River Clay",
            "color": "Earthy Ochre",
            "origin": "Maharashtra",
            "region": "Konkan",
        },
        "wood": {
            "en": {
                "title": "Carved Sheesham Wood Keepsake Box with Brass Inlay",
                "short_desc": "Master artisan carved Rosewood box with traditional floral jali.",
                "description": "Hand-chiseled from sustainably seasoned Saharanpur rosewood with exquisite brass inlay and velvet interior lining.",
                "heritage_story": "Wood carving in India flourished under royal patronages, creating durable heirlooms that celebrate the intricate relationship between nature and master joinery.",
                "keywords": ["Sheesham Wood", "Brass Inlay", "Carved Box", "Handmade Decor"],
            },
            "mr": {
                "title": "शिसम लाकडाची कोरीव कलात्मक पेटी पितळी जडावासह",
                "short_desc": "पारंपरिक जाळीकाम असलेली अस्सल लाकडी पेटी.",
                "description": "शिसम लाकडावर हाताने कोरीव काम करून त्यावर सुंदर पितळी नक्षीकाम जडवले आहे.",
                "heritage_story": "लाकडी नक्षीकाम ही शतकानुशतके राजांच्या दरबारात सन्मानित झालेली कला आहे, जी पिढ्यानपिढ्या जतन केली गेली आहे.",
                "keywords": ["लाकडी नक्षीकाम", "शिसम", "हस्तकला", "शिल्पसेतू"],
            },
            "hi": {
                "title": "पीतल जड़ित नक्काशीदार शीशम लकड़ी का बक्सा",
                "short_desc": "पारंपरिक जालीदार नक्काशी से सजा शीशम का बक्सा।",
                "description": "कुशल कारीगरों द्वारा शीशम की लकड़ी पर बारीक हाथ की नक्काशी और पीतल के तारों की जड़ाई की गई है।",
                "heritage_story": "भारतीय काष्ठ कला पीढ़ियों से धरोहर के रूप में संरक्षित है। यह सुंदरता और मजबूती का प्रतीक है।",
                "keywords": ["लकड़ी नक्काशी", "शीशम", "पीतल जड़ाई", "हस्तशिल्प"],
            },
            "category": "Woodcraft",
            "subcategory": "Boxes",
            "craft_type": "Wood Carving",
            "material": "Sheesham Wood & Brass",
            "color": "Rich Walnut & Gold",
            "origin": "Maharashtra",
            "region": "Vidarbha",
        },
    }

    DEMO_CATALOG = CRAFT_CATALOGS["textiles"]

    DEMO_PRICING = {
        "recommended": 8499,
        "minimum": 7000,
        "market_low": 7000,
        "market_high": 9500,
        "confidence_score": 0.87,
        "production_cost": 4200,
        "factors": [
            "Pure Silk Material Quality",
            "Intricate Handcrafted Production",
            "Estimated 15 days Labor",
            "Traditional Craft Complexity",
            "Market Demand Analysis",
            "Sustainable Artisan Margin",
        ],
    }

    DEMO_BUYERS = [
        {
            "buyer_id": "buyer_001",
            "name": "Premium Handloom Boutique",
            "location": "Mumbai, Maharashtra",
            "business_category": "Luxury Textile Retail",
            "match_score": 92,
            "match_reason": "This buyer frequently sources handloom textiles from Maharashtra. "
                            "They have placed 12 bulk orders for Paithani sarees in the past year.",
        },
        {
            "buyer_id": "buyer_002",
            "name": "Urban Handicrafts",
            "location": "Delhi",
            "business_category": "Handicraft Export",
            "match_score": 78,
            "match_reason": "Urban Handicrafts exports traditional Indian crafts to Europe. "
                            "They are actively looking for authentic Paithani weavers.",
        },
    ]

    async def transcribe_voice(self, audio_bytes: bytes, language: str = "mr",
                               craft_type: Optional[str] = None) -> str:
        logger.info(f"[DEMO] Transcribing voice in language={language}, craft_type={craft_type}")
        craft = (craft_type or "").lower()
        if "potter" in craft or "clay" in craft or "माती" in craft:
            if language == "mr":
                return "ही हाताने चाकावर बनवलेली पारंपरिक मातीची धूपदानी आहे. नदीच्या गाळाच्या मातीपासून तयार केली असून नैसर्गिकरीत्या भाजली आहे."
            elif language == "hi":
                return "यह चाक पर हाथ से बनाई गई प्रामाणिक मिट्टी की धूपदानी है। प्राकृतिक नदी की मिट्टी से निर्मित और पारंपरिक भट्टी में पकाई गई है।"
            return "This is an authentic handcrafted terracotta incense burner made on a traditional potter's wheel using pure riverbed clay."
        elif "wood" in craft or "लाकूड" in craft or "लकड़ी" in craft:
            if language == "mr":
                return "ही अस्सल शिसम लाकडाची कोरीव कलात्मक पेटी आहे. यावर बारीक जाळीकाम आणि पितळेचे नक्षीकाम हाताने केले आहे."
            elif language == "hi":
                return "यह असली शीशम की लकड़ी का नक्काशीदार बक्सा है। इसमें बारीक जालीदार काम और पीतल की सजावट की गई है।"
            return "This is a hand-carved Sheesham wood keepsake box featuring traditional floral jali openwork with brass inlay."
        else:
            if language == "mr":
                return "ही अस्सल हातमागावर विणलेली पैठणी रेशीम साडी आहे. यावर पारंपारिक मोराची नक्षी असून तयार करण्यास १५ दिवस लागले."
            elif language == "hi":
                return "यह शुद्ध रेशम की हाथ से बुनी प्रामाणिक पैठणी साड़ी है। इसमें मोर की पारंपरिक डिजाइन है और इसे बनाने में १५ दिन लगे।"
            return "This is an authentic handwoven Paithani silk saree made with pure silk threads and traditional peacock motifs."

    async def generate_catalog(self, transcript: str, artisan_location: str,
                               language: str, image_base64: Optional[str] = None) -> dict:
        logger.info("[DEMO] Generating craft-aware catalog.")
        t = transcript.lower()
        if "potter" in t or "clay" in t or "माती" in t or "धूपदानी" in t:
            return self.CRAFT_CATALOGS["pottery"]
        elif "wood" in t or "sheesham" in t or "लाकूड" in t or "पेटी" in t or "लकड़ी" in t:
            return self.CRAFT_CATALOGS["wood"]
        return self.DEMO_CATALOG

    async def recommend_price(self, category: str, material: str,
                              craft_type: str, production_cost: float,
                              labor_hours: float = 0, desired_margin: float = 0.4) -> dict:
        logger.info("[DEMO] Returning demo pricing.")
        result = self.DEMO_PRICING.copy()
        # Adjust recommended price dynamically based on production cost
        markup = 1 + desired_margin + 0.3
        result["recommended"] = round(production_cost * markup, -1)
        result["minimum"] = round(production_cost * 1.2, -1)
        result["production_cost"] = production_cost
        return result

    async def match_buyers(self, product_metadata: dict, buyers: list) -> list:
        logger.info("[DEMO] Returning demo buyer matches.")
        return self.DEMO_BUYERS

    async def generate_heritage_story(self, product_name: str,
                                       craft_type: str, origin: str) -> str:
        logger.info("[DEMO] Returning demo heritage story.")
        return (
            f"{craft_type} is a traditional craft form from {origin}. "
            f"This craft is traditionally associated with skilled artisans who have preserved "
            f"ancient techniques passed down through generations. Each piece carries the cultural "
            f"heritage and identity of its region, representing centuries of artistic tradition."
        )


# ─── Gemini (Live) Provider ───────────────────────────────────────────────────

class GeminiAIProvider(AIProvider):
    """Live AI provider using Google Gemini."""

    def __init__(self):
        import google.generativeai as genai
        genai.configure(api_key=settings.ai_api_key)
        self.model = genai.GenerativeModel("gemini-2.5-flash")

    CATALOG_PROMPT = """You are an expert Indian handicraft cataloger and translator.
    
    Given:
    - Artisan Voice Transcript: {transcript}
    - Location: {artisan_location}
    
    Generate a professional product catalog in STRICT JSON format with this exact structure:
    {{
      "en": {{"title": "...", "short_desc": "...", "description": "...", "heritage_story": "...", "keywords": [], "seo_title": "...", "meta_description": "..."}},
      "mr": {{"title": "...", "short_desc": "...", "description": "...", "heritage_story": "...", "keywords": []}},
      "hi": {{"title": "...", "short_desc": "...", "description": "...", "heritage_story": "...", "keywords": []}},
      "category": "...",
      "subcategory": "...",
      "craft_type": "...",
      "material": "...",
      "color": "...",
      "origin": "...",
      "region": "..."
    }}
    
    Rules:
    - Translations must be culturally appropriate, NOT literal word-for-word
    - Preserve craft terminology in regional language
    - Heritage story should be respectful and accurate; use "traditionally associated with" if uncertain
    - Return ONLY valid JSON, no markdown, no explanation
    """

    PRICING_PROMPT = """You are an Indian handicraft pricing expert.
    
    Product: {craft_type} made of {material}, category: {category}
    Production Cost: ₹{production_cost}
    Desired Margin: {desired_margin}%
    
    Return pricing recommendation in STRICT JSON:
    {{
      "recommended": 0,
      "minimum": 0,
      "market_low": 0,
      "market_high": 0,
      "confidence_score": 0.0,
      "production_cost": {production_cost},
      "factors": []
    }}
    Return ONLY valid JSON.
    """

    async def generate_catalog(self, transcript: str, artisan_location: str,
                               language: str, image_base64: Optional[str] = None) -> dict:
        try:
            prompt = self.CATALOG_PROMPT.format(
                transcript=transcript, artisan_location=artisan_location
            )
            response = self.model.generate_content(prompt)
            text = response.text.strip()
            if text.startswith("```"):
                text = text.split("```")[1]
                if text.startswith("json"):
                    text = text[4:]
            return json.loads(text)
        except Exception as e:
            logger.error(f"Gemini catalog generation failed: {e}")
            return DemoAIProvider().DEMO_CATALOG

    async def recommend_price(self, category: str, material: str,
                              craft_type: str, production_cost: float,
                              labor_hours: float = 0, desired_margin: float = 0.4) -> dict:
        try:
            prompt = self.PRICING_PROMPT.format(
                craft_type=craft_type, material=material,
                category=category, production_cost=production_cost,
                desired_margin=int(desired_margin * 100)
            )
            response = self.model.generate_content(prompt)
            text = response.text.strip()
            if text.startswith("```"):
                text = text.split("```")[1]
                if text.startswith("json"):
                    text = text[4:]
            return json.loads(text)
        except Exception as e:
            logger.error(f"Gemini pricing failed: {e}")
            return DemoAIProvider().DEMO_PRICING

    async def match_buyers(self, product_metadata: dict, buyers: list) -> list:
        return DemoAIProvider().DEMO_BUYERS  # Use demo matching for MVP

    async def generate_heritage_story(self, product_name: str,
                                       craft_type: str, origin: str) -> str:
        try:
            prompt = (
                f"Write a culturally respectful and historically accurate heritage story "
                f"(100-150 words) about the '{craft_type}' craft from {origin}. "
                f"Use 'traditionally associated with' when uncertain. No invented facts."
            )
            response = self.model.generate_content(prompt)
            return response.text.strip()
        except Exception as e:
            logger.error(f"Gemini heritage story failed: {e}")
            return DemoAIProvider().DEMO_CATALOG["en"]["heritage_story"]

    async def transcribe_voice(self, audio_bytes: bytes, language: str = "mr",
                               craft_type: Optional[str] = None) -> str:
        try:
            prompt = f"Transcribe this Indian artisan's spoken audio into clear {language} text about their craft ({craft_type or 'handicraft'}). Return only the transcribed text."
            # Multimodal audio transcription via Gemini
            response = self.model.generate_content([
                {"mime_type": "audio/mp4", "data": audio_bytes},
                prompt
            ])
            if response.text and response.text.strip():
                return response.text.strip()
        except Exception as e:
            logger.warning(f"Gemini audio transcription failed: {e}, falling back to craft demo transcript")
        return await DemoAIProvider().transcribe_voice(audio_bytes, language=language, craft_type=craft_type)


# ─── Factory ─────────────────────────────────────────────────────────────────

def get_ai_provider() -> AIProvider:
    """Returns the appropriate AI provider based on settings."""
    if settings.ai_mode == "live" and settings.ai_api_key:
        try:
            return GeminiAIProvider()
        except Exception as e:
            logger.warning(f"Failed to init Gemini, falling back to demo: {e}")
            return DemoAIProvider()
    return DemoAIProvider()


# Singleton
ai_provider: AIProvider = get_ai_provider()
