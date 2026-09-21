import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/product_provider.dart';
import '../../../core/providers/buyer_request_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/constants/app_craft_images.dart';

class DigitalMelaScreen extends StatefulWidget {
  const DigitalMelaScreen({super.key});

  @override
  State<DigitalMelaScreen> createState() => _DigitalMelaScreenState();
}

class _DigitalMelaScreenState extends State<DigitalMelaScreen> {
  String _selectedCollection = 'Maharashtra Crafts';

  final List<Map<String, dynamic>> _collections = const [
    {
      'id': 'maharashtra',
      'titleEn': 'Maharashtra Crafts',
      'titleMr': 'महाराष्ट्र हस्तकला दालन',
      'titleHi': 'महाराष्ट्र हस्तशिल्प दीर्घा',
      'subtitleEn': 'Paithani, Warli & Kolhapuri Art',
      'subtitleMr': 'पैठणी, वारली व कोल्हापुरी कला',
      'subtitleHi': 'पैठणी, वारली एवं कोल्हापुरी कला',
      'emoji': '🏺',
      'color': AppColors.primary,
      'count': 18,
    },
    {
      'id': 'women',
      'titleEn': "Women's Artisan Guild",
      'titleMr': 'महिला कारागीर महासंघ',
      'titleHi': 'महिला कारीगर महासंघ',
      'subtitleEn': 'Crafted by rural women collectives',
      'subtitleMr': 'ग्रामीण महिला बचत गटांचे हस्तशिल्प',
      'subtitleHi': 'ग्रामीण महिला स्वयं सहायता समूहों का शिल्प',
      'emoji': '👩‍🎨',
      'color': AppColors.secondary,
      'count': 24,
    },
    {
      'id': 'handloom',
      'titleEn': 'Traditional Handloom',
      'titleMr': 'पारंपरिक हातमाग वस्त्रदालन',
      'titleHi': 'पारंपरिक हथकरघा वस्त्र',
      'subtitleEn': 'Pure silk & organic cotton weaves',
      'subtitleMr': 'शुद्ध रेशीम व सुती हातमाग कलाकृती',
      'subtitleHi': 'शुद्ध रेशम और जैविक सूती वस्त्र',
      'emoji': '🧵',
      'color': AppColors.primaryLight,
      'count': 32,
    },
    {
      'id': 'pottery',
      'titleEn': 'Tribal Earth & Pottery',
      'titleMr': 'आदिवासी माती व धातू शिल्प',
      'titleHi': 'जनजातीय मृदा एवं धातु शिल्प',
      'subtitleEn': 'Natural riverbed terracotta & brass',
      'subtitleMr': 'नैसर्गिक नदीकाठची माती व पितळ मूर्ती',
      'subtitleHi': 'प्राकृतिक चिकनी मिट्टी व पीतल शिल्प',
      'emoji': '🗿',
      'color': AppColors.tertiary,
      'count': 15,
    },
    {
      'id': 'festive',
      'titleEn': 'Festive Heritage Gifts',
      'titleMr': 'उत्सवी भेटवस्तू व सजावट',
      'titleHi': 'त्योहारी उपहार एवं सजावट',
      'subtitleEn': 'Curated handcrafted festival gifts',
      'subtitleMr': 'दिवाळी व उत्सवांसाठी निवडक हस्तकला',
      'subtitleHi': 'त्योहारों के लिए विशेष हस्तशिल्प',
      'emoji': '🪔',
      'color': AppColors.secondaryDark,
      'count': 29,
    },
  ];

