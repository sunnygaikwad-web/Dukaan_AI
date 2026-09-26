import os

ai_service_path = r'c:\Users\Sunny\AndroidStudioProjects\ShilpSetu_AI\mobile_app\lib\core\services\ai_service.dart'

with open(ai_service_path, 'r', encoding='utf-8') as f:
    content = f.read()

craft_detection_block = '''    final isTextile =
        normalizedCraft.contains('textil') ||
        normalizedCraft.contains('saree') ||
        normalizedCraft.contains('silk') ||
        normalizedVoice.contains('साडी') ||
        normalizedVoice.contains('साड़ी') ||
        normalizedVoice.contains('saree');

    final isWood =
        normalizedCraft.contains('wood') ||
        normalizedCraft.contains('लाकूड') ||
        normalizedCraft.contains('लकड़ी') ||
        normalizedVoice.contains('wood') ||
        normalizedVoice.contains('लाकूड') ||
        normalizedVoice.contains('लकड़ी');

    final isMetal =
        normalizedCraft.contains('brass') ||
        normalizedCraft.contains('metal') ||
        normalizedCraft.contains('पितळ') ||
        normalizedCraft.contains('पीतल') ||
        normalizedVoice.contains('brass') ||
        normalizedVoice.contains('metal') ||
        normalizedVoice.contains('तांबे');

    final isJewelry =
        normalizedCraft.contains('jewel') ||
        normalizedCraft.contains('दगिने') ||
        normalizedCraft.contains('गहने') ||
        normalizedVoice.contains('necklace') ||
        normalizedVoice.contains('कुंदन') ||
        normalizedVoice.contains('हार');'''

new_craft_detection_block = '''    final isLeather =
        normalizedCraft.contains('leather') ||
        normalizedCraft.contains('chappal') ||
        normalizedCraft.contains('चप्पल') ||
        normalizedCraft.contains('कोल्हापुरी') ||
        normalizedVoice.contains('leather') ||
        normalizedVoice.contains('chappal') ||
        normalizedVoice.contains('चप्पल') ||
        normalizedVoice.contains('कोल्हापुरी');

    final isPainting =
        normalizedCraft.contains('paint') ||
        normalizedCraft.contains('warli') ||
        normalizedCraft.contains('वारली') ||
        normalizedCraft.contains('चित्रकला') ||
        normalizedVoice.contains('paint') ||
        normalizedVoice.contains('warli') ||
        normalizedVoice.contains('वारली') ||
        normalizedVoice.contains('चित्र');

    final isDhokra =
        normalizedCraft.contains('dhokra') ||
        normalizedCraft.contains('ढोकरा') ||
        normalizedVoice.contains('dhokra') ||
        normalizedVoice.contains('ढोकरा');

    final isTextile =
        normalizedCraft.contains('textil') ||
        normalizedCraft.contains('saree') ||
        normalizedCraft.contains('silk') ||
        normalizedVoice.contains('साडी') ||
        normalizedVoice.contains('साड़ी') ||
        normalizedVoice.contains('saree');

    final isWood =
        normalizedCraft.contains('wood') ||
        normalizedCraft.contains('लाकूड') ||
        normalizedCraft.contains('लकड़ी') ||
        normalizedVoice.contains('wood') ||
        normalizedVoice.contains('लाकूड') ||
        normalizedVoice.contains('लकड़ी');

    final isMetal =
        normalizedCraft.contains('brass') ||
        normalizedCraft.contains('metal') ||
        normalizedCraft.contains('पितळ') ||
        normalizedCraft.contains('पीतल') ||
        normalizedVoice.contains('brass') ||
        normalizedVoice.contains('metal') ||
        normalizedVoice.contains('तांबे');

    final isJewelry =
        normalizedCraft.contains('jewel') ||
        normalizedCraft.contains('दगिने') ||
        normalizedCraft.contains('गहने') ||
        normalizedVoice.contains('necklace') ||
        normalizedVoice.contains('कुंदन') ||
        normalizedVoice.contains('हार');'''

