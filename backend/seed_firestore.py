# backend/seed_firestore.py
import sys
import firebase_admin  # type: ignore
from firebase_admin import credentials, firestore  # type: ignore
from datetime import datetime

# Initialize Firebase with project credentials
cred = credentials.Certificate('backend/service_account.json')
try:
    app = firebase_admin.get_app()
except ValueError:
    app = firebase_admin.initialize_app(cred)

db = firestore.client()
print(" Connected to Firestore project:", app.project_id)

# 1. Master Products Dataset (GI Tagged Indian Crafts)
products = [
    {
        "id": "prod_001",
        "artisan_id": "ODR5yrwyOFb6uFDpFsTcFClkUHw2", # Om Gaikwad
        "status": "published",
        "original_image_url": "https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=1000&q=80",
        "enhanced_image_url": "https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=1000&q=80",
        "catalog": {
            "hi": {
                "title": "हाथ से बुनी हुई पैठणी सिल्क साड़ी",
                "short_desc": "पारंपरिक मोर डिजाइन वाली शुद्ध रेशम की हथकरघा पैठणी साड़ी।",
                "description": "यह खूबसूरत पैठणी सिल्क साड़ी महाराष्ट्र के कुशल बुनकरों द्वारा पूरी तरह से हाथ से बुनी गई है। इसके पल्लू पर वास्तविक जरी का मोर और कमल का रूपांकन है।",
                "heritage_story": "पैठणी भारत की सबसे समृद्ध साड़ियों में से एक है, जिसका इतिहास सातवाहन काल से जुड़ा है।",
                "keywords": ["पैठणी", "सिल्क साड़ी", "हथकरघा", "महाराष्ट्र", "जरी"]
            },
            "mr": {
                "title": "अस्सल हातमाग पैठणी रेशीम साडी",
                "short_desc": "पारंपरिक मोराच्या नक्षीसह शुद्ध रेशमी विणलेली पैठणी साडी.",
                "description": "ही अतिशय सुंदर पैठणी साडी महाराष्ट्रातील निष्णात विणकरांनी पूर्णपणे हाताने विणलेली आहे. अस्सल सोन्याची जरी आणि आकर्षक मोराची कलाकुसर.",
                "heritage_story": "पैठणी ही महाराष्ट्राची राजवस्त्र मानली जाते, जी पैठण व येवला येथे शतकानुशतके विणली जाते.",
                "keywords": ["पैठणी", "रेशीम साडी", "हातमाग", "येवला पैठणी"]
            },
            "en": {
                "title": "Handwoven Paithani Silk Saree",
                "short_desc": "Premium handloom silk saree featuring traditional peacock motifs.",
                "description": "This exquisite Paithani silk saree is completely handwoven by master artisans in Maharashtra. Made with pure mulberry silk threads and real zari.",
                "heritage_story": "Paithani is one of the richest silk sarees in India, dating back to the Satavahana era.",
                "keywords": ["Paithani", "Silk Saree", "Handloom", "Maharashtra", "Traditional"]
            }
        },
        "pricing": {
            "recommended": 8499.0,
            "minimum": 7000.0,
            "market_low": 7000.0,
            "market_high": 9500.0,
            "confidence_score": 0.87,
            "production_cost": 4200.0,
            "factors": [
                "Pure Silk Material Quality",
                "Intricate Handcrafted Production",
                "Estimated 15 days Labor",
                "Traditional Craft Complexity"
            ]
        },
        "metadata": {
            "category": "Textiles",
            "subcategory": "Saree",
            "craft_type": "Paithani",
            "material": "Silk",
            "color": "Purple & Gold",
            "origin": "Maharashtra",
            "region": "Marathwada"
        },
        "created_at": datetime.now().isoformat()
    },
    {
        "id": "prod_002",
        "artisan_id": "artisan_kishore_chandel",
        "status": "published",
        "original_image_url": "https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1000&q=80",
        "enhanced_image_url": "https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1000&q=80",
        "catalog": {
            "hi": {
                "title": "जयपुर ब्लू पॉटरी फ्लोरल फूलदान",
                "short_desc": "पारंपरिक नीले और फ़िरोज़ा रंगों से हाथ से रंगा हुआ सिरेमिक फूलदान।",
                "description": "क्वार्ट्ज और मुल्तानी मिट्टी से निर्मित, यह फूलदान फारसी पुष्प डिजाइनों से सुसज्जित है। धूप में सुखाकर भट्टी में पकाया गया अनूठा हस्तशिल्प।",
                "heritage_story": "जयपुर की ब्लू पॉटरी को जीआई टैग प्राप्त है और यह बिना मिट्टी के क्वार्ट्ज से बनाई जाती है।",
                "keywords": ["ब्लू पॉटरी", "सिरेमिक", "जयपुर", "फूलदान", "हस्तशिल्प"]
            },
            "mr": {
                "title": "जयपूर ब्लू पॉटरी नक्षीदार फुलदाणी",
                "short_desc": "पारंपारिक निळ्या व आकाशी रंगात हाताने रेखाटलेली सुरेख फुलदाणी.",
                "description": "क्वार्ट्झ व नैसर्गिक रंगांपासून बनवलेली ही जयपुरी फुलदाणी घराच्या सजावटीला एक राजेशाही आणि पारंपरिक रूप देते.",
                "heritage_story": "जयपूरची ब्लू पॉटरी ही आंतरराष्ट्रीय स्तरावर प्रसिद्ध असून ती जीआय मानांकित आहे.",
                "keywords": ["ब्लू पॉटरी", "मातीकाम", "नक्षीकाम", "फुलदाणी"]
            },
            "en": {
                "title": "Jaipur Blue Pottery Ceramic Vase",
                "short_desc": "Traditional quartz-based turquoise glazed floral table vase.",
                "description": "Hand-painted with cobalt oxide and copper pigments on dough composed of quartz powder and Fuller's earth.",
                "heritage_story": "Turko-Persian glazed pottery brought to Jaipur under Maharaja Sawai Ram Singh II.",
                "keywords": ["Blue Pottery", "Ceramic", "Jaipur", "Vase"]
            }
        },
        "pricing": {
            "recommended": 2400.0,
            "minimum": 1900.0,
            "market_low": 2000.0,
            "market_high": 3100.0,
            "confidence_score": 0.91,
            "production_cost": 850.0,
            "factors": ["Quartz Composite", "Lead-Free Glaze", "Hand Painted Persian Motif"]
        },
        "metadata": {
            "category": "Pottery",
            "subcategory": "Home Decor",
            "craft_type": "Blue Pottery",
            "material": "Quartz & Glass",
            "color": "Cobalt Blue & Turquoise",
            "origin": "Rajasthan",
            "region": "Jaipur"
        },
        "created_at": datetime.now().isoformat()
    },
    {
        "id": "prod_003",
        "artisan_id": "artisan_ramesh_baghel",
        "status": "published",
        "original_image_url": "https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1000&q=80",
        "enhanced_image_url": "https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1000&q=80",
        "catalog": {
            "hi": {
                "title": "बस्तर ढोकरा कांस्य आदिवासी मूर्ति",
                "short_desc": "खोई हुई मोम तकनीक (Lost-Wax) से ढाली गई प्रामाणिक पीतल की हस्तनिर्मित कलाकृति।",
                "description": "छत्तीसगढ़ की 4000 वर्ष पुरानी धातु ढलाई परंपरा से निर्मित, यह ढोकरा मूर्ति बस्तर के आदिवासी लोक जीवन और संगीत का सजीव चित्रण करती है।",
                "heritage_story": "ढोकरा कला सिंधु घाटी सभ्यता की नृत्य करती लड़की (Dancing Girl) की तकनीक की सीधी उत्तराधिकारी है।",
                "keywords": ["ढोकरा", "कांस्य", "बस्तर", "आदिवासी कला", "हस्तशिल्प"]
            },
            "mr": {
                "title": "बस्तर ढोकरा धातूची आदिवासी मूर्ती",
                "short_desc": "लॉस्ट-वॅक्स (मेण पद्धत) तंत्राने घडवलेली अस्सल पितळी हस्तकला मूर्ती.",
                "description": "४००० वर्षांची प्राचीन परंपरा लाभलेली ही ढोकरा कलाकृती छत्तीसगडच्या बस्तर जंगलातील आदिवासी कलाकारांच्या कौशल्याचे प्रतीक आहे.",
                "heritage_story": "हडप्पा संस्कृतीतील कांस्य मूर्ती बनवण्याच्या पद्धतीशी साधर्म्य असणारी ही अत्यंत दुर्मीळ कला आहे.",
                "keywords": ["ढोकरा", "पितळ काम", "बस्तर कला", "आदिवासी हस्तकला"]
            },
            "en": {
                "title": "Bastar Dhokra Bell Metal Tribal Figurine",
                "short_desc": "Ancient non-ferrous lost-wax metal casting sculpture.",
                "description": "Hand-molded using beeswax wires, clay cores, and molten brass alloy. Each individual piece has zero duplicates.",
                "heritage_story": "One of the earliest known methods of metal casting in human history, preserved in Bastar.",
                "keywords": ["Dhokra", "Bell Metal", "Brass", "Bastar", "Tribal Art"]
            }
        },
        "pricing": {
            "recommended": 3850.0,
            "minimum": 3100.0,
            "market_low": 3200.0,
            "market_high": 4900.0,
            "confidence_score": 0.89,
            "production_cost": 1400.0,
            "factors": ["Lost-Wax Casting", "High Bell-Metal Content", "Tribal Artisan Certification"]
        },
        "metadata": {
            "category": "Metal Craft",
            "subcategory": "Sculptures",
            "craft_type": "Dhokra",
            "material": "Brass Alloy",
            "color": "Antique Gold",
            "origin": "Chhattisgarh",
            "region": "Bastar"
        },
        "created_at": datetime.now().isoformat()
    },
    {
        "id": "prod_004",
        "artisan_id": "artisan_abdul_gafur_khatri",
        "status": "published",
        "original_image_url": "https://images.unsplash.com/photo-1582562124811-c09040d0a901?auto=format&fit=crop&w=1000&q=80",
        "enhanced_image_url": "https://images.unsplash.com/photo-1582562124811-c09040d0a901?auto=format&fit=crop&w=1000&q=80",
        "catalog": {
            "hi": {
                "title": "कच्छ रोगन कला ट्री ऑफ लाइफ वॉल हैंगिंग",
                "short_desc": "उबले हुए अरंडी के तेल और प्राकृतिक पत्थरों के रंगों से धातु की सलाई द्वारा कपड़े पर उकेरी गई पेंटिंग।",
                "description": "गुजरात के निरोना गाँव के खत्री परिवार द्वारा पीढ़ियों से संरक्षित, यह रोगन कलाकृति बिना किसी खाके के सीधे रेशमी कपड़े पर बनाई जाती है।",
                "heritage_story": "रोगन कला को पद्मश्री पुरस्कार और प्रधानमंत्री द्वारा विश्व नेताओं को उपहार स्वरूप दिए जाने का गौरव प्राप्त है।",
                "keywords": ["रोगन कला", "कच्छ", "ट्री ऑफ लाइफ", "अरंडी का तेल", "कपड़ा पेंटिंग"]
            },
            "mr": {
                "title": "कच्छ रोगन कला 'ट्री ऑफ लाईफ' वॉल हँगिंग",
                "short_desc": "एरंडेल तेल व नैसर्गिक रंगांपासून धातूच्या दांड्याने रेशमी कापडावर रेखाटलेली अद्वितीय कला.",
                "description": "कच्छच्या खत्री कुटुंबाने जपलेली ही रोगन कला अत्यंत नाजूक व कौशल्यपूर्ण असून ती ३०० वर्षे जुनी आहे.",
                "heritage_story": "पंतप्रधानांनी व्हाईट हाऊसला भेट देताना रोगन कलाकृती भेट दिली होती, एवढी ही आंतरराष्ट्रीय ख्यातीप्राप्त आहे.",
                "keywords": ["रोगन कला", "कच्छ", "कापडी कला", "नैसर्गिक रंग"]
            },
            "en": {
                "title": "Kutch Rogan Art Tree of Life Wall Hanging",
                "short_desc": "Rare castor oil paint hand-manipulated onto fabric with a metal stylus.",
                "description": "Boiled castor oil paste blended with earth pigments, carefully stretched and printed onto pure tussar silk cloth.",
                "heritage_story": "300-year-old Persian-origin craft preserved solely by the Khatri family of Nirona, Kutch.",
                "keywords": ["Rogan Art", "Kutch", "Tree of Life", "Castor Oil", "Heritage Textile"]
            }
        },
        "pricing": {
            "recommended": 12500.0,
            "minimum": 9800.0,
            "market_low": 10500.0,
            "market_high": 16000.0,
            "confidence_score": 0.95,
            "production_cost": 4500.0,
            "factors": ["Rare Heritage Craft", "Padma Shri Family Lineage", "20 Days Handcrafting"]
        },
        "metadata": {
            "category": "Paintings",
            "subcategory": "Textile Art",
            "craft_type": "Rogan Art",
            "material": "Castor Oil & Tussar Silk",
            "color": "Multicolor on Navy Silk",
            "origin": "Gujarat",
            "region": "Kutch"
        },
        "created_at": datetime.now().isoformat()
    },
    {
        "id": "prod_005",
        "artisan_id": "artisan_ram_sahay",
        "status": "published",
        "original_image_url": "https://images.unsplash.com/photo-1513519245088-0e12902e5a38?auto=format&fit=crop&w=1000&q=80",
        "enhanced_image_url": "https://images.unsplash.com/photo-1513519245088-0e12902e5a38?auto=format&fit=crop&w=1000&q=80",
        "catalog": {
            "hi": {
                "title": "वाराणसी पारंपरिक हस्तनिर्मित लकड़ी के खिलौने",
                "short_desc": "कोरैया की लकड़ी पर प्राकृतिक लाख रंगों से बने पारंपरिक भारतीय खिलौने।",
                "description": "पूरी तरह से गैर-विषैले और पर्यावरण-अनुकूल रंगों से तैयार, यह वाराणसी के लकड़ी शिल्प का एक उत्तम उदाहरण है। बच्चों के लिए सुरक्षित और सजावटी।",
                "heritage_story": "वाराणसी के लकड़ी के लाख खिलौने को भारत सरकार द्वारा जीआई टैग दिया गया है।",
                "keywords": ["लकड़ी के खिलौने", "वाराणसी", "लाख रंग", "जीआई टैग", "पर्यावरण अनुकूल"]
            },
            "mr": {
                "title": "वाराणसी पारंपरिक लाकडी खेळणी संच",
                "short_desc": "नैसर्गिक लाखेच्या रंगात रंगवलेली बालस्नेही पर्यावरणपूरक लाकडी खेळणी.",
                "description": "कोरैया लाकडापासून बनवलेली ही खेळणी लहान मुलांसाठी पूर्णपणे सुरक्षित असून बनारसच्या शतकानुशतके जुन्या कलेचे दर्शन घडवतात.",
                "heritage_story": "बनारसी लाकडी खेळण्यांना जीआय मानांकन मिळाले असून ती जागतिक स्तरावर निर्यात केली जातात.",
                "keywords": ["लाकडी खेळणी", "वाराणसी", "पर्यावरणपूरक", "हस्तकला"]
            },
            "en": {
                "title": "Varanasi Handcrafted Wooden Toys Set",
                "short_desc": "GI-tagged safe, organic lacquer-turned woodcraft toys.",
                "description": "Turned on traditional hand lathes using Wrightia tinctoria (Koiraiya) wood and polished with natural resin lac dyes.",
                "heritage_story": "Generational craft cluster of Kashipura, Varanasi recognized with a Geographical Indication tag.",
                "keywords": ["Wooden Toys", "Varanasi", "Lacquer", "Eco-friendly", "GI Tag"]
            }
        },
        "pricing": {
            "recommended": 1450.0,
            "minimum": 1100.0,
            "market_low": 1200.0,
            "market_high": 1900.0,
            "confidence_score": 0.88,
            "production_cost": 480.0,
            "factors": ["Non-toxic Organic Colors", "Sustainable Koiraiya Wood", "Child Safe Finish"]
        },
        "metadata": {
            "category": "Woodcraft",
            "subcategory": "Toys & Collectibles",
            "craft_type": "Wooden Lacquerware",
            "material": "Koiraiya Wood & Natural Lac",
            "color": "Vibrant Red, Yellow & Green",
            "origin": "Uttar Pradesh",
            "region": "Varanasi"
        },
        "created_at": datetime.now().isoformat()
    },
    {
        "id": "prod_006",
        "artisan_id": "artisan_jivya_soma",
        "status": "published",
        "original_image_url": "https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1000&q=80",
        "enhanced_image_url": "https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&w=1000&q=80",
        "catalog": {
            "hi": {
                "title": "वारली पारंपरिक लोक चित्रकला - टरपा नृत्य",
                "short_desc": "गेरू और चावल के पेस्ट से खादी कैनवास पर बनी पारंपरिक आदिवासी पेंटिंग।",
                "description": "सह्याद्री पहाड़ियों की वारली जनजाति द्वारा विवाह और फसल उत्सव पर बनाई जाने वाली पवित्र चित्रकला, जो मनुष्य और प्रकृति के सामंजस्य को दर्शाती है।",
                "heritage_story": "वारली कला 10वीं शताब्दी ईसा पूर्व जितनी पुरानी मानी जाती है, जिसमें केवल मूल ज्यामितीय आकारों का उपयोग होता है।",
                "keywords": ["वारली पेंटिंग", "आदिवासी कला", "टरपा नृत्य", "महाराष्ट्र", "चावल पेस्ट"]
            },
            "mr": {
                "title": "वारली अस्सल आदिवासी चित्रकला - तारपा नृत्य",
                "short_desc": "गेरूच्या पार्श्वभूमीवर तांदळाच्या पिठाने खादी कॅनव्हासवर चितारलेली अस्सल वारली पेंटिंग.",
                "description": "निसर्ग आणि मानवी जीवनाचा मिलाफ दर्शवणारी ही वारली कला पालघर आणि ठाणे जिल्ह्यातील आदिवासी बांधवांचा सांस्कृतिक ठेवा आहे.",
                "heritage_story": "वारली चित्रकलेला जागतिक स्तरावर मानांकन मिळाले असून ती युनेस्कोच्या अमूर्त सांस्कृतिक वारशाशी जोडलेली आहे.",
                "keywords": ["वारली कला", "तारपा", "आदिवासी चित्रकला", "पालघर"]
            },
            "en": {
                "title": "Warli Traditional Tribal Canvas Painting",
                "short_desc": "Authentic rice flour & red ochre mud-canvas tribal painting.",
                "description": "Depicting the community Tarpa folk dance in concentric circles, symbolizing the circle of life without hierarchy.",
                "heritage_story": "Ancient Neolithic-era tribal expression documented in Maharashtra's Palghar and Dahanu regions.",
                "keywords": ["Warli", "Folk Art", "Painting", "Tribal", "Handmade Canvas"]
            }
        },
        "pricing": {
            "recommended": 1899.0,
            "minimum": 1500.0,
            "market_low": 1600.0,
            "market_high": 2500.0,
            "confidence_score": 0.94,
            "production_cost": 650.0,
            "factors": ["Natural Rice Pigment", "Handmade Khadi Canvas", "Master Folk Painter Detail"]
        },
        "metadata": {
            "category": "Paintings",
            "subcategory": "Folk Art",
            "craft_type": "Warli Painting",
            "material": "Rice Paste & Khadi Canvas",
            "color": "Red Ochre & White",
            "origin": "Maharashtra",
            "region": "Palghar"
        },
        "created_at": datetime.now().isoformat()
    }
]

