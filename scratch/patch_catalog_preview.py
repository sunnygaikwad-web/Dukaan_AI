import os

target_file = r'c:\Users\Sunny\AndroidStudioProjects\ShilpSetu_AI\mobile_app\lib\features\products\screens\catalog_preview_screen.dart'

with open(target_file, 'r', encoding='utf-8') as f:
    code = f.read()

# Add import for AiService
if "import 'package:shilpsetu_ai/core/services/ai_service.dart';" not in code:
    code = code.replace(
        "import 'package:shilpsetu_ai/services/api_service.dart';",
        "import 'package:shilpsetu_ai/services/api_service.dart';\nimport 'package:shilpsetu_ai/core/services/ai_service.dart';"
    )

old_fallback = '''  void _applyCraftFallbackFromTranscript() {
    final t = widget.transcript.toLowerCase();
    if (t.contains('potter') || t.contains('clay') || t.contains('माती') || t.contains('धूपदानी')) {
      _mockAiResult['en'] = {
        'title': 'Royal Terracotta Incense Burner',
        'short_desc': 'Handcrafted terracotta incense burner made with natural river clay.',
        'desc': 'Skillfully thrown on traditional potters wheels and embellished with floral openwork. Naturally fired using rice husk for an earthy terracotta finish.',
      };
      _mockAiResult['mr'] = {
        'title': 'पारंपरिक मातीची कलात्मक धूपदानी',
        'short_desc': 'नदीच्या गाळाच्या मातीपासून चाकावर बनवलेली धूपदानी.',
        'desc': 'कुंभाराच्या चाकावर सुबक हातांनी घडवलेली आणि नैसर्गिकरीत्या भाजलेली पारंपरिक धूपदानी.',
      };
      _mockAiResult['hi'] = {
        'title': 'प्रामाणिक हस्तनिर्मित मिट्टी की धूपदानी',
        'short_desc': 'प्राकृतिक नदी की मिट्टी से चाक पर निर्मित धूपदानी।',
        'desc': 'कुम्हार के चाक पर बनाई गई सुंदर मिट्टी की धूपदानी। पारंपरिक भट्टी में पकाई गई पर्यावरण-अनुकूल कलाकृति।',
      };
      _mockAiResult['category'] = 'Pottery';
      _mockAiResult['craft_type'] = 'Terracotta';
      _mockAiResult['material'] = 'Organic Clay';
      _mockAiResult['recommended_price'] = '₹1,250';
      _mockAiResult['heritage_story'] = 'Pottery is one of India’s oldest continuous craft traditions, preserving ancient Indus valley pottery techniques.';
    } else if (t.contains('wood') || t.contains('sheesham') || t.contains('लाकूड') || t.contains('पेटी')) {
      _mockAiResult['en'] = {
        'title': 'Carved Sheesham Wood Keepsake Box',
        'short_desc': 'Master artisan carved Rosewood box with brass inlay.',
        'desc': 'Hand-chiseled from sustainably seasoned Saharanpur rosewood with exquisite brass inlay and velvet interior lining.',
      };
      _mockAiResult['mr'] = {
        'title': 'शिसम लाकडाची कोरीव कलात्मक पेटी',
        'short_desc': 'पारंपरिक जाळीकाम असलेली अस्सल लाकडी पेटी.',
        'desc': 'शिसम लाकडावर हाताने कोरीव काम करून त्यावर सुंदर पितळी नक्षीकाम जडवले आहे.',
      };
      _mockAiResult['hi'] = {
        'title': 'पीतल जड़ित नक्काशीदार शीशम लकड़ी बक्सा',
        'short_desc': 'पारंपरिक जालीदार नक्काशी से सजा शीशम का बक्सा।',
        'desc': 'कुशल कारीगरों द्वारा शीशम की लकड़ी पर बारीक हाथ की नक्काशी और पीतल के तारों की जड़ाई की गई है।',
      };
      _mockAiResult['category'] = 'Woodcraft';
      _mockAiResult['craft_type'] = 'Wood Carving';
      _mockAiResult['material'] = 'Sheesham Wood & Brass';
      _mockAiResult['recommended_price'] = '₹2,499';
      _mockAiResult['heritage_story'] = 'Wood carving in India flourished under royal patronages, creating durable heirlooms that celebrate master joinery.';
    }
  }'''

