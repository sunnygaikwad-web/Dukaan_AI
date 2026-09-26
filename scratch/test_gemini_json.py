import os
import json
import urllib.request
import base64

api_key = os.environ.get("GEMINI_API_KEY", "")  # Set GEMINI_API_KEY env variable
url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"

prompt = """
You are ShilpSetu AI, an expert handicraft appraiser and cataloger for Indian artisans.
Analyze the product described or shown.
Return valid JSON with EXACT keys:
{
  "title_en": "Detailed English title",
  "title_mr": "Marathi title",
  "title_hi": "Hindi title",
  "desc_en": "Rich English e-commerce description",
  "desc_mr": "Rich Marathi description",
  "desc_hi": "Rich Hindi description",
  "category": "Pottery / Leather / Woodcraft / Paintings / Jewellery / Textiles",
  "craft_type": "Specific craft name",
  "material": "Materials used",
  "heritage_story": "Authentic cultural heritage narrative",
  "recommended_price": "₹1,850",
  "price_inr": 1850,
  "pricing_reasons": ["Material cost", "Labor", "Artisan margin"],
  "detected_craft": "One sentence summary"
}
"""

payload = {
    "contents": [
        {
            "parts": [
                {"text": prompt + "\nProduct: Handmade clay incense burner (dhupdani) from Maharashtra."}
            ]
        }
    ],
    "generationConfig": {
        "temperature": 0.2,
        "maxOutputTokens": 1200,
        "responseMimeType": "application/json"
    }
}

req = urllib.request.Request(
    url,
    data=json.dumps(payload).encode('utf-8'),
    headers={"Content-Type": "application/json"}
)

try:
    with urllib.request.urlopen(req) as response:
        res = json.loads(response.read().decode('utf-8'))
        text = res['candidates'][0]['content']['parts'][0]['text']
        parsed = json.loads(text)
        print("Success! Parsed output keys:", list(parsed.keys()))
        print("Title EN:", parsed.get('title_en'))
        print("Category:", parsed.get('category'))
        print("Price INR:", parsed.get('price_inr'))
except Exception as e:
    print("Error:", e)

