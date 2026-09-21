// lib/features/buyers/screens/buyer_portal_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/product_provider.dart';
import '../../../core/providers/buyer_request_provider.dart';
import '../../../core/providers/shortlist_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../models/product_model.dart';
import '../../../core/constants/app_craft_images.dart';
import '../../../core/constants/app_localizations.dart';

class BuyerPortalScreen extends StatefulWidget {
  const BuyerPortalScreen({super.key});

  @override
  State<BuyerPortalScreen> createState() => _BuyerPortalScreenState();
}

class _BuyerPortalScreenState extends State<BuyerPortalScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'Textiles',
    'Pottery',
    'Woodcraft',
    'Jewellery',
    'Paintings',
    'Metal Craft',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<UserProfileProvider>().selectedLanguage;
    final productProvider = context.watch<ProductProvider>();
    final shortlistProvider = context.watch<ShortlistProvider>();
    final requestProvider = context.watch<BuyerRequestProvider>();
    final publishedProducts = productProvider.publishedProducts;

    // Filter products
    final filtered = publishedProducts.where((p) {
      final title = p.localizedTitle(lang);
      final category = p.metadata.category;
      final matchesCat = _selectedCategory == 'All' ||
          category.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
          title.toLowerCase().contains(_selectedCategory.toLowerCase());
      final query = _searchController.text.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          title.toLowerCase().contains(query) ||
          category.toLowerCase().contains(query);
      return matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.primary,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.storefront, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'SHILPSETU B2B',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        AppLocalizations.t(
                          lang,
                          en: 'Wholesale Sourcing & Artisan Discovery',
                          mr: 'घाऊक खरेदी व कारागीर शोध',
                          hi: 'थोक खरीद एवं कारीगर खोज',
                        ),
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                tooltip: 'Buyer Account',
                onSelected: (val) async {
                  if (val == 'logout') {
                    await context.read<UserProfileProvider>().clearProfile();
                    if (context.mounted) context.go('/login');
                  }
                },
                itemBuilder: (ctx) {
                  final profile = context.read<UserProfileProvider>().profile;
                  return [
                    PopupMenuItem(
                      enabled: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.businessName.isNotEmpty
                                ? profile.businessName
                                : (profile.name.isNotEmpty ? profile.name : 'B2B Wholesale Buyer'),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            profile.email.isNotEmpty ? profile.email : 'Verified Procurement Partner',
                            style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Log Out', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ];
                },
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(114),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(fontSize: 13.5),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.t(
                            lang,
                            en: 'Search authentic crafts, textiles, pottery...',
                            mr: 'अस्सल हस्तकला, वस्त्रे, मातीकाम शोधा...',
                            hi: 'प्रामाणिक हस्तशिल्प, वस्त्र, मिट्टी के शिल्प खोजें...',
                          ),
                          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 12.5),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
                          prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  // Tabs
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: [
                      Tab(text: AppLocalizations.t(lang, en: 'Discover', mr: 'शोधा', hi: 'खोजें')),
                      Tab(text: '${AppLocalizations.t(lang, en: 'Shortlist', mr: 'पसंती', hi: 'शॉर्टलिस्ट')} (${shortlistProvider.shortlistedIds.length})'),
                      Tab(text: '${AppLocalizations.t(lang, en: 'Requests', mr: 'मागण्या', hi: 'मांगें')} (${requestProvider.requests.length})'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Discover
            _buildDiscoverTab(filtered, shortlistProvider),

            // Tab 2: Shortlist
            _buildShortlistTab(publishedProducts, shortlistProvider),

            // Tab 3: Requests
            _buildRequestsTab(requestProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverTab(List<ProductModel> products, ShortlistProvider shortlist) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Category filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // AI B2B Recommendation Banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Recommendations for Your Store ✨',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      'Verified GI-tagged textiles and organic pottery trending with 92% high buyer reorder rate.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Products Grid
        Padding(
          padding: const EdgeInsets.all(16),
          child: products.isEmpty
              ? _buildEmptyState('No products match this category')
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.64,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];
                    return _ProductCard(
                      product: item,
                      isShortlisted: shortlist.isShortlisted(item.id),
                      onToggleShortlist: () => shortlist.toggleShortlist(item.id),
                      onTap: () => _showProductDetailsModal(context, item),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildShortlistTab(List<ProductModel> allProducts, ShortlistProvider shortlist) {
    final shortlisted = allProducts.where((p) => shortlist.isShortlisted(p.id)).toList();

    if (shortlisted.isEmpty) {
      return _buildEmptyState('Your shortlist is empty.\nTap the heart icon on any craft to save it here.');
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.64,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: shortlisted.length,
      itemBuilder: (context, index) {
        final item = shortlisted[index];
        return _ProductCard(
          product: item,
          isShortlisted: true,
          onToggleShortlist: () => shortlist.toggleShortlist(item.id),
          onTap: () => _showProductDetailsModal(context, item),
        );
      },
    );
  }

  Widget _buildRequestsTab(BuyerRequestProvider requestProvider) {
    final requests = requestProvider.requests;

    if (requests.isEmpty) {
      return _buildEmptyState('No bulk order requests submitted yet.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      req.productTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: req.status == 'accepted' ? Colors.green.shade50 : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      req.status.toUpperCase(),
                      style: TextStyle(
                        color: req.status == 'accepted' ? Colors.green.shade800 : Colors.amber.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Quantity: ${req.quantity} units • Delivery: ${req.expectedDelivery}',
                  style: TextStyle(color: AppColors.textLight, fontSize: 12)),
              const SizedBox(height: 6),
              Text('"${req.message}"',
                  style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 54, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetailsModal(BuildContext context, ProductModel product) {
    final title = product.title;
    final price = product.price;
    final category = product.metadata.category.isNotEmpty ? product.metadata.category : 'Traditional Crafts';
    final story = product.catalog['en']?.heritageStory ??
        product.catalog.values.firstOrNull?.heritageStory ??
        'Handcrafted using traditional methods preserved over generations.';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppCraftImages.buildCraftImage(
                  imageUrl: product.originalImageUrl,
                  categoryOrTitle: '$title $category',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 18),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(price,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Chip(label: Text(category)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Cultural Heritage Story', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(story, style: const TextStyle(fontSize: 13, height: 1.5)),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/multilingual_catalog', extra: product);
                },
                icon: const Icon(Icons.translate_rounded, size: 18),
                label: const Text('View 3-Language Catalog (मराठी, हिंदी, English)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showBulkOrderDialog(context, product);
                },
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('Request Bulk Order / Wholesale Quote'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBulkOrderDialog(BuildContext context, ProductModel product) {
    final title = product.title;
    final price = product.price;

    final qtyController = TextEditingController(text: '25');
    final orgController = TextEditingController(text: 'Urban Lifestyle Boutique');
    final deliveryController = TextEditingController(text: 'Next Month (Diwali Season)');
    final msgController = TextEditingController(
      text: 'Interested in placing a bulk trial order of 25 pieces for our retail showrooms in Mumbai and Pune.',
    );

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Request Bulk Order', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product: $title', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 12),
              TextField(
                controller: orgController,
                decoration: InputDecoration(
                  labelText: 'Company / Organization Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Required Quantity (Units)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deliveryController,
                decoration: InputDecoration(
                  labelText: 'Expected Delivery Timeline',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: msgController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Message / Specifications to Artisan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newRequest = BuyerRequestModel(
                id: 'req_${DateTime.now().millisecondsSinceEpoch}',
                buyerName: 'Procurement Manager',
                buyerOrg: orgController.text.trim().isNotEmpty ? orgController.text.trim() : 'Corporate Buyer',
                buyerLocation: 'Mumbai, Maharashtra',
                productId: product.id,
                productTitle: title,
                productPrice: price,
                quantity: int.tryParse(qtyController.text.trim()) ?? 25,
                expectedDelivery: deliveryController.text.trim(),
                message: msgController.text.trim(),
                status: 'pending',
                createdAt: DateTime.now(),
              );

              context.read<BuyerRequestProvider>().submitRequest(newRequest);
              Navigator.of(dialogCtx).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Bulk order request logged and sent to artisan!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isShortlisted;
  final VoidCallback onToggleShortlist;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.isShortlisted,
    required this.onToggleShortlist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<UserProfileProvider>().selectedLanguage;
    final title = product.localizedTitle(lang);
    final price = product.price;
    final category = product.metadata.category.isNotEmpty ? product.metadata.category : 'Traditional Crafts';
    final displayImage = (product.enhancedImageUrl != null && product.enhancedImageUrl!.isNotEmpty)
        ? product.enhancedImageUrl
        : product.originalImageUrl;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: AppCraftImages.buildCraftImage(
                      imageUrl: displayImage,
                      categoryOrTitle: '$title $category',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onToggleShortlist,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isShortlisted ? Icons.favorite : Icons.favorite_border,
                          color: isShortlisted ? Colors.red : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          category,
                          style: const TextStyle(color: AppColors.textLight, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
