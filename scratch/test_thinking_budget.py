import os
import json
import urllib.request

api_key = os.environ.get("GEMINI_API_KEY", "")  # Set GEMINI_API_KEY env variable
url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"

prompt = "You are ShilpSetu AI. Return JSON for handmade terracotta dhoopdaan with keys: title_en, title_mr, title_hi, category, price_inr, desc_en, heritage_story."

payload = {
    "contents": [
        {"parts": [{"text": prompt}]}
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
        print("Success with thinkingBudget: 0!")
        print("Candidate text:")
        print(res['candidates'][0]['content']['parts'][0]['text'])
        print("Usage:", res.get('usageMetadata'))
except Exception as e:
    print("Error:", e)

