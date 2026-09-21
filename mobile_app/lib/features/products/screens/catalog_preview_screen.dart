import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shilpsetu_ai/models/product_model.dart';
import 'package:shilpsetu_ai/core/providers/product_provider.dart';
import 'package:shilpsetu_ai/core/providers/user_profile_provider.dart';
import 'package:shilpsetu_ai/core/constants/app_craft_images.dart';
import 'package:shilpsetu_ai/core/theme/app_theme.dart';
import 'package:shilpsetu_ai/services/api_service.dart';

class CatalogPreviewScreen extends StatefulWidget {
  final File imageFile;
  final String transcript;

  const CatalogPreviewScreen({
    super.key,
    required this.imageFile,
    required this.transcript,
  });

  @override
  State<CatalogPreviewScreen> createState() => _CatalogPreviewScreenState();
}

class _CatalogPreviewScreenState extends State<CatalogPreviewScreen> {
  bool _isLoading = true;
  String _selectedLanguage = 'en';

  final Map<String, dynamic> _mockAiResult = {
    'en': {
      'title': 'Handwoven Paithani Silk Saree',
      'short_desc': 'Premium handloom silk saree featuring traditional peacock motifs.',
      'desc': 'This exquisite Paithani silk saree is completely handwoven by master artisans in Maharashtra. Made with pure silk threads, it features the iconic peacock (mor) design on the pallu. Perfect for weddings, festivals, and special occasions.',
    },
    'mr': {
      'title': 'हाताने विणलेली पैठणी रेशीम साडी',
      'short_desc': 'पारंपरिक मोराच्या डिझाइनसह प्रीमियम हँडलूम रेशीम साडी.',
      'desc': 'ही अतिशय सुंदर पैठणी साडी महाराष्ट्रातील कुशल कारागिरांनी पूर्णपणे हाताने विणलेली आहे. शुद्ध रेशमाच्या धाग्यांपासून बनवलेली, याच्या पदरावर आयकॉनिक मोराची डिझाइन आहे. लग्नसमारंभ आणि सणांसाठी योग्य.',
    },
    'hi': {
      'title': 'हाथ से बुनी हुई पैठणी सिल्क साड़ी',
      'short_desc': 'पारंपरिक मोर डिजाइन वाली प्रीमियम हैंडलूम सिल्क साड़ी।',
      'desc': 'यह खूबसूरत पैठणी सिल्क साड़ी महाराष्ट्र के कुशल कारीगरों द्वारा पूरी तरह से हाथ से बुनी गई है। शुद्ध रेशम के धागों से बनी, इसके पल्लू पर प्रतिष्ठित मोर डिजाइन है। शादियों और त्योहारों के लिए बिल्कुल सही।',
    },
    'category': 'Textiles',
    'material': 'Silk',
    'craft_type': 'Paithani',
    'origin': 'Maharashtra',
    'heritage_story': 'Paithani is a variety of sari, named after the Paithan town in Aurangabad from state of Maharashtra where they are woven by hand. Made from very fine silk, it is considered as one of the richest saris in India.',
    'keywords': ['Paithani', 'Silk Saree', 'Handloom', 'Maharashtra', 'Traditional'],
    'recommended_price': '₹8,499',
    'pricing_reasons': [
      'Pure Silk Material Quality',
      'Intricate Handcrafted Production',
      'Estimated 15 days Labor',
      'Sustainable Artisan Margin'
    ]
  };

  @override
  void initState() {
    super.initState();
    _applyCraftFallbackFromTranscript();
    _fetchAiCatalog();
  }

  void _applyCraftFallbackFromTranscript() {
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
  }

  Future<void> _fetchAiCatalog() async {
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
  }

