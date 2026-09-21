// lib/features/products/screens/multilingual_catalog_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_localizations.dart';
import '../../../core/constants/app_craft_images.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../models/product_model.dart';

class MultilingualCatalogScreen extends StatefulWidget {
  final ProductModel? product;

  const MultilingualCatalogScreen({super.key, this.product});

  @override
  State<MultilingualCatalogScreen> createState() => _MultilingualCatalogScreenState();
}

class _MultilingualCatalogScreenState extends State<MultilingualCatalogScreen> {
  late String _activeLang;

  @override
  void initState() {
    super.initState();
    _activeLang = Provider.of<UserProfileProvider>(context, listen: false).selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final appLang = context.watch<UserProfileProvider>().selectedLanguage;
    final p = widget.product ?? ProductModel.demoProducts.first;

    final catalogContent = p.catalog[_activeLang] ??
        p.catalog['hi'] ??
        p.catalog['en'] ??
        CatalogContent(
          title: 'Handcrafted Heritage Art',
          shortDesc: 'Traditional artisan craft',
          description: 'Meticulously shaped by skilled rural artisans using authentic techniques.',
          heritageStory: 'Centuries of indigenous artisan tradition.',
          keywords: ['Handmade', 'ShilpSetu', 'Artisan', 'Heritage'],
        );

    final String categoryVal = _getLocalizedAttribute('category', p.metadata.category, _activeLang);
    final String materialVal = _getLocalizedAttribute('material', p.metadata.material, _activeLang);
    final String craftVal = _getLocalizedAttribute('craft', p.metadata.craftType, _activeLang);
    final String originVal = _getLocalizedAttribute('origin', p.metadata.origin, _activeLang);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.tr('multilingual_catalog_title', appLang),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 14, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.tr('ai_translated_tag', appLang),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Interactive Language Switcher Tabs ─────────────────
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
                ),
                child: Row(
                  children: [
                    _buildLangTab('hi', 'हिंदी'),
                    _buildLangTab('mr', 'मराठी'),
                    _buildLangTab('en', 'English'),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Main Craft Card ────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.outline),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Craft Image with Verified Badge
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: AppCraftImages.buildCraftImage(
                            imageUrl: p.originalImageUrl,
                            categoryOrTitle: '${p.title} ${p.metadata.category}',
                            height: 240,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.outline),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.tr('verified_craft', _activeLang),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Craft Title
                    Text(
                      catalogContent.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),

                    const SizedBox(height: 8),

                    // Craft Description
                    Text(
                      catalogContent.description.isNotEmpty ? catalogContent.description : catalogContent.shortDesc,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                    ),

                    const SizedBox(height: 16),

                    // AI Keywords Section
                    Text(
                      AppLocalizations.tr('ai_keywords_label', _activeLang).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: catalogContent.keywords.map((kw) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Text(
                            kw,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 18),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 14),

                    // Attributes 2x2 Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildAttributeBox(
                            label: AppLocalizations.tr('category_label', _activeLang),
                            value: categoryVal,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildAttributeBox(
                            label: AppLocalizations.tr('material_label', _activeLang),
                            value: materialVal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAttributeBox(
                            label: AppLocalizations.tr('craft_label', _activeLang),
                            value: craftVal,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildAttributeBox(
                            label: AppLocalizations.tr('origin_label', _activeLang),
                            value: originVal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Continue to Heritage Story Button ──────────────────
              ElevatedButton(
                onPressed: () {
                  context.push('/heritage_story', extra: p);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.tr('continue_heritage', appLang),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangTab(String code, String label) {
    final isSelected = _activeLang == code;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeLang = code;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttributeBox({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.sandLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sandDark.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getLocalizedAttribute(String type, String defaultValue, String lang) {
    if (type == 'category') {
      if (lang == 'hi') return 'हस्तशिल्प व परिधान';
      if (lang == 'mr') return 'हस्तकला व पारंपरिक वस्त्र';
      return defaultValue;
    }
    if (type == 'material') {
      if (lang == 'hi') return 'प्राकृतिक व प्रामाणिक सामग्री';
      if (lang == 'mr') return 'अस्सल नैसर्गिक साहित्य';
      return defaultValue;
    }
    if (type == 'craft') {
      if (lang == 'hi') return 'पारंपरिक हस्तकौशल';
      if (lang == 'mr') return 'पारंपारिक हातकाम';
      return defaultValue;
    }
    if (type == 'origin') {
      if (lang == 'hi') return 'महाराष्ट्र, भारत';
      if (lang == 'mr') return 'महाराष्ट्र, भारत';
      return defaultValue;
    }
    return defaultValue;
  }
}