  String _t(String lang, {required String en, required String mr, required String hi}) {
    if (lang == 'mr') return mr;
    if (lang == 'hi') return hi;
    return en;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final lang = context.watch<UserProfileProvider>().selectedLanguage;
    final products = productProvider.publishedProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── ShilpSetu Digital Mela Hero ──────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🎪', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 6),
                      Text(
                        _t(
                          lang,
                          en: 'ShilpSetu Digital Mela',
                          mr: 'शिल्पसेतू डिजिटल मेळा',
                          hi: 'शिल्पसेतु डिजिटल मेला',
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _t(
                          lang,
                          en: 'Virtual National Exhibition & Wholesale Pavilion',
                          mr: 'राष्ट्रीय आभासी हस्तकला प्रदर्शन व घाऊक दालन',
                          hi: 'राष्ट्रीय आभासी हस्तशिल्प प्रदर्शनी एवं थोक मंडप',
                        ),
                        style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live Pavilion Status Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _t(
                              lang,
                              en: 'LIVE PAVILION: Ministry of Handicrafts & Heritage Stalls',
                              mr: 'थेट दालन: वस्त्रोद्योग व हस्तकला मंत्रालय राष्ट्रीय प्रदर्शन',
                              hi: 'लाइव मंडप: हस्तशिल्प एवं हथकरघा राष्ट्रीय प्रदर्शनी',
                            ),
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(
                    _t(
                      lang,
                      en: 'Featured Exhibition Halls',
                      mr: 'प्रमुख प्रदर्शन दालने',
                      hi: 'प्रमुख प्रदर्शनी मंडप',
                    ),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),

                  // Horizontal collections selector
                  SizedBox(
                    height: 115,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _collections.length,
                      itemBuilder: (context, index) {
                        final col = _collections[index];
                        final isSelected = col['titleEn'] == _selectedCollection;

                        final colTitle = _t(lang, en: col['titleEn'], mr: col['titleMr'], hi: col['titleHi']);
                        final colSub = _t(lang, en: col['subtitleEn'], mr: col['subtitleMr'], hi: col['subtitleHi']);

                        return GestureDetector(
                          onTap: () => setState(() => _selectedCollection = col['titleEn']),
                          child: Container(
                            width: 175,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? col['color'] : AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? col['color'] : AppColors.outlineVariant,
                                width: isSelected ? 2.5 : 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.cardShadow,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(col['emoji'], style: const TextStyle(fontSize: 24)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withValues(alpha: 0.22)
                                            : AppColors.surfaceContainer,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${col['count']} ${_t(lang, en: 'stalls', mr: 'स्टॉल्स', hi: 'स्टॉल')}',
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : AppColors.textLight,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  colTitle,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  colSub,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white70 : AppColors.textLight,
                                    fontSize: 10.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _t(
                          lang,
                          en: 'Exhibition Crafts & Masterpieces',
                          mr: 'प्रदर्शनातील विशेष कलाकृती',
                          hi: 'प्रदर्शनी के विशेष हस्तशिल्प',
                        ),
                        style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      Text(
                        '${products.length} ${_t(lang, en: 'Active', mr: 'उपलब्ध', hi: 'उपलब्ध')}',
                        style: const TextStyle(color: AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Showcase items
                  ...products.map((prod) {
                    final title = prod.localizedTitle(lang);
                    final price = prod.price;
                    final category = prod.metadata.category;
                    final story = prod.catalog[lang]?.heritageStory ??
                        prod.catalog['en']?.heritageStory ??
                        'Preserving age-old craft techniques.';
                    final displayImage = (prod.enhancedImageUrl != null && prod.enhancedImageUrl!.isNotEmpty)
                        ? prod.enhancedImageUrl
                        : prod.originalImageUrl;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.outlineVariant),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: AppCraftImages.buildCraftImage(
                                    imageUrl: displayImage,
                                    categoryOrTitle: '$title $category',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      category,
                                      style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      price,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Heritage story snippet
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.auto_stories, size: 18, color: AppColors.tertiary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    story,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Listen to story audio button
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    context.push('/heritage_story', extra: prod);
                                  },
                                  icon: const Icon(
                                    Icons.volume_up_outlined,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  label: Text(
                                    _t(lang, en: 'Audio Story', mr: 'वारसा गोष्ट', hi: 'विरासत कथा'),
                                    style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    side: const BorderSide(color: AppColors.primary),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Request bulk order button
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _showBulkOrderDialog(context, prod, title, price, lang),
                                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                                  label: Text(
                                    _t(lang, en: 'Bulk Inquiry', mr: 'घाऊक मागणी', hi: 'थोक मांग'),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBulkOrderDialog(BuildContext context, dynamic product, String title, String price, String lang) {
    final qtyController = TextEditingController(text: '30');
    final orgController = TextEditingController(text: 'National Handicraft Emporium');
    final msgController = TextEditingController(
      text: _t(
        lang,
        en: 'Exhibition bulk procurement: Requesting 30 pieces for our festive regional showcase.',
        mr: 'प्रदर्शनासाठी घाऊक मागणी: आमच्या उत्सवी विक्रीसाठी ३० वस्तूंची आवश्यकता आहे.',
        hi: 'प्रदर्शनी थोक खरीद: हमारे त्यौहारी विक्रय के लिए ३० नग की आवश्यकता है।',
      ),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          _t(lang, en: 'Digital Mela Bulk Inquiry', mr: 'डिजिटल मेळा घाऊक मागणी', hi: 'डिजिटल मेला थोक मांग'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_t(lang, en: 'Craft', mr: 'वस्तू', hi: 'उत्पाद')}: $title',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: orgController,
                decoration: InputDecoration(
                  labelText: _t(lang, en: 'Buyer / Retailer Name', mr: 'खरेदीदार / संस्थेचे नाव', hi: 'खरीदार / संस्था का नाम'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _t(lang, en: 'Quantity (Units)', mr: 'नग संख्या (Quantity)', hi: 'मात्रा (नग)'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: msgController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: _t(lang, en: 'Inquiry Note', mr: 'मागणीचा संदेश', hi: 'पूछताछ संदेश'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_t(lang, en: 'Cancel', mr: 'रद्द करा', hi: 'रद्द करें')),
          ),
          ElevatedButton(
            onPressed: () {
              final newRequest = BuyerRequestModel(
                id: 'mela_${DateTime.now().millisecondsSinceEpoch}',
                buyerName: orgController.text.trim().isNotEmpty ? orgController.text.trim() : 'Digital Mela Buyer',
                buyerOrg: orgController.text.trim(),
                buyerLocation: 'National Exhibition',
                productId: product.id,
                productTitle: title,
                productPrice: price,
                quantity: int.tryParse(qtyController.text.trim()) ?? 30,
                expectedDelivery: 'Exhibition Timeline (15 Days)',
                message: msgController.text.trim(),
                status: 'pending',
                createdAt: DateTime.now(),
              );

              context.read<BuyerRequestProvider>().submitRequest(newRequest);
              Navigator.pop(ctx);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _t(
                      lang,
                      en: '✅ Bulk inquiry submitted via ShilpSetu Digital Mela!',
                      mr: '✅ शिल्पसेतू डिजिटल मेळा द्वारे घाऊक मागणी सादर केली!',
                      hi: '✅ शिल्पसेतु डिजिटल मेला द्वारा थोक मांग प्रेषित की गई!',
                    ),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              _t(lang, en: 'Submit Inquiry', mr: 'मागणी पाठवा', hi: 'मांग भेजें'),
            ),
          ),
        ],
      ),
    );
  }
}