new_fallback = '''  void _applyCraftFallbackFromTranscript() {
    final t = widget.transcript.toLowerCase();
    if (t.contains('leather') || t.contains('chappal') || t.contains('चप्पल') || t.contains('कोल्हापुरी')) {
      _mockAiResult['en'] = {
        'title': 'Hand-Stitched Kolhapuri Leather Chappals',
        'short_desc': 'Heritage handcrafted Kolhapuri leather chappals vegetable tanned using babool bark.',
        'desc': widget.transcript.isNotEmpty ? widget.transcript : 'Crafted from 100% genuine vegetable-tanned leather using traditional wooden pestle softening and hand-braided cord stitching.',
      };
      _mockAiResult['mr'] = {
        'title': 'हाताने शिवलेली अस्सल कोल्हापुरी चप्पल',
        'short_desc': 'बाभळीच्या सालीच्या अर्काने कमवलेल्या अस्सल चामड्याची हाताने शिवलेली चप्पल.',
        'desc': 'पारंपरिक कोल्हापुरी कारागिरांनी अस्सल चामड्यावर हाताने बारीक नक्षीकाम करून शिवलेली चप्पल. शून्य सिंथेटिक रसायन.',
      };
      _mockAiResult['hi'] = {
        'title': 'हाथ से सिली प्रामाणिक कोल्हापुरी चमड़े की चप्पल',
        'short_desc': 'बबूल की छाल से तैयार शुद्ध चमड़े की हाथ से सिली मजबूत कोल्हापुरी चप्पल।',
        'desc': 'प्राकृतिक वनस्पति टैनिंग विधि से निर्मित प्रामाणिक चमड़ा। हाथ की बारीक सिलाई इसे बेजोड़ मजबूती देती है।',
      };
      _mockAiResult['category'] = 'Leather';
      _mockAiResult['craft_type'] = 'Kolhapuri Leather';
      _mockAiResult['material'] = '100% Vegetable-Tanned Leather';
      _mockAiResult['recommended_price'] = '₹1,950';
      _mockAiResult['heritage_story'] = 'Kolhapuri footwear dates back to the 12th century. Master cobbler families hand-braid natural leather with zero synthetic chemicals.';
    } else if (t.contains('paint') || t.contains('warli') || t.contains('वारली') || t.contains('चित्र')) {
      _mockAiResult['en'] = {
        'title': 'Handmade Warli Folk Art Canvas: Circle of Harvest',
        'short_desc': 'Sacred Warli tribal folk painting made with natural rice flour paste and tree gum.',
        'desc': widget.transcript.isNotEmpty ? widget.transcript : 'Painted on mud-coated organic canvas using bamboo twigs, illustrating the Tarpa dance and harmony of tribal life.',
      };
      _mockAiResult['mr'] = {
        'title': 'वारली लोककला: पारंपरिक उत्सव व निसर्ग चित्र',
        'short_desc': 'नैसर्गिक तांदळाच्या पिठापासून हाताने काढलेली अस्सल वारली आदिवासी चित्रकला.',
        'desc': 'सह्याद्रीच्या आदिवासी कलाकारांनी बांबूच्या काडीने आणि तांदळाच्या नैसर्गिक रंगाने रंगवलेले पारंपरिक निसर्ग चित्र.',
      };
      _mockAiResult['hi'] = {
        'title': 'हस्तनिर्मित वारली लोक कला कैनवास पेंटिंग',
        'short_desc': 'प्राकृतिक चावल के लेप से बनी पारंपरिक वारली आदिवासी लोककला।',
        'desc': 'पारंपरिक गेरू और गोबर लेपित कैनवास पर बांस की तीली से चावल के घोल द्वारा उकेरी गई प्रामाणिक लोककला।',
      };
      _mockAiResult['category'] = 'Paintings';
      _mockAiResult['craft_type'] = 'Warli Folk Art';
      _mockAiResult['material'] = 'Organic Canvas & Rice Flour Pigment';
      _mockAiResult['recommended_price'] = '₹3,200';
      _mockAiResult['heritage_story'] = 'Warli painting is a 2,500-year-old indigenous tribal art form of Maharashtra that worships earth, harvest, and communal life.';
    } else if (t.contains('potter') || t.contains('clay') || t.contains('माती') || t.contains('धूपदानी')) {
      _mockAiResult['en'] = {
        'title': 'Royal Terracotta Incense Burner',
        'short_desc': 'Handcrafted terracotta incense burner made with natural river clay.',
        'desc': widget.transcript.isNotEmpty ? widget.transcript : 'Skillfully thrown on traditional potters wheels and embellished with floral openwork. Naturally fired using rice husk.',
      };
      _mockAiResult['mr'] = {
        'title': 'पारंपरिक मातीची कलात्मक धूपदानी',
        'short_desc': 'नदीच्या गाळाच्या मातीपासून चाकावर बनवलेली धूपदानी.',
        'desc': 'कुंभाराच्या चाकावर सुबक हातांनी घडवलेली आणि नैसर्गिकरीत्या भाजलेली पारंपरिक धूपदानी.',
      };
      _mockAiResult['hi'] = {
        'title': 'प्रामाणिक हस्तनिर्मित मिट्टी की धूपदानी',
        'short_desc': 'प्राकृतिक नदी की मिट्टी से चाक पर निर्मित धूपदानी।',
        'desc': 'कुम्हार के चाक पर बनाई गई सुंदर मिट्टी की धूपदानी। पारंपरिक भट्टी में पकाई गई पर्यावरण-अनुकूल कलाकृति।',
      };
      _mockAiResult['category'] = 'Pottery';
      _mockAiResult['craft_type'] = 'Terracotta';
      _mockAiResult['material'] = 'Organic River Clay';
      _mockAiResult['recommended_price'] = '₹1,250';
      _mockAiResult['heritage_story'] = 'Pottery is one of India’s oldest continuous craft traditions, preserving ancient Indus valley pottery techniques.';
    } else if (t.contains('wood') || t.contains('sheesham') || t.contains('लाकूड') || t.contains('पेटी')) {
      _mockAiResult['en'] = {
        'title': 'Carved Sheesham Wood Keepsake Box',
        'short_desc': 'Master artisan carved Rosewood box with brass inlay.',
        'desc': widget.transcript.isNotEmpty ? widget.transcript : 'Hand-chiseled from sustainably seasoned Saharanpur rosewood with exquisite brass inlay and velvet interior lining.',
      };
      _mockAiResult['mr'] = {
        'title': 'शिसम लाकडाची कोरीव कलात्मक पेटी',
        'short_desc': 'पारंपरिक जाळीकाम असलेली अस्सल लाकडी पेटी.',
        'desc': 'शिसम लाकडावर हाताने कोरीव काम करून त्यावर सुंदर पितळी नक्षीकाम जडवले आहे.',
      };
      _mockAiResult['hi'] = {
        'title': 'पीतल जड़ित नक्काशीदार शीशम लकड़ी बक्सा',
        'short_desc': 'पारंपरिक जालीदार नक्काशी से सजा शीशम का बक्सा।',
        'desc': 'कुशल कारीगरों द्वारा शीशम की लकड़ी पर बारीक हाथ की नक्काशी और पीतल के तारों की जड़ाई की गई है।',
      };
      _mockAiResult['category'] = 'Woodcraft';
      _mockAiResult['craft_type'] = 'Wood Carving';
      _mockAiResult['material'] = 'Sheesham Wood & Brass';
      _mockAiResult['recommended_price'] = '₹2,499';
      _mockAiResult['heritage_story'] = 'Wood carving in India flourished under royal patronages, creating durable heirlooms that celebrate master joinery.';
    }
  }'''

