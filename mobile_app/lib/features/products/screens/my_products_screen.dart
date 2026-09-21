import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shilpsetu_ai/models/product_model.dart';
import 'package:shilpsetu_ai/core/providers/product_provider.dart';
import 'package:shilpsetu_ai/core/providers/user_profile_provider.dart';
import 'package:shilpsetu_ai/core/constants/app_craft_images.dart';
import 'package:shilpsetu_ai/core/constants/app_localizations.dart';
import 'package:shilpsetu_ai/core/theme/app_theme.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _t(String lang, {required String en, required String mr, required String hi}) {
    if (lang == 'mr') return mr;
    if (lang == 'hi') return hi;
    return en;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final lang = context.watch<UserProfileProvider>().selectedLanguage;
    final products = productProvider.products;
    final published = productProvider.publishedProducts;
    final drafts = productProvider.draftProducts;

    final allTabLabel = _t(lang, en: 'All', mr: 'सर्व', hi: 'सभी');
    final pubTabLabel = _t(lang, en: 'Published', mr: 'सुरू', hi: 'प्रकाशित');
    final draftTabLabel = _t(lang, en: 'Drafts', mr: 'मसुदे', hi: 'ड्राफ्ट');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.tr('my_products_label', lang),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          tabs: [
            Tab(text: '$allTabLabel (${products.length})'),
            Tab(text: '$pubTabLabel (${published.length})'),
            Tab(text: '$draftTabLabel (${drafts.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ProductGrid(products: products, lang: lang),
          _ProductGrid(products: published, lang: lang),
          _ProductGrid(products: drafts, lang: lang),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add_product'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          _t(lang, en: 'Add Craft', mr: 'वस्तू जोडा', hi: 'उत्पाद जोड़ें'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final String lang;
  const _ProductGrid({required this.products, required this.lang});

  String _t({required String en, required String mr, required String hi}) {
    if (lang == 'mr') return mr;
    if (lang == 'hi') return hi;
    return en;
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📦', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                _t(
                  en: 'No products here yet',
                  mr: 'येथे अद्याप कोणतीही उत्पादने नाहीत',
                  hi: 'यहां अभी कोई उत्पाद नहीं है',
                ),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                _t(
                  en: 'Tap "+ Add Craft" to list your heritage handicraft!',
                  mr: 'आपल्या हस्तकलेची नोंदणी करण्यासाठी "+ वस्तू जोडा" दाबा!',
                  hi: 'अपने हस्तशिल्प को जोड़ने के लिए "+ उत्पाद जोड़ें" दबाएं!',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductCard(product: products[index], lang: lang);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final String lang;
  const _ProductCard({required this.product, required this.lang});

  String _t({required String en, required String mr, required String hi}) {
    if (lang == 'mr') return mr;
    if (lang == 'hi') return hi;
    return en;
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = product.status == 'published'
        ? AppColors.success
        : (product.status == 'draft' ? Colors.orange : Colors.grey);

    final statusText = product.status == 'published'
        ? _t(en: 'Active', mr: 'सुरू', hi: 'सक्रिय')
        : (product.status == 'draft'
            ? _t(en: 'Draft', mr: 'मसुदा', hi: 'ड्राफ्ट')
            : _t(en: 'Archived', mr: 'संग्रहित', hi: 'संग्रहित'));

    final displayTitle = product.localizedTitle(lang);
    final displayDesc = product.localizedShortDesc(lang);
    final displayImage = (product.enhancedImageUrl != null && product.enhancedImageUrl!.isNotEmpty)
        ? product.enhancedImageUrl
        : product.originalImageUrl;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
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
          // Craft Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: AppCraftImages.buildCraftImage(
                imageUrl: displayImage,
                categoryOrTitle: '${product.title} ${product.metadata.category}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        displayTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.5,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  displayDesc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _InfoChip(
                      label: product.metadata.craftType,
                      icon: Icons.brush_outlined,
                    ),
                    _InfoChip(
                      label: product.metadata.origin,
                      icon: Icons.location_on_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => context.push('/multilingual_catalog', extra: product),
                          icon: const Icon(Icons.translate_rounded, size: 15),
                          label: Text(
                            _t(en: 'Catalog 360°', mr: 'कॅटलॉग ३६०°', hi: 'कैटलॉग ३६०°'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/heritage_story', extra: product),
                          icon: const Icon(Icons.menu_book_rounded, size: 15),
                          label: Text(
                            _t(en: 'Story', mr: 'वारसा', hi: 'विरासत'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
