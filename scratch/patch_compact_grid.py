# scratch/patch_compact_grid.py
file_path = r"c:\Users\Sunny\AndroidStudioProjects\ShilpSetu_AI\mobile_app\lib\features\products\screens\my_products_screen.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

target = """    // 2-Column Responsive Grid Layout (Automatically expands in rows as products are added)
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
      ),
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
        : (product.status == 'draft' ? Colors.orange.shade800 : Colors.grey);

    final statusText = product.status == 'published'
        ? _t(en: 'Active', mr: 'सुरू', hi: 'सक्रिय')
        : (product.status == 'draft'
            ? _t(en: 'Draft', mr: 'मसुदा', hi: 'ड्राफ्ट')
            : _t(en: 'Archived', mr: 'संग्रहित', hi: 'संग्रहित'));

    final displayTitle = product.localizedTitle(lang);
    final displayImage = (product.enhancedImageUrl != null && product.enhancedImageUrl!.isNotEmpty)
        ? product.enhancedImageUrl
        : product.originalImageUrl;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.8)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/multilingual_catalog', extra: product),
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Craft Image with Floating Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: SizedBox(
                      height: 125,
                      width: double.infinity,
                      child: AppCraftImages.buildCraftImage(
                        imageUrl: displayImage,
                        categoryOrTitle: '${product.title} ${product.metadata.category}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Status Badge (Top Right)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.status == 'published'
                                ? Icons.check_circle_rounded
                                : Icons.edit_note_rounded,
                            size: 11,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            statusText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Craft Type Pill (Top Left)
                  if (product.metadata.craftType.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        constraints: const BoxConstraints(maxWidth: 85),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.metadata.craftType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),

              // Product Info & Action Buttons
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 11, color: AppColors.primary),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  product.metadata.origin.isNotEmpty ? product.metadata.origin : 'India',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.price,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),

                      // Action Buttons Row (360° Catalog & Story)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.push('/multilingual_catalog', extra: product),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                minimumSize: const Size(0, 30),
                                side: const BorderSide(color: AppColors.primary, width: 1.2),
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                _t(en: '360°', mr: 'कॅटलॉग', hi: 'कैटलॉग'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => context.push('/heritage_story', extra: product),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                minimumSize: const Size(0, 30),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                _t(en: 'Story', mr: 'वारसा', hi: 'विरासत'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}"""

replacement = """    // Compact 2-Column Grid Layout (Optimized aspect ratio to eliminate wasted space)
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 85),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
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
        : (product.status == 'draft' ? Colors.orange.shade800 : Colors.grey);

    final statusText = product.status == 'published'
        ? _t(en: 'Active', mr: 'सुरू', hi: 'सक्रिय')
        : (product.status == 'draft'
            ? _t(en: 'Draft', mr: 'मसुदा', hi: 'ड्राफ्ट')
            : _t(en: 'Archived', mr: 'संग्रहित', hi: 'संग्रहित'));

    final displayTitle = product.localizedTitle(lang);
    final displayImage = (product.enhancedImageUrl != null && product.enhancedImageUrl!.isNotEmpty)
        ? product.enhancedImageUrl
        : product.originalImageUrl;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.7)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/multilingual_catalog', extra: product),
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Craft Image with Floating Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: SizedBox(
                      height: 105,
                      width: double.infinity,
                      child: AppCraftImages.buildCraftImage(
                        imageUrl: displayImage,
                        categoryOrTitle: '${product.title} ${product.metadata.category}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Status Badge (Top Right)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 3),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.status == 'published'
                                ? Icons.check_circle_rounded
                                : Icons.edit_note_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            statusText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Craft Type Pill (Top Left)
                  if (product.metadata.craftType.isNotEmpty)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        constraints: const BoxConstraints(maxWidth: 80),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          product.metadata.craftType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),

              // Product Info & Action Buttons
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              height: 1.15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 10, color: AppColors.primary),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  product.metadata.origin.isNotEmpty ? product.metadata.origin : 'India',
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.price,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),

                      // Action Buttons Row (360° Catalog & Story)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.push('/multilingual_catalog', extra: product),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                minimumSize: const Size(0, 26),
                                side: const BorderSide(color: AppColors.primary, width: 1),
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              child: Text(
                                _t(en: '360°', mr: 'कॅटलॉग', hi: 'कैटलॉग'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => context.push('/heritage_story', extra: product),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                minimumSize: const Size(0, 26),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              child: Text(
                                _t(en: 'Story', mr: 'वारसा', hi: 'विरासत'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}"""

assert target in content, "Target code not found in file"
content = content.replace(target, replacement)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Applied compact grid patch successfully!")