code = code.replace(old_fallback, new_fallback)

# Update _fetchAiCatalog to fall back to AiService immediately
old_fetch = '''  Future<void> _fetchAiCatalog() async {
    try {
      final profile = context.read<UserProfileProvider>().profile;
      final response = await ApiService().generateCatalog(
        transcript: widget.transcript.isNotEmpty
            ? widget.transcript
            : 'Handwoven Paithani silk saree made with peacock motifs',
        artisanLocation: profile.state.isNotEmpty ? profile.state : 'Maharashtra',
        language: _selectedLanguage,
        imageFile: widget.imageFile.existsSync() ? widget.imageFile : null,
      );

      if (response != null && response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        setState(() {
          if (data['en'] != null) _mockAiResult['en'] = data['en'];
          if (data['mr'] != null) _mockAiResult['mr'] = data['mr'];
          if (data['hi'] != null) _mockAiResult['hi'] = data['hi'];
          if (data['category'] != null) _mockAiResult['category'] = data['category'];
          if (data['craft_type'] != null) _mockAiResult['craft_type'] = data['craft_type'];
          if (data['material'] != null) _mockAiResult['material'] = data['material'];
          if (data['origin'] != null) _mockAiResult['origin'] = data['origin'];
          if (data['heritage_story'] != null) _mockAiResult['heritage_story'] = data['heritage_story'];
        });
      }
    } catch (e) {
      debugPrint('AI Catalog generation fetch note: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }'''