  ProductModel _buildProduct({required String status, required String artisanId}) {
    final imageDisplay = (widget.imageFile.path.isNotEmpty && widget.imageFile.existsSync())
        ? widget.imageFile.path
        : AppCraftImages.getCraftImageUrl(_mockAiResult['category'] ?? 'Textiles');

    return ProductModel(
      id: 'prod_${status == 'draft' ? 'draft_' : ''}${DateTime.now().millisecondsSinceEpoch}',
      artisanId: artisanId,
      status: status,
      originalImageUrl: imageDisplay,
      enhancedImageUrl: imageDisplay,
      catalog: {
        'en': CatalogContent(
          title: _mockAiResult['en']?['title'] ?? 'Paithani Silk Saree',
          shortDesc: _mockAiResult['en']?['short_desc'] ?? '',
          description: _mockAiResult['en']?['desc'] ?? '',
          heritageStory: _mockAiResult['heritage_story'] ?? '',
          keywords: List<String>.from(_mockAiResult['keywords'] ?? []),
        ),
        'mr': CatalogContent(
          title: _mockAiResult['mr']?['title'] ?? 'पैठणी रेशीम साडी',
          shortDesc: _mockAiResult['mr']?['short_desc'] ?? '',
          description: _mockAiResult['mr']?['desc'] ?? '',
          heritageStory: _mockAiResult['heritage_story'] ?? '',
          keywords: List<String>.from(_mockAiResult['keywords'] ?? []),
        ),
        'hi': CatalogContent(
          title: _mockAiResult['hi']?['title'] ?? 'पैठणी सिल्क साड़ी',
          shortDesc: _mockAiResult['hi']?['short_desc'] ?? '',
          description: _mockAiResult['hi']?['desc'] ?? '',
          heritageStory: _mockAiResult['heritage_story'] ?? '',
          keywords: List<String>.from(_mockAiResult['keywords'] ?? []),
        ),
      },
      pricing: PricingInfo(
        recommended: 8499.0,
        minimum: 7000.0,
        marketLow: 7000.0,
        marketHigh: 9500.0,
        confidenceScore: 0.88,
        productionCost: 4200.0,
        factors: List<String>.from(_mockAiResult['pricing_reasons'] ?? []),
      ),
      metadata: ProductMetadata(
        category: _mockAiResult['category'] ?? 'Textiles',
        subcategory: 'Saree',
        craftType: _mockAiResult['craft_type'] ?? 'Paithani',
        material: _mockAiResult['material'] ?? 'Silk',
        color: 'Purple & Gold',
        origin: _mockAiResult['origin'] ?? 'Maharashtra',
        region: 'Marathwada',
      ),
      createdAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog Preview'),
        actions: [
          if (!_isLoading)
            DropdownButton<String>(
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'mr', child: Text('मराठी')),
                DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedLanguage = val);
              },
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('AI is generating your catalog...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: (widget.imageFile.path.isNotEmpty && widget.imageFile.existsSync())
                        ? Image.file(widget.imageFile, height: 250, width: double.infinity, fit: BoxFit.cover)
                        : Image.network(
                            AppCraftImages.getCraftImageUrl(_mockAiResult['category'] ?? 'Textiles'),
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 250,
                              color: AppColors.primaryFixed,
                              child: const Icon(Icons.palette_rounded, size: 48, color: AppColors.primary),
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _mockAiResult[_selectedLanguage]['title'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _mockAiResult[_selectedLanguage]['short_desc'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  
                  // AI Pricing Card
                  Card(
                    color: Colors.green.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.green.shade200)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('AI Recommended Price', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                              Text(_mockAiResult['recommended_price'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                          const Divider(),
                          const Text('Why this price?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          ...(_mockAiResult['pricing_reasons'] as List<String>).map((reason) => Row(
                            children: [
                              const Icon(Icons.check, size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(child: Text(reason, style: const TextStyle(fontSize: 14))),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(_mockAiResult[_selectedLanguage]['desc']),
                  const SizedBox(height: 24),
                  const Text('Heritage Story', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.history_edu, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_mockAiResult['heritage_story'])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Chip(label: Text(_mockAiResult['category'])),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      final profile = context.read<UserProfileProvider>().profile;
                      final newProduct = _buildProduct(status: 'published', artisanId: profile.id);
                      await context.read<ProductProvider>().addProduct(newProduct);
                      if (context.mounted) {
                        context.go('/publish_success');
                      }
                    },
                    child: const Text('Publish Product'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () async {
                      final profile = context.read<UserProfileProvider>().profile;
                      final draftProduct = _buildProduct(status: 'draft', artisanId: profile.id);
                      await context.read<ProductProvider>().addProduct(draftProduct);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('💾 Saved to Drafts! Access in My Products.')),
                        );
                        context.go('/my_products');
                      }
                    },
                    child: const Text('Save as Draft'),
                  ),
                ],
              ),
            ),
    );
  }
}
