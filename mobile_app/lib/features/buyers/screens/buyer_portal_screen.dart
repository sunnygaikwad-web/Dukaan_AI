// lib/features/buyers/screens/buyer_portal_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/product_provider.dart';
import '../../../core/providers/buyer_request_provider.dart';
import '../../../core/providers/shortlist_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/providers/chat_provider.dart';
import '../../chat/screens/chat_list_screen.dart';
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

  String _selectedRecordFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Vernacular helper for Buyer Section
  String _t(String lang, {required String en, required String mr, required String hi}) {
    if (lang == 'mr') return mr;
    if (lang == 'hi') return hi;
    return en;
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
                  if (val == 'records') {
                    _tabController.animateTo(4);
                  } else if (val == 'chat') {
                    _tabController.animateTo(2);
                  } else if (val == 'switch_artisan') {
                    context.read<UserProfileProvider>().switchRole('artisan');
                  } else if (val == 'logout') {
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
                                : (profile.name.isNotEmpty ? profile.name : 'FabIndia Sourcing Mumbai'),
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
                    PopupMenuItem(
                      value: 'chat',
                      child: Row(
                        children: [
                          const Icon(Icons.forum_outlined, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(_t(lang, en: 'Artisan Messages & Chat', mr: 'कारागीर संवाद चॅट', hi: 'कारीगर संदेश व चैट')),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'records',
                      child: Row(
                        children: [
                          const Icon(Icons.assessment_outlined, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(_t(lang, en: 'My Records & Profits', mr: 'नोंदी व नफा प्रोफाइल', hi: 'रिकॉर्ड्स व मुनाफा')),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'switch_artisan',
                      child: Row(
                        children: [
                          const Icon(Icons.swap_horiz, size: 18, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Text(_t(lang, en: 'Switch to Artisan Mode', mr: 'कारागीर मोडवर जा', hi: 'कारीगर मोड पर जाएं')),
                        ],
                      ),
                    ),
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
            bottom: _tabController.index == 0
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: SizedBox(
                        height: 42,
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
                  )
                : null,
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 0: Discover
            _buildDiscoverTab(filtered, shortlistProvider),

            // Tab 1: Shortlist
            _buildShortlistTab(publishedProducts, shortlistProvider),

            // Tab 2: Direct Communication Chat between Buyer & Artisans
            const ChatListScreen(isEmbeddedInTab: true),

            // Tab 3: Requests
            _buildRequestsTab(requestProvider),

            // Tab 4: Records & Profits / Buyer Profile
            _buildRecordsAndProfileTab(context, lang),
          ],
        ),
      ),
      bottomNavigationBar: _buildBuyerFooter(
        context: context,
        lang: lang,
        shortlistCount: shortlistProvider.shortlistedIds.length,
        chatUnreadCount: context.watch<ChatProvider>().totalUnreadForRole('buyer'),
        requestCount: requestProvider.requests.length,
      ),
    );
  }

  // ─── FOOTER NAVIGATION BAR (Matches screenshot aesthetic) ───────────────────
  Widget _buildBuyerFooter({
    required BuildContext context,
    required String lang,
    required int shortlistCount,
    required int chatUnreadCount,
    required int requestCount,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Exact deep navy/purple background
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, -3)),
        ],
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.12), width: 1),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _buildFooterTabItem(
                index: 0,
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: AppLocalizations.t(lang, en: 'Discover', mr: 'शोधा', hi: 'खोजें'),
              ),
              _buildFooterTabItem(
                index: 1,
                icon: Icons.favorite_border_rounded,
                activeIcon: Icons.favorite_rounded,
                label: AppLocalizations.t(lang, en: 'Shortlist', mr: 'पसंती', hi: 'शॉर्टलिस्ट'),
                badgeCount: shortlistCount,
              ),
              _buildFooterTabItem(
                index: 2,
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: AppLocalizations.t(lang, en: 'Chat', mr: 'संवाद', hi: 'चैट'),
                badgeCount: chatUnreadCount,
                badgeColor: const Color(0xFF10B981),
              ),
              _buildFooterTabItem(
                index: 3,
                icon: Icons.shopping_bag_outlined,
                activeIcon: Icons.shopping_bag_rounded,
                label: AppLocalizations.t(lang, en: 'Requests', mr: 'मागण्या', hi: 'मांगें'),
                badgeCount: requestCount,
              ),
              _buildFooterTabItem(
                index: 4,
                icon: Icons.assessment_outlined,
                activeIcon: Icons.assessment_rounded,
                label: AppLocalizations.t(lang, en: 'Records & Profit', mr: 'नोंदी व नफा', hi: 'रिकॉर्ड्स'),
                prefixEmoji: '📊 ',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterTabItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badgeCount,
    Color? badgeColor,
    String? prefixEmoji,
  }) {
    final isSelected = _tabController.index == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _tabController.animateTo(index);
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Active indicator bar at top (matches the user's screenshot indicator!)
            Container(
              height: 3,
              width: 32,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 6),

            // Icon with optional badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? Colors.white : Colors.white60,
                  size: 22,
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: badgeColor ?? const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 14),
                      child: Text(
                        '$badgeCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),

            // Label
            Text(
              '${prefixEmoji ?? ""}$label',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
              const Icon(Icons.verified_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Curated GI Crafts for Your Store',
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
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  final userProfile = context.read<UserProfileProvider>();
                  final chatProvider = context.read<ChatProvider>();
                  final originRegion = product.metadata.region.isNotEmpty
                      ? '${product.metadata.region}, ${product.metadata.origin}'
                      : (product.metadata.origin.isNotEmpty ? product.metadata.origin : '');
                  final artisanName = originRegion.isNotEmpty
                      ? 'Artisan ($originRegion)'
                      : 'Om Gaikwad';
                  final thread = chatProvider.getOrCreateThread(
                    artisanName: artisanName,
                    artisanCraft: product.metadata.category.isNotEmpty ? product.metadata.category : 'Traditional Crafts',
                    buyerName: userProfile.profile.name.isNotEmpty ? userProfile.profile.name : 'Aarav Mehta',
                    buyerOrg: userProfile.profile.businessName.isNotEmpty ? userProfile.profile.businessName : 'FabIndia Retail',
                    productTitle: title,
                    productPrice: price,
                  );
                  context.push('/chat_conversation', extra: {'threadId': thread.id});
                },
                icon: const Icon(Icons.chat_bubble_rounded),
                label: const Text('💬 Chat with Artisan Directly'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
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

    final profile = context.read<UserProfileProvider>().profile;
    final defaultOrg = profile.businessName.isNotEmpty ? profile.businessName : 'FabIndia Retail & Sourcing Mumbai';
    final defaultBuyerName = profile.name.isNotEmpty ? profile.name : 'Aarav Mehta';

    final qtyController = TextEditingController(text: '25');
    final orgController = TextEditingController(text: defaultOrg);
    final deliveryController = TextEditingController(text: 'Next Month (Festive Sourcing)');
    final msgController = TextEditingController(
      text: 'Interested in placing a bulk wholesale trial order of 25 pieces for our retail showrooms in Mumbai and Pune. Requesting direct artisan quote & GST invoice.',
    );

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shopping_cart_checkout, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Request Bulk Order',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$title • $price / unit',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: orgController,
                decoration: InputDecoration(
                  labelText: 'Company / Organization Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Required Quantity (Units)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deliveryController,
                decoration: InputDecoration(
                  labelText: 'Expected Delivery Timeline',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: msgController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Message / Specifications to Artisan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                buyerName: defaultBuyerName,
                buyerOrg: orgController.text.trim().isNotEmpty ? orgController.text.trim() : defaultOrg,
                buyerLocation: profile.location.isNotEmpty ? profile.location : 'Mumbai, Maharashtra',
                productId: product.id,
                productTitle: title,
                productPrice: price,
                quantity: int.tryParse(qtyController.text.trim()) ?? 25,
                expectedDelivery: deliveryController.text.trim(),
                message: msgController.text.trim(),
                status: 'pending',
                createdAt: DateTime.now(),
              );

              // Submits request and triggers instant artisan notification
              context.read<BuyerRequestProvider>().submitRequest(newRequest);
              Navigator.of(dialogCtx).pop();

              _showRequestSentConfirmationDialog(context, product, newRequest);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text('Submit & Notify Artisan'),
          ),
        ],
      ),
    );
  }

  void _showRequestSentConfirmationDialog(BuildContext context, ProductModel product, BuyerRequestModel request) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 38),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bulk Order Dispatched!',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_rounded, color: Color(0xFFD97706), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '🔔 Artisan has received an instant notification for ${request.quantity}x "${product.title}"!',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The artisan can now review your request and accept direct procurement without middleman charges.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.3),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _tabController.animateTo(2); // Jump to Requests tab
            },
            child: const Text('View in Requests'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // ── TAB 4: BUYER PROFILE, RECORDS & PROFITS DASHBOARD ────────────────────────
  // ═════════════════════════════════════════════════════════════════════════════

  Widget _buildRecordsAndProfileTab(BuildContext context, String lang) {
    final profileProvider = context.watch<UserProfileProvider>();
    final profile = profileProvider.profile;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. Language Toggle Bar (Vernacular support like Artisan)
        _buildBuyerLanguageBar(context, profileProvider, lang),

        const SizedBox(height: 14),

        // 2. B2B Buyer Pehchan Digital ID Card
        _buildBuyerPehchanCard(context, profile, lang),

        const SizedBox(height: 20),

        // 3. Profit Analytics Dashboard (Savings & Profit Metrics)
        _buildBuyerAnalyticsGrid(context, lang),

        const SizedBox(height: 20),

        // 4. Direct Sourcing vs Middleman Profit Multiplier Widget
        _buildProfitComparisonCard(context, lang),

        const SizedBox(height: 20),

        // 5. Procurement Records & Purchase Orders History
        _buildProcurementRecordsList(context, lang),

        const SizedBox(height: 20),

        // 6. Direct Rural Artisan Supplier Network
        _buildConnectedArtisansList(context, lang),

        const SizedBox(height: 20),

        // 7. B2B Procurement Services & Guarantees (Escrow, ITC, Logistics)
        _buildBuyerServicesSection(context, lang),

        const SizedBox(height: 20),

        // 8. Account Controls & Role Switch
        _buildBuyerAccountActions(context, profileProvider, lang),

        const SizedBox(height: 40),
      ],
    );
  }

  // ─── 1. Buyer Language Switcher Bar ──────────────────────────────────────────
  Widget _buildBuyerLanguageBar(BuildContext context, UserProfileProvider provider, String currentLang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.translate_rounded, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            _t(currentLang, en: 'Language:', mr: 'भाषा निवडा:', hi: 'भाषा चुनें:'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
          ),
          const Spacer(),
          Wrap(
            spacing: 6,
            children: [
              _buildLangChip(context, provider, 'mr', 'मराठी', currentLang == 'mr'),
              _buildLangChip(context, provider, 'hi', 'हिंदी', currentLang == 'hi'),
              _buildLangChip(context, provider, 'en', 'English', currentLang == 'en'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLangChip(BuildContext context, UserProfileProvider provider, String code, String label, bool active) {
    return GestureDetector(
      onTap: () => provider.setLanguage(code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ─── 2. B2B Buyer Pehchan Card ──────────────────────────────────────────────
  Widget _buildBuyerPehchanCard(BuildContext context, UserProfileModel profile, String lang) {
    final orgName = profile.businessName.isNotEmpty ? profile.businessName : 'FabIndia Retail & Sourcing Mumbai';
    final buyerName = profile.name.isNotEmpty ? profile.name : 'Aarav Mehta';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, size: 14, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text(
                          _t(lang, en: 'OFFICIAL B2B BUYER PEHCHAN', mr: 'अधिकृत खरेदीदार ओळखपत्र', hi: 'आधिकारिक बी2बी खरीदार पहचान'),
                          style: const TextStyle(
                            color: Color(0xFFF59E0B),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(Icons.qr_code_2_rounded, color: Colors.white70, size: 28),
            ],
          ),

          const SizedBox(height: 16),

          // Org Name & Contact
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.store_mall_directory_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orgName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$buyerName • ${_t(lang, en: "Procurement Lead", mr: "खरेदी प्रमुख", hi: "खरीद प्रमुख")}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'GSTIN: 27AAACF1234F1Z8 • ${_t(lang, en: "Verified Active", mr: "सक्रिय प्रमाणित", hi: "सक्रिय सत्यापित")}',
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),

          // 3 Pehchan Badges
          Row(
            children: [
              _buildPehchanMetaBadge(
                label: _t(lang, en: 'B2B ID', mr: 'खरेदीदार आयडी', hi: 'खरीदार आईडी'),
                value: 'SHILP-B2B-8942',
              ),
              _buildPehchanMetaBadge(
                label: _t(lang, en: 'Tier', mr: 'श्रेणी', hi: 'टियर'),
                value: '⭐ Gold Enterprise',
              ),
              _buildPehchanMetaBadge(
                label: _t(lang, en: 'Middleman Markup', mr: 'दलाल कमिशन', hi: 'दलाल कमीशन'),
                value: '0% Direct',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEditBuyerProfileDialog(context, profile),
                  icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                  label: Text(
                    _t(lang, en: 'Edit Details', mr: 'माहिती बदला', hi: 'विवरण बदलें'),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_t(lang,
                            en: '✅ B2B Procurement Credentials copied to clipboard!',
                            mr: '✅ खरेदीदार ओळखपत्र कॉपी झाले!',
                            hi: '✅ बी2बी पहचान पत्र कॉपी हुआ!')),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  icon: const Icon(Icons.share_outlined, size: 16),
                  label: Text(
                    _t(lang, en: 'Share Pehchan', mr: 'ओळखपत्र शेअर करा', hi: 'पहचान साझा करें'),
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPehchanMetaBadge({required String label, required String value}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ─── 3. Profit Analytics Dashboard (4 KPI Cards) ─────────────────────────────
  Widget _buildBuyerAnalyticsGrid(BuildContext context, String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _t(lang, en: 'Procurement Profits & Savings', mr: 'खरेदी नफा व थेट बचत नोंदी', hi: 'खरीद मुनाफा एवं बचत रिकॉर्ड'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _t(lang, en: 'FY 2026', mr: 'वर्ष २०२६', hi: 'वर्ष २०२६'),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.savings_outlined,
                iconColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFECFDF5),
                title: _t(lang, en: 'Middleman Savings', mr: 'दलाल बचत', hi: 'दलाल बचत'),
                value: '₹4,24,350',
                subtext: _t(lang, en: '+23.4% Cost Saved', mr: '+२३.४% थेट बचत', hi: '+२३.४% लागत बचत'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.primary,
                bgColor: AppColors.primary.withValues(alpha: 0.08),
                title: _t(lang, en: 'Realized Margin', mr: 'विक्री नफा प्रमाण', hi: 'विक्री मुनाफा मार्जिन'),
                value: '42.8%',
                subtext: _t(lang, en: 'vs 22% Industry Avg', mr: 'बाजारापेक्षा दुप्पट', hi: 'बाजार से दोगुना'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: const Color(0xFF6366F1),
                bgColor: const Color(0xFFEEF2FF),
                title: _t(lang, en: 'Total Sourced Value', mr: 'एकूण खरेदी रक्कम', hi: 'कुल खरीद राशि'),
                value: '₹18,45,000',
                subtext: _t(lang, en: '14 Consignments', mr: '१४ मोठ्या ऑर्डर्स', hi: '१४ बड़े ऑर्डर'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                icon: Icons.handshake_outlined,
                iconColor: const Color(0xFFF59E0B),
                bgColor: const Color(0xFFFEF3C7),
                title: _t(lang, en: 'Rural Artisans', mr: 'थेट कारागीर नेटवर्क', hi: 'सीधे कारीगर नेटवर्क'),
                value: '28 Artisans',
                subtext: _t(lang, en: 'Pan-India Clusters', mr: 'अखिल भारतीय', hi: 'अखिल भारतीय'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String value,
    required String subtext,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textLight, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 3),
          Text(
            subtext,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: iconColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ─── 4. Direct Sourcing Profit Multiplier Comparison Widget ──────────────────
  Widget _buildProfitComparisonCard(BuildContext context, String lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.price_check, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _t(lang,
                      en: 'Direct Sourcing vs Traditional Supply Chain',
                      mr: 'थेट कारागीर खरेदी विरुद्ध पारंपारिक दलाल साखळी',
                      hi: 'सीधी कारीगर खरीद बनाम पारंपरिक दलाल श्रृंखला'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Two comparative columns
          Row(
            children: [
              // Traditional
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t(lang, en: 'Traditional Brokers', mr: 'पारंपारिक दलाल', hi: 'पारंपरिक दलाल'),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      const Text('Purchase: ₹1,800', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                      const Text('Retail Sale: ₹2,400', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                      const SizedBox(height: 6),
                      const Divider(height: 1),
                      const SizedBox(height: 6),
                      const Text(
                        'Profit: ₹600 (25%)',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // ShilpSetu Direct
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bolt, color: Color(0xFF16A34A), size: 14),
                          const SizedBox(width: 3),
                          Text(
                            _t(lang, en: 'ShilpSetu Direct', mr: 'शिल्पसेतू थेट खरेदी', hi: 'शिल्पसेतु सीधी खरीद'),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text('Direct Price: ₹1,250', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                      const Text('Retail Sale: ₹2,400', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                      const SizedBox(height: 6),
                      const Divider(height: 1, color: Color(0xFF86EFAC)),
                      const SizedBox(height: 6),
                      const Text(
                        'Profit: ₹1,150 (48%)',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: Color(0xFF15803D)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _t(lang,
                        en: '🚀 You capture +₹550 extra net profit per craft piece by sourcing directly!',
                        mr: '🚀 थेट खरेदीने तुम्हाला प्रत्येक वस्तूमधून +₹५५० जास्तीचा निव्वळ नफा मिळतो!',
                        hi: '🚀 सीधी खरीद से आपको हर शिल्प वस्तु पर +₹५५० अतिरिक्त शुद्ध मुनाफा मिलता है!'),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 5. Procurement Records & Orders History ──────────────────────────────────
  Widget _buildProcurementRecordsList(BuildContext context, String lang) {
    // 4 realistic procurement records
    final orders = [
      {
        'id': 'PO-2026-112',
        'title': 'Authentic Yeola Paithani Pure Silk Saree',
        'artisan': 'Om Gaikwad (Yeola, Maharashtra)',
        'units': '50 Units',
        'cost': '₹3,25,000',
        'profit': '₹1,45,000 (44.6%)',
        'status': 'Delivered',
        'statusColor': const Color(0xFF10B981),
        'date': '18 Feb 2026',
        'image': 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'PO-2026-098',
        'title': 'Bastar Dhokra Lost-Wax Bell Metal Statues',
        'artisan': 'Ramesh Baghel (Bastar, Chhattisgarh)',
        'units': '120 Units',
        'cost': '₹1,80,000',
        'profit': '₹96,000 (53.3%)',
        'status': 'In Transit',
        'statusColor': const Color(0xFFF59E0B),
        'date': '24 Feb 2026',
        'image': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'PO-2026-084',
        'title': 'Kutch Hand-Turned Terracotta Glazed Water Jugs',
        'artisan': 'Govindbhai Prajapati (Bhuj, Gujarat)',
        'units': '200 Units',
        'cost': '₹84,000',
        'profit': '₹52,000 (61.9%)',
        'status': 'Delivered',
        'statusColor': const Color(0xFF10B981),
        'date': '12 Jan 2026',
        'image': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?auto=format&fit=crop&w=400&q=80',
      },
      {
        'id': 'PO-2026-071',
        'title': 'Bidriware Pure Silver Wire Floral Vases',
        'artisan': 'Mohammed Riaz (Bidar, Karnataka)',
        'units': '80 Units',
        'cost': '₹2,10,000',
        'profit': '₹1,05,000 (50.0%)',
        'status': 'Delivered',
        'statusColor': const Color(0xFF10B981),
        'date': '28 Dec 2025',
        'image': 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=400&q=80',
      },
    ];

    final filteredOrders = _selectedRecordFilter == 'all'
        ? orders
        : _selectedRecordFilter == 'delivered'
            ? orders.where((o) => o['status'] == 'Delivered').toList()
            : orders.where((o) => o['status'] == 'In Transit').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _t(lang, en: 'Procurement Records & History', mr: 'खरेदी नोंदी व ऑर्डर्स इतिहास', hi: 'खरीद रिकॉर्ड्स एवं ऑर्डर इतिहास'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary),
            ),
            Text(
              '${filteredOrders.length} ${_t(lang, en: "Records", mr: "नोंदी", hi: "रिकॉर्ड्स")}',
              style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRecordFilterChip('all', _t(lang, en: 'All Records (4)', mr: 'सर्व नोंदी (४)', hi: 'सभी रिकॉर्ड (४)')),
              const SizedBox(width: 8),
              _buildRecordFilterChip('delivered', _t(lang, en: 'Delivered (3)', mr: 'वितरित (३)', hi: 'डिलीवर (३)')),
              const SizedBox(width: 8),
              _buildRecordFilterChip('in_transit', _t(lang, en: 'In Transit (1)', mr: 'मार्गावर (१)', hi: 'रास्ते में (१)')),
            ],
          ),
        ),

        const SizedBox(height: 12),

        ...filteredOrders.map((order) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: const [
                BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['id'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (order['statusColor'] as Color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order['status'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: order['statusColor'] as Color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  order['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_t(lang, en: "Artisan", mr: "कारागीर", hi: "कारीगर")}: ${order['artisan']}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_t(lang, en: 'Quantity', mr: 'नग संख्या', hi: 'मात्रा'),
                              style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                          Text(order['units'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_t(lang, en: 'Total Sourced', mr: 'एकूण रक्कम', hi: 'कुल राशि'),
                              style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                          Text(order['cost'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_t(lang, en: 'Realized Profit', mr: 'मिळालेला नफा', hi: 'प्राप्त मुनाफा'),
                              style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                          Text(order['profit'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF10B981))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_t(lang, en: "Date", mr: "तारीख", hi: "दिनांक")}: ${order['date']}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('📄 Downloading GST Invoice for ${order['id']} (Tax Invoice & ITC Credit)...'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download, size: 14),
                          label: Text(
                            _t(lang, en: 'GST Bill', mr: 'जीएसटी पावती', hi: 'जीएसटी बिल'),
                            style: const TextStyle(fontSize: 11),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _showOrderDetailsDialog(context, order, lang),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(_t(lang, en: 'Details', mr: 'तपशील', hi: 'विवरण'), style: const TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecordFilterChip(String value, String label) {
    final isSelected = _selectedRecordFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedRecordFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.outlineVariant),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ─── 6. Connected Rural Artisan Supplier Network ─────────────────────────────
  Widget _buildConnectedArtisansList(BuildContext context, String lang) {
    final artisans = [
      {
        'name': 'Om Gaikwad',
        'craft': 'Yeola Paithani Silk Weaving',
        'location': 'Yeola, Nashik',
        'rating': '4.9 ★',
        'units': '150 units sourced',
        'avatar': 'OG',
      },
      {
        'name': 'Ramesh Baghel',
        'craft': 'Bastar Lost-Wax Bell Metal',
        'location': 'Bastar, Chhattisgarh',
        'rating': '4.8 ★',
        'units': '240 units sourced',
        'avatar': 'RB',
      },
      {
        'name': 'Govindbhai Prajapati',
        'craft': 'Kutch Terracotta Pottery',
        'location': 'Bhuj, Gujarat',
        'rating': '5.0 ★',
        'units': '400 units sourced',
        'avatar': 'GP',
      },
      {
        'name': 'Sunita Devi',
        'craft': 'Madhubani Natural Dye Painting',
        'location': 'Madhubani, Bihar',
        'rating': '4.9 ★',
        'units': '180 units sourced',
        'avatar': 'SD',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(lang, en: 'Connected Artisan Partners', mr: 'थेट जोडलेले कारागीर पुरवठादार', hi: 'जुड़े हुए कारीगर साझेदार'),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        ...artisans.map((artisan) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryFixed,
                  child: Text(
                    artisan['avatar']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artisan['name']!,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                      ),
                      Text(
                        artisan['craft']!,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textLight),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${artisan['location']} • ${artisan['units']}',
                        style: const TextStyle(fontSize: 10.5, color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_rounded, color: AppColors.primary, size: 22),
                  tooltip: 'Chat with Artisan',
                  onPressed: () {
                    final userProfile = context.read<UserProfileProvider>();
                    final chatProvider = context.read<ChatProvider>();
                    final thread = chatProvider.getOrCreateThread(
                      artisanName: artisan['name']!,
                      artisanCraft: artisan['craft']!,
                      buyerName: userProfile.profile.name.isNotEmpty ? userProfile.profile.name : 'Aarav Mehta',
                      buyerOrg: userProfile.profile.businessName.isNotEmpty ? userProfile.profile.businessName : 'FabIndia Retail',
                    );
                    context.push('/chat_conversation', extra: {'threadId': thread.id});
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.phone_outlined, color: AppColors.primary, size: 22),
                  tooltip: 'Call Artisan',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling ${artisan['name']} directly...')),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ─── 7. B2B Enterprise Services & Guarantees ─────────────────────────────────
  Widget _buildBuyerServicesSection(BuildContext context, String lang) {
    final services = [
      {
        'icon': Icons.security_rounded,
        'color': const Color(0xFF10B981),
        'title': _t(lang, en: '100% Escrow Quality Protection', mr: '१००% एस्क्रो गुणवत्ता हमी', hi: '१००% एस्क्रो गुणवत्ता सुरक्षा'),
        'desc': _t(lang,
            en: 'Funds held in trust until physical quality audit approved at your destination warehouse.',
            mr: 'माल गोदामात पोहोचून गुणवत्ता तपासणी होईपर्यंत तुमची रक्कम सुरक्षित राहते.',
            hi: 'माल गोदाम में पहुंचकर गुणवत्ता जांच पूरी होने तक आपकी राशि सुरक्षित रहती है।'),
      },
      {
        'icon': Icons.receipt_long_rounded,
        'color': const Color(0xFF6366F1),
        'title': _t(lang, en: 'Automated GSTR-2B Input Tax Credit', mr: 'स्वयंचलित जीएसटी इनपुट क्रेडिट', hi: 'स्वचालित जीएसटी इनपुट टैक्स क्रेडिट'),
        'desc': _t(lang,
            en: 'Single consolidated monthly tax invoice with instant ITC credit reconciliation.',
            mr: 'मासिक एकत्रीकृत जीएसटी बिल आणि थेट टॅक्स क्रेडिट वजावट.',
            hi: 'मासिक एकीकृत जीएसटी बिल और सीधा टैक्स क्रेडिट मिलान।'),
      },
      {
        'icon': Icons.local_shipping_rounded,
        'color': const Color(0xFFF59E0B),
        'title': _t(lang, en: 'Subsidized Pan-India Fragile Logistics', mr: 'सवलतीचे सुरक्षित वाहतूक नेटवर्क', hi: 'रियायती सुरक्षित परिवहन नेटवर्क'),
        'desc': _t(lang,
            en: 'Door-to-door insured transit with DHL & BlueDart cargo at 35% negotiated bulk rates.',
            mr: 'DHL आणि BlueDart सह ३५% सवलतीचे विमायुक्त सुरक्षित वाहतूक पॅकेज.',
            hi: 'डीएचएल और ब्लू डार्ट के साथ ३५% छूट वाला बीमित सुरक्षित कार्गो।'),
      },
      {
        'icon': Icons.public_rounded,
        'color': AppColors.primary,
        'title': _t(lang, en: 'Geographical Indication (GI) Export Clearance', mr: 'जीआय टॅग अधिकृत निर्यात प्रमाणपत्र', hi: 'जीआई टैग आधिकारिक निर्यात प्रमाण पत्र'),
        'desc': _t(lang,
            en: 'Official authenticity certification for duty-free international handicraft export.',
            mr: 'आंतरराष्ट्रीय हस्तकला निर्यातीसाठी अधिकृत अस्सलतेचे प्रमाणपत्र.',
            hi: 'अंतर्राष्ट्रीय हस्तशिल्प निर्यात के लिए आधिकारिक प्रमाण पत्र।'),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(lang, en: 'Buyer Services & Guarantees', mr: 'खरेदीदार सेवा व हमी सुविधा', hi: 'खरीदार सेवाएं एवं गारंटी सुविधाएं'),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        ...services.map((svc) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (svc['color'] as Color).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(svc['icon'] as IconData, color: svc['color'] as Color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        svc['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        svc['desc'] as String,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textLight, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ─── 8. Account Controls & Role Switch ───────────────────────────────────────
  Widget _buildBuyerAccountActions(BuildContext context, UserProfileProvider provider, String lang) {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () => provider.switchRole('artisan'),
          icon: const Icon(Icons.swap_horiz, color: AppColors.primary),
          label: Text(
            _t(lang, en: 'Switch to Artisan Mode', mr: 'कारागीर मोडवर जा', hi: 'कारीगर मोड पर जाएं'),
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            await provider.clearProfile();
            if (context.mounted) context.go('/login');
          },
          icon: const Icon(Icons.logout, color: Colors.white, size: 18),
          label: Text(
            _t(lang, en: 'Sign Out from Buyer Portal', mr: 'पोर्टलवरून बाहेर पडा (लॉग आउट)', hi: 'पोर्टल से बाहर निकलें (लॉग आउट)'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  void _showOrderDetailsDialog(BuildContext context, Map<String, dynamic> order, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(order['id'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            Text('${_t(lang, en: "Artisan Partner", mr: "कारागीर पुरवठादार", hi: "कारीगर साझेदार")}: ${order['artisan']}'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_t(lang, en: 'Units Procured', mr: 'नग संख्या', hi: 'मात्रा')),
                Text(order['units'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_t(lang, en: 'Total Sourced Value', mr: 'एकूण रक्कम', hi: 'कुल खरीद राशि')),
                Text(order['cost'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_t(lang, en: 'Realized Margin', mr: 'मिळालेला नफा', hi: 'प्राप्त मुनाफा')),
                Text(order['profit'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_outlined, color: Color(0xFF10B981), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _t(lang,
                          en: 'Quality Audit: Passed • Zero Middleman Margin Fee',
                          mr: 'गुणवत्ता तपासणी: मंजूर • ०% दलाली शुल्क',
                          hi: 'गुणवत्ता जांच: उत्तीर्ण • ०% दलाली शुल्क'),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('GST Invoice downloaded for ${order['id']}!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Download Invoice'),
          ),
        ],
      ),
    );
  }

  void _showEditBuyerProfileDialog(BuildContext context, UserProfileModel profile) {
    final nameCtrl = TextEditingController(text: profile.name.isNotEmpty ? profile.name : 'Aarav Mehta');
    final orgCtrl = TextEditingController(text: profile.businessName.isNotEmpty ? profile.businessName : 'FabIndia Retail & Sourcing Mumbai');
    final locCtrl = TextEditingController(text: profile.location.isNotEmpty ? profile.location : 'Mumbai, Maharashtra');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Buyer Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: orgCtrl,
              decoration: const InputDecoration(labelText: 'Organization / Business Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Procurement Officer Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locCtrl,
              decoration: const InputDecoration(labelText: 'Delivery Hub / Location'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserProfileProvider>().saveNewBuyerProfile(
                name: nameCtrl.text.trim(),
                email: profile.email,
                businessName: orgCtrl.text.trim(),
                businessType: 'Retail & Wholesale',
              );
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Buyer Profile updated!'), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
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
