import os
import json
import urllib.request
import base64

api_key = os.environ.get("GEMINI_API_KEY", "")  # Set GEMINI_API_KEY env variable
url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"

img_path = r"C:\Users\Sunny\AndroidStudioProjects\ShilpSetu_AI\mobile_app\android\app\src\main\res\drawable\launch_image.png"
with open(img_path, 'rb') as f:
    img_b64 = base64.b64encode(f.read()).decode('utf-8')

prompt = """
You are ShilpSetu AI, an expert handicraft appraiser and cataloger for Indian artisans.
Look at this uploaded image.
Identify what kind of product or design it is.
Return a valid JSON object ONLY with these exact keys:
{
  "title_en": "...",
  "title_mr": "...",
  "title_hi": "...",
  "short_desc_en": "...",
  "short_desc_mr": "...",
  "short_desc_hi": "...",
  "desc_en": "...",
  "desc_mr": "...",
  "desc_hi": "...",
  "category": "Pottery / Leather / Woodcraft / Paintings / Jewellery / Textiles / Other",
  "craft_type": "...",
  "material": "...",
  "origin": "Maharashtra, India",
  "heritage_story": "...",
  "tags": ["...", "..."],
  "recommended_price": "₹1,499",
  "price_inr": 1499,
  "pricing_reasons": ["...", "..."],
  "detected_craft": "..."
}
"""

payload = {
    "contents": [
        {
            "parts": [
                {
                    "inline_data": {
                        "mime_type": "image/png",
                        "data": img_b64
                    }
                },
                {"text": prompt}
            ]
        }
    ],
    "generationConfig": {
        "temperature": 0.2,
        "maxOutputTokens": 4096,
        "responseMimeType": "application/json",
        "thinkingConfig": {
            "thinkingBudget": 0
        }
    }
}

req = urllib.request.Request(
    url,
    data=json.dumps(payload).encode('utf-8'),
    headers={"Content-Type": "application/json"}
)

try:
    with urllib.request.urlopen(req) as response:
        raw_body = response.read().decode('utf-8')
        res = json.loads(raw_body)
        parsed = json.loads(res['candidates'][0]['content']['parts'][0]['text'])
        print("Success! Gemini Vision parsed keys:", list(parsed.keys()))
        print("Detected:", parsed.get('detected_craft'))
        print("Category:", parsed.get('category'))
        print("Title EN:", parsed.get('title_en'))
        print("Price INR:", parsed.get('price_inr'))
except Exception as e:
    print("Error:", e)

