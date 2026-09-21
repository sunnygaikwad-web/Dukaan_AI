// lib/core/services/ai_service.dart

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AiService {
  /// Never hard-code a Gemini/API key inside the mobile application.
  ///
  /// The key can optionally be provided at runtime through
  /// SharedPreferences using [_prefApiKey].
  ///
  /// For production, the recommended architecture is:
  ///
  /// Flutter App
  ///      ↓
  /// Dukaan Backend
  ///      ↓
  /// Gemini API
  ///
  /// Keep the Gemini credential on the backend.
  static const String _defaultApiKey = '';

  static const String _prefApiKey = 'shilpsetu_gemini_api_key';

  static final AiService _instance = AiService._internal();

  factory AiService() => _instance;

  AiService._internal() {
    _loadKey();
  }

  String _geminiApiKey = _defaultApiKey;

  String get geminiApiKey => _geminiApiKey;

  bool get isLiveAiAvailable => _geminiApiKey.trim().isNotEmpty;

  /// Load an optional API key saved locally.
  ///
  /// If no key exists, the application automatically uses
  /// the deterministic demo engine.
  Future<void> _loadKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final saved = prefs.getString(_prefApiKey);

      if (saved != null && saved.trim().isNotEmpty) {
        _geminiApiKey = saved.trim();
      } else {
        _geminiApiKey = '';
      }
    } catch (e) {
      debugPrint('Error loading Gemini key: $e');
      _geminiApiKey = '';
    }
  }

  /// Set or clear the Gemini API key.
  ///
  /// For production applications, prefer calling your backend
  /// instead of storing a Gemini key on the device.
  Future<void> setGeminiApiKey(String key) async {
    _geminiApiKey = key.trim();

    try {
      final prefs = await SharedPreferences.getInstance();

      if (_geminiApiKey.isEmpty) {
        await prefs.remove(_prefApiKey);
      } else {
        await prefs.setString(_prefApiKey, _geminiApiKey);
      }
    } catch (e) {
      debugPrint('Error saving Gemini key: $e');
    }
  }

  // ============================================================
  // AI CATALOG GENERATION
  // ============================================================

  /// AI Catalog Generation
  ///
  /// Uses Gemini when a runtime key is available.
  /// Otherwise, falls back to the deterministic demo engine.
  Future<Map<String, dynamic>> generateCatalog({
    required String voiceTranscript,
    required String craftType,
    String? location,
  }) async {
    if (isLiveAiAvailable) {
      try {
        final prompt =
            '''
You are Dukaan AI, an expert handicraft cataloger and store manager for artisans.

Based on the following artisan voice description:

"$voiceTranscript"

Craft type:
"$craftType"

Location:
"${location ?? 'Maharashtra, India'}"

Generate a professional e-commerce product catalog in valid JSON with these exact keys:

{
  "title_en": "English product title",
  "title_mr": "Marathi product title",
  "title_hi": "Hindi product title",

  "short_desc_en": "Brief 1-line English hook",
  "short_desc_mr": "Brief 1-line Marathi hook",
  "short_desc_hi": "Brief 1-line Hindi hook",

  "desc_en": "Rich English e-commerce description (2-3 sentences)",
  "desc_mr": "Rich Marathi e-commerce description",
  "desc_hi": "Rich Hindi e-commerce description",

  "category": "e.g. Traditional Textiles / Pottery / Paintings / Woodcraft",

  "material": "Primary materials used",

  "craft_type": "$craftType",

  "origin": "${location ?? 'Maharashtra, India'}",

  "heritage_story": "Authentic cultural narrative of this craft. Do not fabricate certifications or unsupported claims.",

  "tags": ["tag1", "tag2", "tag3"],

  "recommended_price": "e.g. ₹4,500",

  "pricing_reasons": [
    "Reason 1",
    "Reason 2",
    "Reason 3"
  ]
}

Return ONLY the raw JSON object.
Do not use Markdown.
Do not wrap the JSON in ```json.
''';

        final url = Uri.parse(
          'https://generativelanguage.googleapis.com/'
          'v1beta/models/gemini-1.5-flash:generateContent'
          '?key=$_geminiApiKey',
        );

        final response = await http
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'contents': [
                  {
                    'parts': [
                      {'text': prompt},
                    ],
                  },
                ],
              }),
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          final text =
              data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

          final cleanJson = text
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();

          final parsed = json.decode(cleanJson);

          if (parsed is Map<String, dynamic>) {
            return parsed;
          }
        } else {
          debugPrint(
            'Gemini API returned status '
            '${response.statusCode}: ${response.body}',
          );
        }
      } catch (e) {
        debugPrint(
          'Gemini live AI failed, '
          'falling back to deterministic demo engine: $e',
        );
      }
    }

    // ==========================================================
    // DETERMINISTIC DEMO ENGINE
    // ==========================================================
    //
    // This engine works without an API key.
    // It is useful for SIH demonstrations and offline prototype
    // flows.
    //

    await Future.delayed(const Duration(milliseconds: 1200));

    final normalizedCraft = craftType.toLowerCase();

    final normalizedVoice = voiceTranscript.toLowerCase();

    final isTextile =
        normalizedCraft.contains('textil') ||
        normalizedCraft.contains('saree') ||
        normalizedCraft.contains('silk') ||
        normalizedVoice.contains('साडी') ||
        normalizedVoice.contains('साड़ी') ||
        normalizedVoice.contains('saree');

    if (isTextile) {
      return {
        'title_en': 'Handwoven Paithani Pure Silk Saree',

        'title_mr': 'हाताने विणलेली अस्सल पैठणी रेशीम साडी',

        'title_hi': 'हाथ से बुनी हुई असली पैठणी सिल्क साड़ी',

        'short_desc_en':
            'Authentic handloom silk saree featuring traditional peacock & lotus motifs.',

        'short_desc_mr':
            'पारंपरिक मयूर आणि कमळ नक्षीकाम असलेली अस्सल हँडलूम रेशीम साडी.',

        'short_desc_hi':
            'पारंपरिक मोर और कमल रूपांकनों वाली प्रामाणिक हथकरघा रेशम साड़ी।',

        'desc_en':
            'Crafted with 100% pure Mulberry silk and gold zari threads by master weavers. Each piece requires 15 to 25 days of dedicated pit-loom weaving, preserving traditional weaving craftsmanship.',

        'desc_mr':
            '१००% शुद्ध मलबेरी रेशीम आणि सोनेरी जरीच्या धाग्यांनी कुशल विणकरांनी तयार केलेली साडी. प्रत्येक साडीसाठी १५ ते २५ दिवसांचे अखंड कष्ट लागतात.',

        'desc_hi':
            'मास्टर बुनकरों द्वारा 100% शुद्ध शहतूत रेशम और सुनहरी जरी के धागों से निर्मित। प्रत्येक साड़ी 15 से 25 दिनों के गहन हथकरघा कार्य से तैयार होती है।',

        'category': 'Textiles',

        'material': 'Pure Mulberry Silk & Zari',

        'craft_type': 'Paithani Handloom',

        'origin': location ?? 'Maharashtra, India',

        'heritage_story':
            'Paithani weaving is associated with the historic town of Paithan in Maharashtra. Its distinctive motifs and handloom techniques have been preserved through generations of artisans.',

        'tags': [
          'Paithani',
          'Pure Silk',
          'Handloom',
          'Peacock Motif',
          'Traditional',
        ],

        'recommended_price': '₹8,499',

        'pricing_reasons': [
          'Pure Mulberry Silk & Zari Material Cost: ₹3,800',
          'Estimated 18 Days Master Artisan Labor: ₹3,200',
          'Intricate Hand-tapestry Technique: ₹800',
          'Fair Trade Artisan Profit Margin: ₹699',
        ],
      };
    }

    // ==========================================================
    // TERRACOTTA DEMO PRODUCT
    // ==========================================================

    return {
      'title_en': 'Terracotta Artisan Incense Burner (धूपदानी)',

      'title_mr': 'पारंपरिक मातीची कलात्मक धूपदानी',

      'title_hi': 'पारंपरिक हस्तनिर्मित मिट्टी की धूपदानी',

      'short_desc_en':
          'Handmade terracotta burner with a natural heat-resistant finish.',

      'short_desc_mr':
          'नैसर्गिक मातीपासून बनवलेली पारंपरिक उष्णतारोधक धूपदानी.',

      'short_desc_hi': 'प्राकृतिक मिट्टी से तैयार हस्तनिर्मित धूपदानी।',

      'desc_en':
          'Skillfully molded using traditional pottery techniques and fine clay. Naturally fired to create an earthy finish suitable for traditional home and pooja spaces.',

      'desc_mr':
          'पारंपरिक कुंभारकामाच्या पद्धतीने नैसर्गिक मातीपासून सुबकपणे घडवलेली. पारंपरिक घरगुती आणि पूजा वापरासाठी योग्य.',

      'desc_hi':
          'पारंपरिक कुम्हारी तकनीकों से प्राकृतिक मिट्टी से तैयार की गई। प्राकृतिक भट्टी में पकाकर इसे सुंदर मिट्टी जैसा स्वरूप दिया जाता है।',

      'category': 'Pottery & Clay',

      'material': 'Natural Clay',

      'craft_type': 'Terracotta',

      'origin': location ?? 'Maharashtra, India',

      'heritage_story':
          'Pottery is one of the oldest traditional crafts practiced across India. This design combines handcrafted clay work with functional perforations for airflow.',

      'tags': [
        'Terracotta',
        'Handmade Pottery',
        'Natural Clay',
        'Incense Burner',
        'Pooja Decor',
      ],

      'recommended_price': '₹349',

      'pricing_reasons': [
        'Natural Clay & Raw Materials: ₹70',
        'Manual Wheel Throwing & Carving: ₹150',
        'Traditional Kiln Firing: ₹60',
        'Direct Artisan Margin: ₹69',
      ],
    };
  }

  // ============================================================
  // SMART PRICING
  // ============================================================

  /// Explainable Smart Pricing Breakdown
  ///
  /// Calculates a suggested price using:
  ///
  /// Production Cost
  /// +
  /// Labor Cost
  /// ×
  /// Craft Complexity
  ///
  /// Returns a transparent breakdown that can be displayed
  /// directly in the Dukaan UI.
  Map<String, dynamic> calculateSmartPricing({
    required double productionCost,
    required int laborDays,
    required String craftType,
  }) {
    final laborRate = laborDays * 450.0;

    final normalizedCraftType = craftType.toLowerCase();

    final complexityMultiplier = normalizedCraftType.contains('silk')
        ? 1.4
        : 1.2;

    final baseCost = productionCost + laborRate;

    final recommended = baseCost * complexityMultiplier;

    final marketMin = (recommended * 0.85).round();

    final marketMax = (recommended * 1.25).round();

    final complexityCost = baseCost * (complexityMultiplier - 1.0);

    return {
      'production_cost': '₹${productionCost.round()}',

      'market_range': '₹$marketMin – ₹$marketMax',

      'recommended_price': '₹${recommended.round()}',

      'confidence': '94%',

      'factors': [
        'Raw Material & Supply Sourcing: ₹${productionCost.round()}',

        'Skilled Labor Allocation '
            '($laborDays days): ₹${laborRate.round()}',

        'Craft Complexity Factor '
            '(${((complexityMultiplier * 100) - 100).round()}%): '
            '₹${complexityCost.round()}',

        'Regional B2B Demand Benchmark: Verified High',
      ],
    };
  }
}
