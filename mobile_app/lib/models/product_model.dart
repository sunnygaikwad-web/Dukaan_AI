// lib/models/product_model.dart
class ProductModel {
  final String id;
  final String artisanId;
  final String status; // draft, published, sold_out
  final String? originalImageUrl;
  final String? enhancedImageUrl;
  final Map<String, CatalogContent> catalog;
  final PricingInfo pricing;
  final ProductMetadata metadata;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.artisanId,
    required this.status,
    this.originalImageUrl,
    this.enhancedImageUrl,
    required this.catalog,
    required this.pricing,
    required this.metadata,
    required this.createdAt,
  });

  String get title => catalog['hi']?.title ?? catalog['en']?.title ?? 'Untitled';
  String get price => '₹${pricing.recommended.toStringAsFixed(0)}';

  String localizedTitle(String lang) => catalog[lang]?.title ?? catalog['hi']?.title ?? catalog['en']?.title ?? 'Untitled';
  String localizedDesc(String lang) => catalog[lang]?.description ?? catalog['hi']?.description ?? catalog['en']?.description ?? '';
  String localizedShortDesc(String lang) => catalog[lang]?.shortDesc ?? catalog['hi']?.shortDesc ?? catalog['en']?.shortDesc ?? '';

  ProductModel copyWith({
    String? id,
    String? artisanId,
    String? status,
    String? originalImageUrl,
    String? enhancedImageUrl,
    Map<String, CatalogContent>? catalog,
    PricingInfo? pricing,
    ProductMetadata? metadata,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      artisanId: artisanId ?? this.artisanId,
      status: status ?? this.status,
      originalImageUrl: originalImageUrl ?? this.originalImageUrl,
      enhancedImageUrl: enhancedImageUrl ?? this.enhancedImageUrl,
      catalog: catalog ?? this.catalog,
      pricing: pricing ?? this.pricing,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      artisanId: map['artisan_id'] ?? '',
      status: map['status'] ?? 'draft',
      originalImageUrl: map['original_image_url'],
      enhancedImageUrl: map['enhanced_image_url'],
      catalog: (map['catalog'] as Map<String, dynamic>? ?? {}).map(
        (key, val) => MapEntry(key, CatalogContent.fromMap(val)),
      ),
      pricing: PricingInfo.fromMap(map['pricing'] ?? {}),
      metadata: ProductMetadata.fromMap(map['metadata'] ?? {}),
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  // Demo products list with distinct authentic online craft imagery & tri-lingual catalog
  static List<ProductModel> get demoProducts => [
    ProductModel(
      id: 'prod_001',
      artisanId: 'artisan_001',
      status: 'published',
      originalImageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=1000&q=80',
      enhancedImageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=1000&q=80',
      catalog: {
        'hi': CatalogContent(
          title: 'हाथ से बुनी हुई पैठणी सिल्क साड़ी',
          shortDesc: 'पारंपरिक मोर डिजाइन वाली शुद्ध रेशम की हथकरघा पैठणी साड़ी।',
          description: 'यह खूबसूरत पैठणी सिल्क साड़ी महाराष्ट्र के कुशल बुनकरों द्वारा पूरी तरह से हाथ से बुनी गई है। इसके पल्लू पर वास्तविक जरी का मोर और कमल का रूपांकन है।',
          heritageStory: 'पैठणी भारत की सबसे समृद्ध साड़ियों में से एक है, जिसका इतिहास सातवाहन काल से जुड़ा है।',
          keywords: ['पैठणी', 'सिल्क साड़ी', 'हथकरघा', 'महाराष्ट्र', 'जरी'],
        ),
        'mr': CatalogContent(
          title: 'अस्सल हातमाग पैठणी रेशीम साडी',
          shortDesc: 'पारंपरिक मोराच्या नक्षीसह शुद्ध रेशमी विणलेली पैठणी साडी.',
          description: 'ही अतिशय सुंदर पैठणी साडी महाराष्ट्रातील निष्णात विणकरांनी पूर्णपणे हाताने विणलेली आहे. अस्सल सोन्याची जरी आणि आकर्षक मोराची कलाकुसर.',
          heritageStory: 'पैठणी ही महाराष्ट्राची राजवस्त्र मानली जाते, जी पैठण व येवला येथे शतकानुशतके विणली जाते.',
          keywords: ['पैठणी', 'रेशीम साडी', 'हातमाग', 'येवला पैठणी'],
        ),
        'en': CatalogContent(
          title: 'Handwoven Paithani Silk Saree',
          shortDesc: 'Premium handloom silk saree featuring traditional peacock motifs.',
          description: 'This exquisite Paithani silk saree is completely handwoven by master artisans in Maharashtra. Made with pure mulberry silk threads and real zari.',
          heritageStory: 'Paithani is one of the richest silk sarees in India, dating back to the Satavahana era.',
          keywords: ['Paithani', 'Silk Saree', 'Handloom', 'Maharashtra', 'Traditional'],
        ),
      },
      pricing: PricingInfo(
        recommended: 8499,
        minimum: 7000,
        marketLow: 7000,
        marketHigh: 9500,
        confidenceScore: 0.87,
        productionCost: 4200,
        factors: [
          'Pure Silk Material Quality',
          'Intricate Handcrafted Production',
          'Estimated 15 days Labor',
          'Traditional Craft Complexity',
        ],
      ),
      metadata: ProductMetadata(
        category: 'Textiles',
        subcategory: 'Saree',
        craftType: 'Paithani',
        material: 'Silk',
        color: 'Purple & Gold',
        origin: 'Maharashtra',
        region: 'Marathwada',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ProductModel(
      id: 'prod_002',
      artisanId: 'artisan_001',
      status: 'published',
      originalImageUrl: 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1000&q=80',
      enhancedImageUrl: 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1000&q=80',
      catalog: {
        'hi': CatalogContent(
          title: 'जयपुर ब्लू पॉटरी फ्लोरल फूलदान',
          shortDesc: 'पारंपरिक नीले और फ़िरोज़ा रंगों से हाथ से रंगा हुआ सिरेमिक फूलदान।',
          description: 'क्वार्ट्ज और मुल्तानी मिट्टी से निर्मित, यह फूलदान फारसी पुष्प डिजाइनों से सुसज्जित है। धूप में सुखाकर भट्टी में पकाया गया अनूठा हस्तशिल्प।',
          heritageStory: 'जयपुर की ब्लू पॉटरी को जीआई टैग प्राप्त है और यह बिना मिट्टी के क्वार्ट्ज से बनाई जाती है।',
          keywords: ['ब्लू पॉटरी', 'सिरेमिक', 'जयपुर', 'फूलदान', 'हस्तशिल्प'],
        ),
        'mr': CatalogContent(
          title: 'जयपूर ब्लू पॉटरी नक्षीदार फुलदाणी',
          shortDesc: 'पारंपारिक निळ्या व आकाशी रंगात हाताने रेखाटलेली सुरेख फुलदाणी.',
          description: 'क्वार्ट्झ व नैसर्गिक रंगांपासून बनवलेली ही जयपुरी फुलदाणी घराच्या सजावटीला एक राजेशाही आणि पारंपरिक रूप देते.',
          heritageStory: 'जयपूरची ब्लू पॉटरी ही आंतरराष्ट्रीय स्तरावर प्रसिद्ध असून ती जीआय मानांकित आहे.',
          keywords: ['ब्लू पॉटरी', 'मातीकाम', 'नक्षीकाम', 'फुलदाणी'],
        ),
        'en': CatalogContent(
          title: 'Jaipur Blue Pottery Ceramic Vase',
          shortDesc: 'Traditional quartz-based turquoise glazed floral table vase.',
          description: 'Hand-painted with cobalt oxide and copper pigments on dough composed of quartz powder and Fuller’s earth.',
          heritageStory: 'Turko-Persian glazed pottery brought to Jaipur under Maharaja Sawai Ram Singh II.',
          keywords: ['Blue Pottery', 'Ceramic', 'Jaipur', 'Vase'],
        ),
      },
      pricing: PricingInfo(
        recommended: 2400,
        minimum: 1900,
        marketLow: 2000,
        marketHigh: 2800,
        confidenceScore: 0.92,
        productionCost: 950,
        factors: ['Natural Mineral Glazes', 'Hand Painted Motif', 'Kiln Glazing'],
      ),
      metadata: ProductMetadata(
        category: 'Pottery',
        subcategory: 'Ceramics',
        craftType: 'Blue Pottery',
        material: 'Quartz Ceramic',
        color: 'Cobalt Turquoise',
        origin: 'Rajasthan',
        region: 'Jaipur',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ProductModel(
      id: 'prod_003',
      artisanId: 'artisan_002',
      status: 'published',
      originalImageUrl: 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=1000&q=80',
      enhancedImageUrl: 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=1000&q=80',
      catalog: {
        'hi': CatalogContent(
          title: 'टेराकोटा हस्तनिर्मित धूपदानी एवं कलश',
          shortDesc: 'नदी की प्राकृतिक चिकनी मिट्टी से चाक पर गढ़ी गई पारंपरिक धूपदानी।',
          description: 'कोल्हापुर के ग्रामीण कुम्हारों द्वारा चाक पर तैयार की गई धूपदानी। जालीदार नक्काशी से सुगंधित धुआं चारों ओर फैलता है।',
          heritageStory: 'मिट्टी के बर्तन बनाने की यह परंपरा सिंधु घाटी सभ्यता के प्राचीन कौशल का निरंतर रूप है।',
          keywords: ['टेराकोटा', 'मिट्टी', 'धूपदानी', 'हस्तशिल्प', 'पर्यावरण-अनुकूल'],
        ),
        'mr': CatalogContent(
          title: 'टेराकोटा जाळीदार मातीची धूपदानी',
          shortDesc: 'नदीकाठच्या अस्सल लाल मातीपासून चाकावर घडवलेली पारंपारिक धूपदानी.',
          description: 'चाकावर अत्यंत कुशलतेने घडवलेली आणि लाकडाच्या भट्टीत भाजलेली. यावरील जाळीदार नक्षीमुळे सुगंधी धूर सुंदर पसरतो.',
          heritageStory: 'महाराष्ट्रातील ग्रामीण कुंभारकाम ५००० वर्षांचा समृद्ध सांस्कृतिक वारसा जपत आहे.',
          keywords: ['टेराकोटा', 'मातीकाम', 'धूपदानी', 'कुंभारकाम'],
        ),
        'en': CatalogContent(
          title: 'Terracotta Handcrafted Incense Burner (धूपदानी)',
          shortDesc: 'Natural organic clay burner crafted on traditional potter wheels.',
          description: 'Molded by hand with fine riverbed clay and fired in wood-fired kilns. Naturally heat-resistant with pierced jaali pattern.',
          heritageStory: 'Terracotta pottery in rural Maharashtra carries five millennia of heritage.',
          keywords: ['Terracotta', 'Clay', 'Pottery', 'Handmade', 'Eco-friendly'],
        ),
      },
      pricing: PricingInfo(
        recommended: 499,
        minimum: 380,
        marketLow: 400,
        marketHigh: 650,
        confidenceScore: 0.95,
        productionCost: 180,
        factors: ['Organic River Clay', 'Hand Wheel Crafting', 'Traditional Firing Kiln'],
      ),
      metadata: ProductMetadata(
        category: 'Pottery',
        subcategory: 'Home Decor',
        craftType: 'Terracotta',
        material: 'River Clay',
        color: 'Earthy Ochre',
        origin: 'Maharashtra',
        region: 'Kolhapur',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ProductModel(
      id: 'prod_004',
      artisanId: 'artisan_002',
      status: 'published',
      originalImageUrl: 'https://images.unsplash.com/photo-1546484396-fb3fc6f95f98?auto=format&fit=crop&w=1000&q=80',
      enhancedImageUrl: 'https://images.unsplash.com/photo-1546484396-fb3fc6f95f98?auto=format&fit=crop&w=1000&q=80',
      catalog: {
        'hi': CatalogContent(
          title: 'शीशम की नक्काशीदार लकड़ी की पेटी',
          shortDesc: 'पीतल की महीन जड़ाई वाली पारंपरिक शीशम लकड़ी की बॉक्स।',
          description: 'अनुभवी कारीगरों द्वारा शुद्ध शीशम की लकड़ी पर फूलों की नक्काशी और प्राकृतिक वैक्स पॉलिश से तैयार की गई बहुमूल्य पेटी।',
          heritageStory: 'सहारनपुर और पश्चिमी घाट की काष्ठ नक्काशी कला पीढ़ियों पुरानी है।',
          keywords: ['लकड़ी', 'शीशम', 'नक्काशी', 'पेटी', 'हस्तशिल्प'],
        ),
        'mr': CatalogContent(
          title: 'शिसम लाकडाची नक्षीदार कोरीव पेटी',
          shortDesc: 'पितळी कलाकुसर असलेली पारंपरिक हाताने कोरलेली लाकडी पेटी.',
          description: 'उच्च दर्जाच्या शिसम लाकडावर हाताने केलेली बारीक नक्षी आणि नैसर्गिक चमक. दागिने व मौल्यवान वस्तू ठेवण्यासाठी उत्तम.',
          heritageStory: 'कोकण व पश्चिम घाटातील लाकूड कोरीवकाम ही शतकानुशतके चालत आलेली कला आहे.',
          keywords: ['लाकडी पेटी', 'शिसम', 'कोरीवकाम', 'हस्तकला'],
        ),
        'en': CatalogContent(
          title: 'Handcrafted Carved Sheesham Wood Box',
          shortDesc: 'Intricate hand-carved wooden keepsake box with brass inlays.',
          description: 'A beautifully hand-carved wooden decorative box featuring traditional Indian floral motifs and polished natural sheen.',
          heritageStory: 'Wood carving has been a cherished tradition in Western Ghats for centuries.',
          keywords: ['Wooden', 'Handcrafted', 'Sheesham', 'Carving'],
        ),
      },
      pricing: PricingInfo(
        recommended: 2499,
        minimum: 1800,
        marketLow: 2000,
        marketHigh: 3000,
        confidenceScore: 0.89,
        productionCost: 1100,
        factors: ['Seasoned Sheesham Wood', 'Hand Carving Labor', 'Natural Wax Polish'],
      ),
      metadata: ProductMetadata(
        category: 'Woodcraft',
        subcategory: 'Decorative Box',
        craftType: 'Wood Carving',
        material: 'Sheesham Wood',
        color: 'Natural Brown',
        origin: 'Maharashtra',
        region: 'Konkan',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ProductModel(
      id: 'prod_005',
      artisanId: 'artisan_003',
      status: 'published',
      originalImageUrl: 'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?auto=format&fit=crop&w=1000&q=80',
      enhancedImageUrl: 'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?auto=format&fit=crop&w=1000&q=80',
      catalog: {
        'hi': CatalogContent(
          title: 'ढोकरा लॉस्ट-वैक्स पीतल की आदिवासी मूर्ति',
          shortDesc: '4000 वर्ष पुरानी धातु ढलाई तकनीक से बना शाही हाथी शिल्प।',
          description: 'बस्तर के आदिवासी शिल्पकारों द्वारा मोम और धातु के मिश्रण से निर्मित। प्रत्येक मूर्ति एकल सांचे में अद्वितीय बनती है।',
          heritageStory: 'ढोकरा धातु शिल्प मोहनजोदड़ो की नृत्य करती लड़की (Dancing Girl) के समय से निरंतर चला आ रहा है।',
          keywords: ['ढोकरा', 'पीतल', 'धातु शिल्प', 'बस्तर', 'आदिवासी कला'],
        ),
        'mr': CatalogContent(
          title: 'ढोकरा ब्रास पारंपारिक धातू शिल्प',
          shortDesc: 'मेणाच्या साच्यातून घडवलेले प्राचीन आदिवासी पितळी शिल्प.',
          description: 'बस्तरच्या कुशल आदिवासी कलाकारांनी पूर्णपणे हाताने घडवलेले. प्रत्येक कलाकृती एकुलती एक व अद्वितीय असते.',
          heritageStory: 'ढोकरा धातूकाम ही ४००० वर्षांपूर्वीच्या सिंधू संस्कृतीपासून चालत आलेली प्राचीन भारतीय कला आहे.',
          keywords: ['ढोकरा', 'पितळ शिल्प', 'आदिवासी कला', 'धातूकाम'],
        ),
        'en': CatalogContent(
          title: 'Dhokra Lost-Wax Cast Brass Tribal Figurine',
          shortDesc: 'Ancient bell-metal casting figurine depicting royal heritage craft.',
          description: 'Crafted using the non-ferrous lost-wax casting technique that has been practiced continuously for over 4,000 years.',
          heritageStory: 'Dhokra Damar tribes are traditional metal smiths of Central India.',
          keywords: ['Dhokra', 'Brass', 'Metalwork', 'Lost-Wax', 'Tribal Art'],
        ),
      },
      pricing: PricingInfo(
        recommended: 3200,
        minimum: 2600,
        marketLow: 2800,
        marketHigh: 3900,
        confidenceScore: 0.91,
        productionCost: 1500,
        factors: ['Pure Brass & Bell Metal', 'Beeswax Modeling Process', 'Single-Piece Casting'],
      ),
      metadata: ProductMetadata(
        category: 'Jewellery',
        subcategory: 'Metal Craft',
        craftType: 'Dhokra Metalwork',
        material: 'Bell Metal Brass',
        color: 'Antique Gold',
        origin: 'Chhattisgarh',
        region: 'Bastar',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ProductModel(
      id: 'prod_006',
      artisanId: 'artisan_004',
      status: 'published',
      originalImageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1000&q=80',
      enhancedImageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1000&q=80',
      catalog: {
        'hi': CatalogContent(
          title: 'वारली आदिवासी पारंपरिक कैनवास पेंटिंग',
          shortDesc: 'चावल के पेस्ट से गेरू कैनवास पर बनी पारंपरिक फसल उत्सव पेंटिंग।',
          description: 'पालघर की सह्याद्रि पहाड़ियों के कलाकारों द्वारा बनाई गई। प्रकृति, फसल और तारपा नृत्य का सुंदर चित्रांकन।',
          heritageStory: 'वारली कला 10वीं शताब्दी ईस्वी से महाराष्ट्र के आदिवासी समुदायों द्वारा सहेजी गई लोक कला है।',
          keywords: ['वारली', 'पेंटिंग', 'लोक कला', 'कैनवास', 'महाराष्ट्र'],
        ),
        'mr': CatalogContent(
          title: 'वारली आदिवासी पारंपारिक कॅनव्हास चित्रकला',
          shortDesc: 'तांदळाच्या पिठाच्या नैसर्गिक रंगात काढलेले तारपा नृत्य चित्र.',
          description: 'पालघरच्या वारली कलाकारांनी गेरूच्या नैसर्गिक पार्श्वभूमीवर रेखाटलेले. निसर्ग आणि मानवी जीवनाचा सुंदर मेळ.',
          heritageStory: 'वारली चित्रकला ही महाराष्ट्राच्या सह्याद्री परिसरातील १०व्या शतकापासूनची समृद्ध आदिवासी लोककला आहे.',
          keywords: ['वारली', 'चित्रकला', 'आदिवासी कला', 'लोककला'],
        ),
        'en': CatalogContent(
          title: 'Warli Tribal Folk Painting on Handmade Canvas',
          shortDesc: 'Original rice paste canvas painting celebrating harvest festival dance.',
          description: 'Painted with natural white pigment made from rice paste and gum on an earthy red ochre prepared background.',
          heritageStory: 'Warli painting is a sacred tribal art style practiced in northern Sahyadri range of Maharashtra.',
          keywords: ['Warli', 'Folk Art', 'Painting', 'Tribal', 'Handmade Canvas'],
        ),
      },
      pricing: PricingInfo(
        recommended: 1899,
        minimum: 1500,
        marketLow: 1600,
        marketHigh: 2500,
        confidenceScore: 0.94,
        productionCost: 650,
        factors: ['Natural Rice Pigment', 'Handmade Khadi Canvas', 'Master Folk Painter Detail'],
      ),
      metadata: ProductMetadata(
        category: 'Paintings',
        subcategory: 'Folk Art',
        craftType: 'Warli Painting',
        material: 'Rice Paste & Khadi Canvas',
        color: 'Red Ochre & White',
        origin: 'Maharashtra',
        region: 'Palghar',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];
}

class CatalogContent {
  final String title;
  final String shortDesc;
  final String description;
  final String heritageStory;
  final List<String> keywords;
  final String? seoTitle;
  final String? metaDescription;

  CatalogContent({
    required this.title,
    required this.shortDesc,
    required this.description,
    required this.heritageStory,
    required this.keywords,
    this.seoTitle,
    this.metaDescription,
  });

  factory CatalogContent.fromMap(Map<String, dynamic> map) {
    return CatalogContent(
      title: map['title'] ?? '',
      shortDesc: map['short_desc'] ?? '',
      description: map['description'] ?? '',
      heritageStory: map['heritage_story'] ?? '',
      keywords: List<String>.from(map['keywords'] ?? []),
      seoTitle: map['seo_title'],
      metaDescription: map['meta_description'],
    );
  }
}

class PricingInfo {
  final double recommended;
  final double minimum;
  final double marketLow;
  final double marketHigh;
  final double confidenceScore;
  final double productionCost;
  final List<String> factors;

  PricingInfo({
    required this.recommended,
    required this.minimum,
    required this.marketLow,
    required this.marketHigh,
    required this.confidenceScore,
    required this.productionCost,
    required this.factors,
  });

  factory PricingInfo.fromMap(Map<String, dynamic> map) {
    return PricingInfo(
      recommended: (map['recommended'] ?? 0).toDouble(),
      minimum: (map['minimum'] ?? 0).toDouble(),
      marketLow: (map['market_low'] ?? 0).toDouble(),
      marketHigh: (map['market_high'] ?? 0).toDouble(),
      confidenceScore: (map['confidence_score'] ?? 0).toDouble(),
      productionCost: (map['production_cost'] ?? 0).toDouble(),
      factors: List<String>.from(map['factors'] ?? []),
    );
  }
}

class ProductMetadata {
  final String category;
  final String subcategory;
  final String craftType;
  final String material;
  final String color;
  final String origin;
  final String region;

  ProductMetadata({
    required this.category,
    required this.subcategory,
    required this.craftType,
    required this.material,
    required this.color,
    required this.origin,
    required this.region,
  });

  factory ProductMetadata.fromMap(Map<String, dynamic> map) {
    return ProductMetadata(
      category: map['category'] ?? '',
      subcategory: map['subcategory'] ?? '',
      craftType: map['craft_type'] ?? '',
      material: map['material'] ?? '',
      color: map['color'] ?? '',
      origin: map['origin'] ?? '',
      region: map['region'] ?? '',
    );
  }
}
