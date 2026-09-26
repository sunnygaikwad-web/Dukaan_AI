import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_localizations.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/providers/product_provider.dart';
import '../../../core/providers/buyer_request_provider.dart';
import '../../../core/constants/app_craft_images.dart';
import '../../../models/product_model.dart';
import '../../buyers/widgets/buyer_leads_sheet.dart';
import '../../../core/providers/chat_provider.dart';
import '../../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final scrolled = _scrollController.hasClients && _scrollController.offset > 50;
      if (mounted && scrolled != _isScrolled) {
        setState(() => _isScrolled = scrolled);
      }
    });
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _t(String lang, {required String en, required String mr, required String hi}) {
    if (lang == 'mr') return mr;
    if (lang == 'hi') return hi;
    return en;
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<UserProfileProvider>();
    final productProvider = context.watch<ProductProvider>();
    final requestProvider = context.watch<BuyerRequestProvider>();
    final chatProvider = context.watch<ChatProvider>();
    final profile = profileProvider.profile;
    final lang = profileProvider.selectedLanguage;
    final products = productProvider.products;
    final pendingRequests = requestProvider.requests.where((r) => r.status == 'pending').toList();
    final unreadChatCount = chatProvider.totalUnreadCount;

    final initials = profile.name.trim().isNotEmpty
        ? profile.name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).map((e) => e[0]).take(2).join().toUpperCase()
        : 'A';
    final displayName = profile.name.trim().isNotEmpty ? profile.name.trim().split(' ').first : 'Artisan';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ── Collapsing App Bar ─────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            backgroundColor: _isScrolled
                ? Colors.white.withValues(alpha: 0.97)
                : const Color(0xFFF7F4F0),
            elevation: _isScrolled ? 0.5 : 0,
            shadowColor: Colors.black12,
            titleSpacing: 16,
            title: _buildAppBarTitle(context, lang, initials, displayName, pendingRequests.length, unreadChatCount, requestProvider),
            actions: [
              _buildLanguageButton(context, lang),
              const SizedBox(width: 12),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Live Alert Banner ────────────────────────────────────
                  if (requestProvider.latestAlert != null)
                    _buildAlertBanner(context, lang, requestProvider),

                  const SizedBox(height: 8),

                  // ── Greeting ─────────────────────────────────────────────
                  _buildGreeting(context, displayName, lang),

                  const SizedBox(height: 20),

                  // ── Stats Row ────────────────────────────────────────────
                  _buildStatsRow(context, lang, products.length, pendingRequests.length),

                  const SizedBox(height: 20),

                  // ── Add Craft Hero Card ───────────────────────────────────
                  _buildAddCraftHero(context, lang),

                  const SizedBox(height: 20),

                  // ── Quick Actions ─────────────────────────────────────────
                  _buildSectionHeader(
                    context,
                    _t(lang, en: 'Quick Actions', mr: 'जलद कृती', hi: 'त्वरित विकल्प'),
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActions(context, lang, products.length, unreadChatCount, chatProvider.threads.length),

                  const SizedBox(height: 24),

                  // ── Opportunity Banner ────────────────────────────────────
                  _buildOpportunityBanner(context, lang),

                  const SizedBox(height: 24),

                  // ── Buyer Demands ─────────────────────────────────────────
                  _buildSectionHeader(
                    context,
                    _t(lang, en: 'Buyer Demands', mr: 'ग्राहक मागण्या', hi: 'ग्राहक मांगें'),
                    actionLabel: _t(lang, en: 'View All', mr: 'सर्व पहा', hi: 'सभी देखें'),
                    onAction: () => context.push('/buyer_requests'),
                    badge: pendingRequests.isNotEmpty ? '${pendingRequests.length}' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildBuyerDemands(context, lang, pendingRequests, requestProvider),

                  const SizedBox(height: 24),

                  // ── My Crafts ─────────────────────────────────────────────
                  _buildSectionHeader(
                    context,
                    _t(lang, en: 'My Crafts', mr: 'माझी उत्पादने', hi: 'मेरे उत्पाद'),
                    actionLabel: _t(lang, en: 'View Store', mr: 'दुकान पहा', hi: 'दुकान देखें'),
                    onAction: () => context.read<NavigationProvider>().setIndex(1),
                  ),
                  const SizedBox(height: 12),
                  _buildCraftsCarousel(context, lang, products),

                  const SizedBox(height: 24),

                  // ── Government Schemes ────────────────────────────────────
                  _buildGovBanner(context, lang),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── App Bar Title ────────────────────────────────────────────────────────────
  Widget _buildAppBarTitle(
    BuildContext context, String lang, String initials, String displayName,
    int pendingCount, int unreadChat, BuyerRequestProvider requestProvider,
  ) {
    return Row(
      children: [
        // Logo
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primary,
            image: const DecorationImage(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.tr('dukaan_title', lang),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 15,
                ),
              ),
              Text(
                _t(lang, en: 'Artisan Dashboard', mr: 'कारागीर पोर्टल', hi: 'कारीगर पोर्टल'),
                style: TextStyle(color: AppColors.textLight, fontSize: 10.5),
              ),
            ],
          ),
        ),
        // Chat
        _buildIconBadge(
          icon: Icons.forum_outlined,
          badge: unreadChat > 0 ? '$unreadChat' : null,
          badgeColor: const Color(0xFF6366F1),
          onTap: () => context.push('/chat_list'),
        ),
        const SizedBox(width: 8),
        // Notifications
        _buildIconBadge(
          icon: Icons.notifications_outlined,
          badge: pendingCount > 0 ? '$pendingCount' : null,
          badgeColor: AppColors.error,
          onTap: () {
            requestProvider.clearLatestAlert();
            context.push('/buyer_requests');
          },
        ),
        const SizedBox(width: 8),
        // Profile Avatar
        GestureDetector(
          onTap: () => context.read<NavigationProvider>().setIndex(3),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: AppColors.primaryFixed,
                child: Text(initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13)),
              ),
              Positioned(
                right: 0, bottom: 0,
                child: Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.success, shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconBadge({required IconData icon, String? badge, required Color badgeColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: 19, color: AppColors.textPrimary),
            if (badge != null)
              Positioned(
                right: -4, top: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                  child: Text(badge, textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, String lang) {
    return GestureDetector(
      onTap: () => _showLanguageSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.translate, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              lang == 'mr' ? 'मराठी' : (lang == 'hi' ? 'हिंदी' : 'EN'),
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ── Alert Banner ─────────────────────────────────────────────────────────────
  Widget _buildAlertBanner(BuildContext context, String lang, BuyerRequestProvider requestProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.lerp(const Color(0xFFF59E0B), const Color(0xFFD97706), _pulseController.value),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_active, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('New Bulk Order!', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF92400E))),
                Text(requestProvider.latestAlert!, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF78350F))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () { requestProvider.clearLatestAlert(); context.push('/buyer_requests'); },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFD97706), borderRadius: BorderRadius.circular(10)),
              child: const Text('View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Greeting ─────────────────────────────────────────────────────────────────
  Widget _buildGreeting(BuildContext context, String displayName, String lang) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? _t(lang, en: 'Good Morning', mr: 'शुभ सकाळ', hi: 'सुप्रभात')
        : hour < 17
            ? _t(lang, en: 'Good Afternoon', mr: 'शुभ दुपार', hi: 'नमस्कार')
            : _t(lang, en: 'Good Evening', mr: 'शुभ संध्याकाळ', hi: 'शुभ संध्या');
    final emoji = hour < 12 ? '🌅' : hour < 17 ? '☀️' : '🌙';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $displayName $emoji',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800, color: AppColors.textPrimary, fontSize: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _t(lang, en: 'Your craft shop is live & ready for buyers.', mr: 'आपले दुकान सुरू आहे व ग्राहकांसाठी तयार आहे.', hi: 'आपकी दुकान चालू है और खरीदारों के लिए तैयार है।'),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────────────────
  Widget _buildStatsRow(BuildContext context, String lang, int productCount, int pendingCount) {
    return Row(
      children: [
        _buildStatCard(
          label: _t(lang, en: 'Live Crafts', mr: 'उत्पादने', hi: 'उत्पाद'),
          value: '$productCount',
          icon: Icons.inventory_2_rounded,
          color: AppColors.primary,
          onTap: () => context.read<NavigationProvider>().setIndex(1),
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          label: _t(lang, en: 'Buyer Demands', mr: 'मागण्या', hi: 'मांगें'),
          value: '$pendingCount',
          icon: Icons.shopping_bag_outlined,
          color: pendingCount > 0 ? Colors.deepOrange : AppColors.secondary,
          onTap: () => context.push('/buyer_requests'),
          hasBadge: pendingCount > 0,
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          label: _t(lang, en: 'This Month', mr: 'या महिन्यात', hi: 'इस माह'),
          value: '₹28.5k',
          icon: Icons.currency_rupee_rounded,
          color: AppColors.success,
          onTap: () => _showEarningsDetail(context, lang),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label, required String value,
    required IconData icon, required Color color,
    required VoidCallback onTap, bool hasBadge = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.2)),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
                  if (hasBadge) ...[
                    const SizedBox(width: 4),
                    Container(width: 7, height: 7, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textLight, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Add Craft Hero Card ───────────────────────────────────────────────────────
  Widget _buildAddCraftHero(BuildContext context, String lang) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B2500), Color(0xFFB84A00), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Stack(
        children: [
          // Background decorative circle
          Positioned(
            right: -20, top: -20,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 30, bottom: -30,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _t(lang, en: 'List Your Craft\nin 1 Minute! 🎨', mr: '१ मिनिटात\nउत्पादन जोडा! 🎨', hi: '१ मिनट में\nशिल्प सूचीबद्ध करें! 🎨'),
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.2),
                ),
                const SizedBox(height: 6),
                Text(
                  _t(lang, en: 'AI generates title, story & pricing instantly', mr: 'AI आपोआप शीर्षक, कथा आणि किंमत तयार करते', hi: 'AI तुरंत शीर्षक, कहानी और मूल्य तैयार करता है'),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12.5, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _buildHeroButton(
                      icon: Icons.camera_alt_rounded,
                      label: _t(lang, en: 'Take Photo', mr: 'फोटो काढा', hi: 'फोटो लें'),
                      bgColor: Colors.white,
                      textColor: AppColors.primary,
                      onTap: () => context.push('/add_product'),
                    ),
                    const SizedBox(width: 10),
                    _buildHeroButton(
                      icon: Icons.mic_rounded,
                      label: _t(lang, en: 'Voice Entry', mr: 'बोलून सांगा', hi: 'बोलकर बताएं'),
                      bgColor: Colors.white.withValues(alpha: 0.2),
                      textColor: Colors.white,
                      onTap: () => context.push('/voice_cataloger'),
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

  Widget _buildHeroButton({required IconData icon, required String label, required Color bgColor, required Color textColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: textColor),
            const SizedBox(width: 7),
            Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(BuildContext context, String title, {String? actionLabel, VoidCallback? onAction, String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.textPrimary)),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(20)),
                child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ],
          ],
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(actionLabel, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12.5)),
            ),
          ),
      ],
    );
  }

  // ── Quick Actions ─────────────────────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context, String lang, int productCount, int unreadChatCount, int threadCount) {
    final actions = [
      _QuickAction(
        icon: Icons.inventory_2_rounded,
        label: _t(lang, en: 'My Products', mr: 'माझी उत्पादने', hi: 'मेरे उत्पाद'),
        sub: '$productCount active',
        color: AppColors.primary,
        onTap: () => context.read<NavigationProvider>().setIndex(1),
      ),
      _QuickAction(
        icon: Icons.storefront_rounded,
        label: _t(lang, en: 'Find Buyers', mr: 'खरेदीदार शोधा', hi: 'खरीदार खोजें'),
        sub: '3 new leads',
        color: const Color(0xFF0EA5E9),
        onTap: () => BuyerLeadsSheet.show(context),
      ),
      _QuickAction(
        icon: Icons.payments_rounded,
        label: _t(lang, en: 'Earnings', mr: 'कमाई', hi: 'कमाई'),
        sub: '₹28,500 / mo',
        color: AppColors.success,
        onTap: () => context.push('/smart_pricing'),
      ),
      _QuickAction(
        icon: Icons.festival_rounded,
        label: _t(lang, en: 'Digital Mela', mr: 'डिजिटल मेळा', hi: 'डिजिटल मेला'),
        sub: _t(lang, en: 'Live Now', mr: 'सुरू आहे', hi: 'लाइव है'),
        color: const Color(0xFFEC4899),
        onTap: () => context.read<NavigationProvider>().setIndex(2),
      ),
    ];

    return Column(
      children: [
        Row(children: actions.take(2).map((a) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 5), child: _buildActionTile(a)))).toList()),
        const SizedBox(height: 10),
        Row(children: actions.skip(2).take(2).map((a) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 5), child: _buildActionTile(a)))).toList()),
        const SizedBox(height: 10),
        // Chat Card – Full Width
        _buildChatCard(context, lang, unreadChatCount, threadCount),
      ],
    );
  }

  Widget _buildActionTile(_QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: action.color.withValues(alpha: 0.15)),
          boxShadow: [BoxShadow(color: action.color.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(action.icon, color: action.color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(action.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(action.sub, style: TextStyle(fontSize: 11.5, color: action.color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildChatCard(BuildContext context, String lang, int unreadChatCount, int threadCount) {
    return GestureDetector(
      onTap: () => context.push('/chat_list'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF4338CA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: const Color(0xFF1E1B4B).withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.forum_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _t(lang, en: 'Buyer Chats', mr: 'खरेदीदार संवाद', hi: 'खरीदार चैट'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      if (unreadChatCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(10)),
                          child: Text('$unreadChatCount NEW', style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _t(lang, en: '$threadCount active discussions • Direct B2B', mr: '$threadCount सक्रिय चर्चा • थेट व्यापार', hi: '$threadCount सक्रिय चर्चा • सीधा व्यापार'),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 12),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white60, size: 14),
          ],
        ),
      ),
    );
  }

  // ── Opportunity Banner ────────────────────────────────────────────────────────
  Widget _buildOpportunityBanner(BuildContext context, String lang) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFB923C).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFFB923C).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(AppLocalizations.tr('high_demand_tag', lang), style: const TextStyle(color: Color(0xFFEA580C), fontSize: 10.5, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.tr('buyers_looking_banner', lang),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary, height: 1.3),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => BuyerLeadsSheet.show(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFEA580C), borderRadius: BorderRadius.circular(12)),
                    child: Text(AppLocalizations.tr('view_buyers', lang), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Buyer Demands ─────────────────────────────────────────────────────────────
  Widget _buildBuyerDemands(BuildContext context, String lang, List<BuyerRequestModel> pending, BuyerRequestProvider requestProvider) {
    if (pending.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.successContainer, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_t(lang, en: 'All Caught Up!', mr: 'सर्व अद्ययावत!', hi: 'सब ठीक है!'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  Text(
                    _t(lang, en: 'New buyer requests will appear here instantly.', mr: 'नवीन मागण्या येथे दिसतील.', hi: 'नई मांगें यहां दिखाई देंगी।'),
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: pending.take(2).map((req) => _buildDemandCard(context, lang, req, requestProvider)).toList(),
    );
  }

  Widget _buildDemandCard(BuildContext context, String lang, BuyerRequestModel req, BuyerRequestProvider requestProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(req.buyerName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                    Text('${req.productTitle} • ${req.productPrice}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(10)),
                child: Text('${req.quantity} pcs', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await requestProvider.updateStatus(req.id, 'accepted');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(_t(lang, en: 'Order Accepted! Buyer notified.', mr: 'मागणी स्वीकारली!', hi: 'मांग स्वीकृत!')),
                        backgroundColor: AppColors.success,
                      ));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(_t(lang, en: 'Accept', mr: 'स्वीकारा', hi: 'स्वीकारें'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13))),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => context.push('/buyer_requests'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Text(_t(lang, en: 'Details', mr: 'तपशील', hi: 'विवरण'),
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── My Crafts Carousel ────────────────────────────────────────────────────────
  Widget _buildCraftsCarousel(BuildContext context, String lang, List<ProductModel> products) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == products.length) {
            return GestureDetector(
              onTap: () => context.push('/add_product'),
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
                      child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 26),
                    ),
                    const SizedBox(height: 10),
                    Text(_t(lang, en: '+ Add Craft', mr: '+ नवीन जोडा', hi: '+ नया जोड़ें'),
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
              ),
            );
          }
          final p = products[index];
          final title = p.catalog[lang]?.title ?? p.catalog['en']?.title ?? 'Handcrafted Art';
          final price = '₹${p.pricing.recommended.toInt()}';
          final displayImage = (p.enhancedImageUrl != null && p.enhancedImageUrl!.isNotEmpty)
              ? p.enhancedImageUrl
              : ((p.originalImageUrl != null && p.originalImageUrl!.isNotEmpty) ? p.originalImageUrl : null);

          return GestureDetector(
            onTap: () => context.push('/multilingual_catalog', extra: p),
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.outlineVariant),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                    child: SizedBox(
                      height: 108, width: double.infinity,
                      child: AppCraftImages.buildCraftImage(imageUrl: displayImage, categoryOrTitle: p.metadata.craftType, fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.textPrimary)),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(price, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.successContainer, borderRadius: BorderRadius.circular(6)),
                              child: Text(_t(lang, en: 'Live', mr: 'सुरू', hi: 'लाइव'),
                                style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.success)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Gov Schemes Banner ────────────────────────────────────────────────────────
  Widget _buildGovBanner(BuildContext context, String lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Text('🏛️', style: TextStyle(fontSize: 30)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t(lang, en: 'PM Vishwakarma & Govt. Support', mr: 'पीएम विश्वकर्मा व सरकारी योजना', hi: 'पीएम विश्वकर्मा एवं सरकारी सहायता'),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 4),
                Text(
                  _t(lang, en: '₹3 lakh loan at 5% • Free toolkits • Training', mr: '₹३ लाख ५% व्याजाने • मोफत टूलकिट', hi: '₹3 लाख 5% ब्याज पर • मुफ्त टूलकिट'),
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showGovernmentSchemesSheet(context, lang),
                  child: Row(
                    children: [
                      Text(_t(lang, en: 'Explore Schemes →', mr: 'योजना पहा →', hi: 'योजनाएं देखें →'),
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Modals ───────────────────────────────────────────────────────────────────
  void _showEarningsDetail(BuildContext context, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(_t(lang, en: 'Earnings Summary', mr: 'कमाई सारांश', hi: 'कमाई का विवरण')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ${_t(lang, en: 'Completed Orders: ₹24,000', mr: 'पूर्ण: ₹२४,०००', hi: 'पूर्ण ऑर्डर: ₹२४,०००')}'),
            const SizedBox(height: 6),
            Text('• ${_t(lang, en: 'Pending Payouts: ₹4,500', mr: 'येणे: ₹४,५००', hi: 'बकाया: ₹४,५००')}'),
            const SizedBox(height: 6),
            Text('• ${_t(lang, en: 'Direct UPI transfer supported', mr: 'थेट UPI मध्ये जमा', hi: 'सीधे UPI में')}',
              style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
  }

  void _showGovernmentSchemesSheet(BuildContext context, String lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7, maxChildSize: 0.9, minChildSize: 0.5, expand: false,
        builder: (_, sc) => ListView(
          controller: sc,
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text(_t(lang, en: 'Artisan Schemes & Opportunities', mr: 'कारागीर योजना', hi: 'कारीगर योजनाएं'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 14),
            _buildSchemeCard(title: 'PM Vishwakarma Scheme', benefit: '₹3,00,000 loan at 5% + ₹15,000 Toolkit', eligibility: 'Traditional artisans across 18 craft categories', tag: 'Govt. of India'),
            const SizedBox(height: 10),
            _buildSchemeCard(title: 'ODOP (One District One Product)', benefit: 'Direct export support & state pavilion stalls', eligibility: 'Artisans producing native regional specialties', tag: 'National Initiative'),
            const SizedBox(height: 10),
            _buildSchemeCard(title: 'Digital Craft Photography Masterclass', benefit: 'Free workshop on lighting & mobile craft photos', eligibility: 'All registered ShilpSetu artisans • This Saturday 4 PM', tag: 'Skill Training'),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeCard({required String title, required String benefit, required String eligibility, required String tag}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(6)),
                child: Text(tag, style: const TextStyle(color: AppColors.primary, fontSize: 9.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(benefit, style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(eligibility, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final provider = context.read<UserProfileProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
            const Text('Choose Language / भाषा निवडा', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            for (final entry in [('मराठी (Marathi)', 'mr'), ('हिंदी (Hindi)', 'hi'), ('English', 'en')])
              ListTile(
                title: Text(entry.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: provider.selectedLanguage == entry.$2 ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                onTap: () { provider.setLanguage(entry.$2); Navigator.pop(ctx); },
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.sub, required this.color, required this.onTap});
}