print(f"\n--- Seeding {len(products)} Products into Firestore 'products' ---")
for p in products:
    db.collection('products').document(p['id']).set(p, merge=True)
    title = p['catalog']['en']['title']
    print(f" Saved: {p['id']} -> {title}")

# 2. Seed Artisan Profiles into 'artisans'
artisans = [
    {
        "id": "ODR5yrwyOFb6uFDpFsTcFClkUHw2",
        "name": "Om Gaikwad",
        "email": "om@gmail.com",
        "phone": "+91 98220 12345",
        "craft_type": "Yeola Paithani Silk Weaving",
        "state": "Maharashtra",
        "location": "Yeola, Nashik",
        "bio": "National Award winner and 4th generation master handloom weaver specialized in pure mulberry silk and real silver zari Paithani sarees.",
        "rating": 4.9,
        "total_reviews": 128,
        "global_sales": 340,
        "mastery_level": "Master Artisan (National Merit)",
        "is_verified": True,
        "avatar_url": "",
        "member_since": "2021"
    },
    {
        "id": "artisan_ramesh_baghel",
        "name": "Ramesh Baghel",
        "email": "ramesh.dhokra@shilpsetu.in",
        "phone": "+91 94252 54321",
        "craft_type": "Bastar Dhokra Bell Metal",
        "state": "Chhattisgarh",
        "location": "Kondagaon, Bastar",
        "bio": "Preserving the 4000-year-old lost-wax bell metal casting technique passed down across 5 generations of Ghadwa craftsmen.",
        "rating": 4.8,
        "total_reviews": 94,
        "global_sales": 210,
        "mastery_level": "State Merit Artisan",
        "is_verified": True,
        "avatar_url": "",
        "member_since": "2022"
    },
    {
        "id": "artisan_kishore_chandel",
        "name": "Kishore Chandel",
        "email": "kishore.pottery@shilpsetu.in",
        "phone": "+91 98290 87654",
        "craft_type": "Jaipur Blue Pottery",
        "state": "Rajasthan",
        "location": "Kot Jewar, Jaipur",
        "bio": "Master potter crafting lead-free quartz composite glazed ceramics using Persian motifs and natural copper and cobalt oxide pigments.",
        "rating": 4.85,
        "total_reviews": 112,
        "global_sales": 290,
        "mastery_level": "Master Craftsman",
        "is_verified": True,
        "avatar_url": "",
        "member_since": "2022"
    }
]

print(f"\n--- Seeding {len(artisans)} Artisans into Firestore 'artisans' ---")
for a in artisans:
    db.collection('artisans').document(a['id']).set(a, merge=True)
    print(f" Saved Artisan: {a['id']} -> {a['name']} ({a['craft_type']})")

print("\n Live Firestore Seeding Completed Successfully!")
