# scratch/patch_grid.py
file_path = r"c:\Users\Sunny\AndroidStudioProjects\ShilpSetu_AI\mobile_app\lib\features\products\screens\my_products_screen.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

target = """    return ListView.builder(
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
}"""

replacement = """    // 2-Column Responsive Grid Layout (Automatically expands in rows as products are added)
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

assert target in content, "Target code not found in file"
content = content.replace(target, replacement)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Updated my_products_screen.dart to 2-column grid successfully!")
