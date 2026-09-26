import os
import json
import urllib.request

api_key = os.environ.get("GEMINI_API_KEY", "")  # Set GEMINI_API_KEY env variable
url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"

payload = {
    "contents": [
        {
            "parts": [
                {
                    "text": 'You are ShilpSetu AI. Return JSON with {"title_en": "Kolhapuri Chappals", "price_inr": 1899, "category": "Leather"}. Return ONLY raw JSON without markdown.'
                }
            ]
        }
    ],
    "generationConfig": {
        "temperature": 0.2,
        "maxOutputTokens": 500,
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
        print("Success! Gemini response:")
        print(text)
except Exception as e:
    print("Error:", e)