new_craft_branches = '''    if (isLeather) {
      return {
        'title_en': 'Hand-Stitched Kolhapuri Leather Chappals',
        'title_mr': 'हाताने शिवलेली अस्सल कोल्हापुरी चप्पल',
        'title_hi': 'हाथ से सिली प्रामाणिक कोल्हापुरी चमड़े की चप्पल',
        'short_desc_en':
            'Heritage handcrafted Kolhapuri leather chappals vegetable tanned using babool bark.',
        'short_desc_mr':
            'बाभळीच्या सालीच्या अर्काने कमवलेल्या अस्सल चामड्याची हाताने शिवलेली चप्पल.',
        'short_desc_hi':
            'बबूल की छाल से तैयार शुद्ध चमड़े की हाथ से सिली मजबूत कोल्हापुरी चप्पल।',
        'desc_en':
            'Crafted from 100% genuine vegetable-tanned leather using traditional wooden pestle softening and hand-braided cord stitching. Naturally breathable and long-lasting.',
        'desc_mr':
            'पारंपरिक कोल्हापुरी कारागिरांनी अस्सल चामड्यावर हाताने बारीक नक्षीकाम करून शिवलेली चप्पल. शून्य सिंथेटिक रसायन.',
        'desc_hi':
            'प्राकृतिक वनस्पति टैनिंग विधि से निर्मित प्रामाणिक चमड़ा। हाथ की बारीक सिलाई इसे बेजोड़ मजबूती और आराम देती है।',
        'category': 'Leather',
        'material': '100% Vegetable-Tanned Natural Leather',
        'craft_type': 'Kolhapuri Leather',
        'origin': location ?? 'Kolhapur, Maharashtra',
        'heritage_story':
            'Kolhapuri footwear dates back to the 12th century under King Bijjana. Traditional artisan families in Kolhapur hand-craft every sole and braided strap with zero synthetic chemicals.',
        'tags': ['Kolhapuri', 'Leather', 'Handmade', 'Chappals', 'Traditional Footwear'],
        'recommended_price': '₹1,950',
        'pricing_reasons': [
          'Organic Vegetable-Tanned Leather: ₹750',
          '4 Days Master Cobbler Hand-Stitching: ₹800',
          'Natural Babool Buffing & Waxing: ₹150',
          'Artisan Margin: ₹250',
        ],
      };
    }

    if (isPainting) {
      return {
        'title_en': 'Handmade Warli Folk Art Canvas: Circle of Harvest',
        'title_mr': 'वारली लोककला: पारंपरिक उत्सव व निसर्ग चित्र',
        'title_hi': 'हस्तनिर्मित वारली लोक कला कैनवास पेंटिंग',
        'short_desc_en':
            'Sacred Warli tribal folk painting made with natural rice flour paste and tree gum.',
        'short_desc_mr':
            'नैसर्गिक तांदळाच्या पिठापासून हाताने काढलेली अस्सल वारली आदिवासी चित्रकला.',
        'short_desc_hi':
            'प्राकृतिक चावल के लेप से बनी पारंपरिक वारली आदिवासी लोककला।',
        'desc_en':
            'Painted on mud-and-geru coated organic canvas using bamboo twigs. Illustrates the Tarpa dance, mother nature, and communal harmony of Maharashtra\\'s Sahyadri tribes.',
        'desc_mr':
            'सह्याद्रीच्या आदिवासी कलाकारांनी बांबूच्या काडीने आणि तांदळाच्या नैसर्गिक रंगाने रंगवलेले पारंपरिक निसर्ग चित्र.',
        'desc_hi':
            'पारंपरिक गेरू और गोबर लेपित कैनवास पर बांस की तीली से चावल के घोल द्वारा उकेरी गई प्रामाणिक लोककला।',
        'category': 'Paintings',
        'material': 'Organic Canvas, Rice Flour Pigment & Natural Tree Gum',
        'craft_type': 'Warli Folk Art',
        'origin': location ?? 'Palghar / Dahanu, Maharashtra',
        'heritage_story':
            'Warli painting is a 2,500-year-old indigenous tribal art form of Maharashtra. Rooted in animistic traditions, simple geometric shapes evoke life, celebration, and earth worship.',
        'tags': ['Warli', 'Folk Art', 'Tribal Painting', 'Handmade Canvas', 'Heritage'],
        'recommended_price': '₹3,200',
        'pricing_reasons': [
          'Treated Organic Canvas & Natural Pigments: ₹600',
          '6 Days Intricate Bamboo-Stick Painting: ₹1,800',
          'Natural Protective Herbal Varnish: ₹300',
          'Fair Trade Tribal Artisan Margin: ₹500',
        ],
      };
    }

    if (isDhokra) {
      return {
        'title_en': 'Tribal Lost-Wax Cast Brass Bull (Dhokra Art)',
        'title_mr': 'पारंपरिक ढोकरा धातूची नंदी मूर्ती (मोल्ड क्राफ्ट)',
        'title_hi': 'ढोकरा शिल्प खोई मोम विधि से निर्मित नंदी बैल',
        'short_desc_en':
            'Ancient 4,000-year-old Indus Valley lost-wax cast bell metal sculpture.',
        'short_desc_mr':
            '४००० वर्षे जुन्या सिंधू संस्कृतीच्या मेणाच्या साच्यातून बनवलेली ढोकरा नंदी मूर्ती.',
        'short_desc_hi':
            'सिंधु घाटी सभ्यता की खोई-मोम तकनीक से हस्तनिर्मित ठोस ढोकरा पीतल बैल।',
        'desc_en':
            'Handcrafted by tribal metalsmiths using beeswax threads, clay cores, and molten scrap brass. No two pieces are ever alike.',
        'desc_mr':
            'मधमाशांच्या मेणाचे बारीक धागे मातीच्या साच्यावर गुंडाळून भट्टीत वितळवून ओतलेली अस्सल धातूकला.',
        'desc_hi':
            'मोम के तारों की बारीक बुनाई और मिट्टी के सांचे में ढली अनूठी धातु कलाकृति।',
        'category': 'Jewellery',
        'material': 'Bell Metal & Non-Ferrous Recycled Brass',
        'craft_type': 'Dhokra Metal Craft',
        'origin': location ?? 'Bastar / Gadchiroli, India',
        'heritage_story':
            'Dhokra metal casting is the oldest known method of non-ferrous metal casting, dating back to Mohenjo-daro Dancing Girl (2300 BC).',
        'tags': ['Dhokra', 'Lost Wax', 'Tribal Art', 'Brass', 'Heirloom'],
        'recommended_price': '₹1,850',
        'pricing_reasons': [
          'Brass Metal & Natural Clay/Wax Core: ₹550',
          '5 Days Single-Use Mold Handcrafting: ₹900',
          'Kiln Firing & Manual Buffing: ₹150',
          'Tribal Artisan Margin: ₹250',
        ],
      };
    }
'''

content = content.replace(craft_detection_block, new_craft_detection_block)
content = content.replace('    if (isTextile) {', new_craft_branches + '    if (isTextile) {')

with open(ai_service_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Successfully added isLeather, isPainting, and isDhokra branches to ai_service.dart")