new_fetch = '''  Future<void> _fetchAiCatalog() async {
    try {
      final profile = context.read<UserProfileProvider>().profile;
      final aiService = AiService();
      final location = profile.state.isNotEmpty ? profile.state : 'Maharashtra';

      Map<String, dynamic>? data;
      if (aiService.isLiveAiAvailable && widget.imageFile.existsSync()) {
        data = await aiService.analyzeImageAndGenerateCatalog(
          imageFile: widget.imageFile,
          voiceTranscript: widget.transcript.isNotEmpty ? widget.transcript : null,
          artisanLocation: location,
        );
      } else {
        data = await aiService.generateCatalog(
          voiceTranscript: widget.transcript.isNotEmpty ? widget.transcript : 'Handcrafted traditional Indian product',
          craftType: _mockAiResult['craft_type'] ?? 'Traditional Craft',
          location: location,
        );
      }

      if (data != null && mounted) {
        setState(() {
          if (data!['title_en'] != null) {
            _mockAiResult['en'] = {
              'title': data['title_en'],
              'short_desc': data['short_desc_en'] ?? data['title_en'],
              'desc': data['desc_en'] ?? widget.transcript,
            };
          }
          if (data['title_mr'] != null) {
            _mockAiResult['mr'] = {
              'title': data['title_mr'],
              'short_desc': data['short_desc_mr'] ?? data['title_mr'],
              'desc': data['desc_mr'] ?? widget.transcript,
            };
          }
          if (data['title_hi'] != null) {
            _mockAiResult['hi'] = {
              'title': data['title_hi'],
              'short_desc': data['short_desc_hi'] ?? data['title_hi'],
              'desc': data['desc_hi'] ?? widget.transcript,
            };
          }
          if (data['category'] != null) _mockAiResult['category'] = data['category'];
          if (data['craft_type'] != null) _mockAiResult['craft_type'] = data['craft_type'];
          if (data['material'] != null) _mockAiResult['material'] = data['material'];
          if (data['origin'] != null) _mockAiResult['origin'] = data['origin'];
          if (data['heritage_story'] != null) _mockAiResult['heritage_story'] = data['heritage_story'];
          if (data['recommended_price'] != null) _mockAiResult['recommended_price'] = data['recommended_price'];
        });
      }
    } catch (e) {
      debugPrint('AI Catalog preview fetch note: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }'''

code = code.replace(old_fetch, new_fetch)

with open(target_file, 'w', encoding='utf-8') as f:
    f.write(code)

print("Finished patching catalog_preview_screen.dart")
