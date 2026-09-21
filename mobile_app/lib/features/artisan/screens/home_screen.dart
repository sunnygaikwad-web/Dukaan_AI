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
import '../../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final scrolled = _scrollController.hasClients && _scrollController.offset > 40;
      if (mounted && scrolled != _isScrolled) {
        setState(() => _isScrolled = scrolled);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    final profile = profileProvider.profile;
    final lang = profileProvider.selectedLanguage;
    final products = productProvider.products;
    final pendingRequests = requestProvider.requests.where((r) => r.status == 'pending').toList();

    final initials = profile.name.trim().isNotEmpty
        ? profile.name
            .trim()
            .split(RegExp(r'\s+'))
            .where((s) => s.isNotEmpty)
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : 'A';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ─── Clean Header App Bar ──────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: _isScrolled
                ? AppColors.surfaceContainerLowest.withValues(alpha: 0.98)
                : AppColors.background,
            elevation: _isScrolled ? 1.5 : 0,
            shadowColor: AppColors.cardShadow,
            titleSpacing: 16,
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.tr('dukaan_title', lang),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                    ),
                    Text(
                      AppLocalizations.tr('dukaan_subtitle', lang),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Language Switcher Button
              GestureDetector(
                onTap: () => _showLanguageSheet(context),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outlineVariant),
                    boxShadow: const [
                      BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, 1)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.translate, size: 15, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        lang == 'mr' ? 'मराठी' : (lang == 'hi' ? 'हिंदी' : 'English'),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),

              // Profile Avatar
              GestureDetector(
                onTap: () => context.read<NavigationProvider>().setIndex(3),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryFixed,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),

          // ─── Focused Content ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Greeting
                  _buildGreetingHeader(context, profile.name, lang),

                  const SizedBox(height: 14),

                  // 2. Prominent Opportunity Banner (3 Buyers Looking)
                  _buildOpportunityBanner(context, lang),

                  const SizedBox(height: 16),

                  // 3. Hero Card: Add Craft in 1 Minute
                  _buildHeroActionCard(context, profile.name, lang),

                  const SizedBox(height: 18),

                  // 4. Quick Actions Grid (My Products, Find Buyers, My Earnings, Digital Mela)
                  _buildQuickActionsGrid(context, lang, products.length),

                  const SizedBox(height: 18),

                  // 5. AI Tip Card
                  _buildAiTipCard(context, lang),

                  const SizedBox(height: 18),

                  // 6. Today's Summary (3 Clean Badges)
                  _buildSummaryStats(context, lang, products.length, pendingRequests.length),

                  const SizedBox(height: 20),

                  // 7. Urgent Buyer Demands (Actionable Orders)
                  _buildBuyerDemandsSection(context, lang, pendingRequests, requestProvider),

                  const SizedBox(height: 20),

                  // 8. My Recent Products Carousel
                  _buildRecentProductsSection(context, lang, products),

                  const SizedBox(height: 20),

                  // 9. Government Benefits & Support
                  _buildGovernmentBenefitsBanner(context, lang),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Greeting Header ───────────────────────────────────────────────────────
  Widget _buildGreetingHeader(BuildContext context, String artisanName, String lang) {
    final displayName = artisanName.isNotEmpty ? artisanName.split(' ').first : 'Artisan';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.tr('greeting_morning', lang)}, $displayName 👋',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 3),
        Text(
          AppLocalizations.tr('home_subtitle', lang),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ─── Prominent Opportunity Banner ──────────────────────────────────────────
  Widget _buildOpportunityBanner(BuildContext context, String lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up_rounded, size: 15, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.tr('high_demand_tag', lang),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.public_rounded, color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.tr('buyers_looking_banner', lang),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 17.5,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => BuyerLeadsSheet.show(context),
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: Text(
              AppLocalizations.tr('view_buyers', lang),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Quick Actions Grid ───────────────────────────────────────────────────
  Widget _buildQuickActionsGrid(BuildContext context, String lang, int productCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.tr('quick_actions', lang),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.inventory_2_rounded,
                iconBg: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                title: AppLocalizations.tr('my_products_label', lang),
                subtitle: '$productCount ${AppLocalizations.tr('active_count', lang)}',
                onTap: () => context.read<NavigationProvider>().setIndex(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.storefront_rounded,
                iconBg: AppColors.sand,
                iconColor: AppColors.primary,
                title: AppLocalizations.tr('find_buyers_label', lang),
                subtitle: '3 ${AppLocalizations.tr('new_leads', lang)}',
                onTap: () => BuyerLeadsSheet.show(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.payments_rounded,
                iconBg: AppColors.primaryFixed,
                iconColor: AppColors.primaryDark,
                title: AppLocalizations.tr('my_earnings_label', lang),
                subtitle: '₹28,500 ${AppLocalizations.tr('this_month', lang)}',
                onTap: () => context.push('/smart_pricing'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.festival_rounded,
                iconBg: AppColors.surfaceContainer,
                iconColor: AppColors.primary,
                title: AppLocalizations.tr('digital_mela_label', lang),
                subtitle: AppLocalizations.tr('live_now', lang),
                onTap: () => context.read<NavigationProvider>().setIndex(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }

  // ─── AI Tip Card ──────────────────────────────────────────────────────────
  Widget _buildAiTipCard(BuildContext context, String lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.tr('ai_tip_title', lang),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.tr('ai_tip_body', lang),
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ─── 1. Hero Action Card ───────────────────────────────────────────────────
  Widget _buildHeroActionCard(BuildContext context, String artisanName, String lang) {
    final displayName = artisanName.isNotEmpty ? artisanName.split(' ').first : 'Artisan';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_t(lang, en: 'Namaste', mr: 'नमस्ते', hi: 'नमस्ते')}, $displayName 🙏',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _t(
                        lang,
                        en: 'List your craft online in 1 minute with AI',
                        mr: 'फोटो काढा किंवा बोला, AI त्वरित विक्री तयार करेल',
                        hi: 'फोटो लें या बोलें, AI तुरंत आपकी बिक्री तैयार करेगा',
                      ),
                      style: const TextStyle(
                        color: AppColors.primaryFixed,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.primaryFixed, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Two Big Action Buttons (Photo & Voice)
          Row(
            children: [
              // Photo Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/add_product'),
                  icon: const Icon(Icons.camera_alt_rounded, size: 20),
                  label: Text(
                    _t(lang, en: 'Take Photo', mr: 'फोटो काढा', hi: 'फोटो लें'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Voice Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/voice_cataloger'),
                  icon: const Icon(Icons.mic_rounded, size: 20),
                  label: Text(
                    _t(lang, en: 'Speak Details', mr: 'बोलून सांगा', hi: 'बोलकर बताएं'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sand,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── 2. Today's Summary (3 Clean Stats) ────────────────────────────────────
  Widget _buildSummaryStats(BuildContext context, String lang, int productCount, int pendingCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Live Crafts
          _buildStatItem(
            context,
            icon: Icons.inventory_2_rounded,
            iconColor: AppColors.primary,
            title: '$productCount',
            label: _t(lang, en: 'Live Crafts', mr: 'एकूण वस्तू', hi: 'कुल उत्पाद'),
            onTap: () => context.read<NavigationProvider>().setIndex(1),
          ),
          Container(width: 1, height: 36, color: AppColors.divider),

          // Pending Buyer Demands
          _buildStatItem(
            context,
            icon: Icons.chat_bubble_rounded,
            iconColor: pendingCount > 0 ? Colors.deepOrange : AppColors.secondary,
            title: '$pendingCount',
            label: _t(lang, en: 'Buyer Demands', mr: 'नवीन मागण्या', hi: 'नई मांगें'),
            badge: pendingCount > 0,
            onTap: () => context.push('/buyer_requests'),
          ),
          Container(width: 1, height: 36, color: AppColors.divider),

          // Total Earnings
          _buildStatItem(
            context,
            icon: Icons.currency_rupee_rounded,
            iconColor: AppColors.success,
            title: '₹28.5k',
            label: _t(lang, en: 'Total Sales', mr: 'एकूण कमाई', hi: 'कुल कमाई'),
            onTap: () => _showEarningsDetail(context, lang),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String label,
    bool badge = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (badge) ...[
                  const SizedBox(width: 4),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 3. Urgent Buyer Demands Section ───────────────────────────────────────
  Widget _buildBuyerDemandsSection(
    BuildContext context,
    String lang,
    List<BuyerRequestModel> pendingRequests,
    BuyerRequestProvider requestProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _t(lang, en: 'Direct Buyer Demands', mr: 'थेट ग्राहक मागण्या', hi: 'सीधी ग्राहक मांगें'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/buyer_requests'),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                _t(lang, en: 'View All →', mr: 'सर्व पहा →', hi: 'सभी देखें →'),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (pendingRequests.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_outlined, color: AppColors.success, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _t(
                      lang,
                      en: 'Your store is active! We will notify you here when buyers request your crafts.',
                      mr: 'आपले दुकान सुरू आहे! ग्राहक मागणी आल्यावर येथे दिसेल.',
                      hi: 'आपकी दुकान सक्रिय है! ग्राहक मांग आने पर यहां दिखाई देगी।',
                    ),
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: pendingRequests.take(2).map((req) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            req.buyerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.sand,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${req.quantity} pcs',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${req.productTitle} • ${req.productPrice}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await requestProvider.updateStatus(req.id, 'accepted');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_t(
                                      lang,
                                      en: 'Order Accepted! Buyer notified.',
                                      mr: 'मागणी स्वीकारली! ग्राहकाला कळवले.',
                                      hi: 'मांग स्वीकृत! ग्राहक को सूचित किया।',
                                    )),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              _t(lang, en: 'Accept Order', mr: 'स्वीकारा', hi: 'स्वीकारें'),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => context.push('/buyer_requests'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.outline),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            _t(lang, en: 'Details', mr: 'तपशील', hi: 'विवरण'),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // ─── 4. My Recent Products Carousel ────────────────────────────────────────
  Widget _buildRecentProductsSection(BuildContext context, String lang, List<ProductModel> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _t(lang, en: 'My Crafts', mr: 'माझी उत्पादने', hi: 'मेरे उत्पाद'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.read<NavigationProvider>().setIndex(1),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                _t(lang, en: 'View Store →', mr: 'दुकान पहा →', hi: 'दुकान देखें →'),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == products.length) {
                // "+ Add New Craft" Card
                return InkWell(
                  onTap: () => context.push('/add_product'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.outline, style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _t(lang, en: '+ Add Craft', mr: '+ नवीन जोडा', hi: '+ नया जोड़ें'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
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

              return Container(
                width: 140,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: SizedBox(
                        height: 105,
                        width: double.infinity,
                        child: AppCraftImages.buildCraftImage(
                          imageUrl: displayImage,
                          categoryOrTitle: p.metadata.craftType,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                price,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.successContainer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _t(lang, en: 'Active', mr: 'सुरू', hi: 'लाइव'),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── 5. Government Benefits & Support Banner ───────────────────────────────
  Widget _buildGovernmentBenefitsBanner(BuildContext context, String lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sandLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.sandDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🏛️', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _t(
                    lang,
                    en: 'PM Vishwakarma & Government Support',
                    mr: 'पीएम विश्वकर्मा व सरकारी योजना',
                    hi: 'पीएम विश्वकर्मा एवं सरकारी सहायता',
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _t(
              lang,
              en: 'Get collateral-free loans up to ₹3,00,000 at 5% interest, toolkits, and market access.',
              mr: '५% व्याजाने ₹३,००,००० पर्यंत कर्ज, मोफत टूलकिट आणि प्रशिक्षण मिळवा.',
              hi: '५% ब्याज पर ₹३,००,००० तक बिना गारंटी ऋण, मुफ्त टूलकिट और प्रशिक्षण पाएं।',
            ),
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _showGovernmentSchemesSheet(context, lang),
            child: Row(
              children: [
                Text(
                  _t(
                    lang,
                    en: 'Explore Schemes & Workshops',
                    mr: 'सर्व योजना व कार्यशाळा पहा',
                    hi: 'सभी योजनाएं व कार्यशाला देखें',
                  ),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Modal Dialogs & Sheets ────────────────────────────────────────────────
  void _showEarningsDetail(BuildContext context, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_t(lang, en: 'Earnings Summary', mr: 'कमाई सारांश', hi: 'कमाई का विवरण')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ${_t(lang, en: 'Completed Orders: ₹24,000', mr: 'पूर्ण झालेल्या मागण्या: ₹२४,०००', hi: 'पूर्ण ऑर्डर: ₹२४,०००')}'),
            const SizedBox(height: 6),
            Text('• ${_t(lang, en: 'Pending Payouts: ₹4,500', mr: 'येणे बाकी रक्कम: ₹४,५००', hi: 'बकाया राशि: ₹४,५००')}'),
            const SizedBox(height: 6),
            Text('• ${_t(lang, en: 'Direct UPI transfer supported', mr: 'थेट बँक खात्यात / UPI मध्ये जमा', hi: 'सीधे बैंक खाते या UPI में')}',
                style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showGovernmentSchemesSheet(BuildContext context, String lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text(
              _t(lang, en: 'Artisan Schemes & Opportunities', mr: 'कारागीर योजना व संधी', hi: 'कारीगर योजनाएं एवं अवसर'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 14),

            // 1. PM Vishwakarma
            _buildSchemeCard(
              title: 'PM Vishwakarma Scheme',
              benefit: '₹3,00,000 loan at 5% interest + ₹15,000 Toolkit incentive',
              eligibility: 'Traditional artisans across 18 craft categories',
              tag: 'Government of India',
            ),
            const SizedBox(height: 10),

            // 2. ODOP
            _buildSchemeCard(
              title: 'ODOP (One District One Product)',
              benefit: 'Direct export support & state pavilion stalls in Delhi',
              eligibility: 'Artisans producing native regional specialties',
              tag: 'National Initiative',
            ),
            const SizedBox(height: 10),

            // 3. Upcoming Workshop
            _buildSchemeCard(
              title: 'AI Digital Photography Masterclass',
              benefit: 'Free virtual workshop on lighting & mobile craft photos',
              eligibility: 'All registered ShilpSetu artisans • This Saturday 4 PM',
              tag: 'Skill Training',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeCard({required String title, required String benefit, required String eligibility, required String tag}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(6)),
                child: Text(tag, style: const TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
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
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Choose Language / भाषा निवडा / भाषा चुनें',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('मराठी (Marathi)', style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: provider.selectedLanguage == 'mr' ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
              onTap: () {
                provider.setLanguage('mr');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('हिंदी (Hindi)', style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: provider.selectedLanguage == 'hi' ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
              onTap: () {
                provider.setLanguage('hi');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('English', style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: provider.selectedLanguage == 'en' ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
              onTap: () {
                provider.setLanguage('en');
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
