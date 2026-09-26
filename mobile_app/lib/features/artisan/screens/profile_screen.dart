import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/providers/product_provider.dart';
import '../../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
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
    final profileProvider = context.watch<UserProfileProvider>();
    final productProvider = context.watch<ProductProvider>();
    final profile = profileProvider.profile;
    final lang = profileProvider.selectedLanguage;
    final activeProductsCount = productProvider.products.length;

    final initials = profile.name.trim().isNotEmpty
        ? profile.name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).map((e) => e[0]).take(2).join().toUpperCase()
        : 'A';
    final pehchanId = 'MH-ART-${profile.id.replaceAll(RegExp(r'[^0-9]'), '').padRight(4, '8').substring(0, 4)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // ── Hero App Bar ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 255,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroCover(context, profile, lang, initials, pehchanId, profileProvider, activeProductsCount),
            ),
          ),

          // ── Stats Row ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _buildStatsRow(context, lang, activeProductsCount, profile),
          ),

          // ── Tab Bar ───────────────────────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textLight,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                tabs: [
                  Tab(text: _t(lang, en: 'Profile', mr: 'प्रोफाइल', hi: 'प्रोफाइल')),
                  Tab(text: _t(lang, en: 'Schemes', mr: 'योजना', hi: 'योजनाएं')),
                  Tab(text: _t(lang, en: 'Support', mr: 'मदत', hi: 'सहायता')),
                ],
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProfileTab(context, profile, lang, activeProductsCount, pehchanId),
            _buildSchemesTab(context, lang),
            _buildSupportTab(context, lang),
          ],
        ),
      ),
    );
  }

  // ── Hero Cover ──────────────────────────────────────────────────────────────
  Widget _buildHeroCover(BuildContext context, UserProfileModel profile, String lang, String initials, String pehchanId, UserProfileProvider provider, int productCount) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B2500), Color(0xFFB84A00), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(right: -30, top: -30, child: Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06)))),
          Positioned(left: -20, bottom: 30, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.04)))),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar: Language pills (left) + Action buttons (right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Language Selector Pills
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLangPill('मराठी', 'mr', provider),
                            const SizedBox(width: 4),
                            _buildLangPill('हिंदी', 'hi', provider),
                            const SizedBox(width: 4),
                            _buildLangPill('EN', 'en', provider),
                          ],
                        ),
                      ),

                      // Quick action buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeaderActionBtn(
                            icon: Icons.share_rounded,
                            tooltip: _t(lang, en: 'Share Profile', mr: 'माहिती शेअर करा', hi: 'प्रोफाइल शेयर करें'),
                            onTap: () => _showShareSheet(context, profile, lang),
                          ),
                          const SizedBox(width: 8),
                          _buildHeaderActionBtn(
                            icon: Icons.settings_outlined,
                            tooltip: _t(lang, en: 'Settings', mr: 'सेटिंग्ज', hi: 'सेटिंग्स'),
                            onTap: () => _showSettingsSheet(context, lang, provider),
                          ),
                          const SizedBox(width: 8),
                          _buildHeaderActionBtn(
                            icon: Icons.logout_rounded,
                            tooltip: _t(lang, en: 'Sign Out', mr: 'बाहेर पडा', hi: 'साइन आउट'),
                            color: Colors.red.shade700.withValues(alpha: 0.85),
                            onTap: () => _confirmSignOut(context, lang),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12)],
                            ),
                            child: CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.white.withValues(alpha: 0.2),
                              child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28)),
                            ),
                          ),
                          Positioned(
                            right: 2, bottom: 2,
                            child: GestureDetector(
                              onTap: () => _showEditProfileSheet(context, profile, lang),
                              child: Container(
                                width: 26, height: 26,
                                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 1.5)),
                                child: const Icon(Icons.edit, size: 13, color: AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Name & Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profile.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, height: 1.1)),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                                  child: Text('🏺 ${profile.craftType}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11.5)),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(8)),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    const Icon(Icons.verified, size: 10, color: Colors.white),
                                    const SizedBox(width: 3),
                                    const Text('VERIFIED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 0.5)),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(children: [
                              const Icon(Icons.location_on, size: 13, color: Colors.white70),
                              const SizedBox(width: 3),
                              Text(profile.location, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                            ]),
                            const SizedBox(height: 3),
                            Row(children: [
                              const Icon(Icons.badge_outlined, size: 13, color: Colors.white54),
                              const SizedBox(width: 3),
                              Text('ID: $pehchanId', style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'monospace')),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Audio Button
                  GestureDetector(
                    onTap: () => _showAudioProfile(context, profile, lang, productCount),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.volume_up_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          _t(lang, en: 'Listen to My Identity Card 🔊', mr: 'माझी माहिती बोलून ऐका 🔊', hi: 'पहचान आवाज में सुनें 🔊'),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white70),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangPill(String label, String code, UserProfileProvider provider) {
    final selected = provider.selectedLanguage == code;
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); provider.setLanguage(code); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.white : Colors.white38),
        ),
        child: Text(label, style: TextStyle(color: selected ? AppColors.primary : Colors.white, fontWeight: FontWeight.w800, fontSize: 11.5)),
      ),
    );
  }

  Widget _buildHeaderActionBtn({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color ?? Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1),
          ),
          child: Icon(icon, color: Colors.white, size: 17),
        ),
      ),
    );
  }

  // ── Stats Row ───────────────────────────────────────────────────────────────
  Widget _buildStatsRow(BuildContext context, String lang, int productCount, UserProfileModel profile) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          _buildStat(context, value: '$productCount', label: _t(lang, en: 'Live Crafts', mr: 'उत्पादने', hi: 'उत्पाद'), icon: Icons.inventory_2_rounded, color: AppColors.primary),
          _buildStatDivider(),
          _buildStat(context, value: profile.globalSales, label: _t(lang, en: 'Total Sales', mr: 'एकूण कमाई', hi: 'कुल कमाई'), icon: Icons.currency_rupee_rounded, color: AppColors.success),
          _buildStatDivider(),
          _buildStat(context, value: '${profile.rating.toStringAsFixed(1)}★', label: _t(lang, en: '${profile.totalReviews}+ Reviews', mr: '${profile.totalReviews}+ अभिप्राय', hi: '${profile.totalReviews}+ रिव्यू'), icon: Icons.star_rounded, color: const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, {required String value, required String label, required IconData icon, required Color color}) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textLight, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStatDivider() => Container(width: 1, height: 50, color: AppColors.outlineVariant);

  // ── Profile Tab ─────────────────────────────────────────────────────────────
  Widget _buildProfileTab(BuildContext context, UserProfileModel profile, String lang, int productCount, String pehchanId) {
    final phone = profile.phone.isNotEmpty ? profile.phone : '+91 98765 43210';
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info Cards
        _buildSectionTitle(_t(lang, en: 'My Information', mr: 'माझी माहिती', hi: 'मेरी जानकारी')),
        const SizedBox(height: 12),

        _buildInfoTile(icon: Icons.phone_in_talk_rounded, color: AppColors.success,
          title: _t(lang, en: 'Mobile Number', mr: 'मोबाईल नंबर', hi: 'मोबाइल नंबर'),
          value: phone, badge: _t(lang, en: 'Active', mr: 'सक्रिय', hi: 'सक्रिय'), badgeColor: AppColors.success,
          onTap: () => _showEditProfileSheet(context, profile, lang)),

        _buildInfoTile(icon: Icons.palette_rounded, color: const Color(0xFFEA580C),
          title: _t(lang, en: 'Craft Specialty', mr: 'हस्तकला', hi: 'हस्तशिल्प'),
          value: profile.craftType, badge: _t(lang, en: 'Heritage', mr: 'वारसा', hi: 'विरासत'), badgeColor: const Color(0xFFEA580C),
          onTap: () => _showEditProfileSheet(context, profile, lang)),

        _buildInfoTile(icon: Icons.account_balance_rounded, color: const Color(0xFF6366F1),
          title: _t(lang, en: 'Bank Account', mr: 'बँक खाते', hi: 'बैंक खाता'),
          value: 'State Bank of India (**** 4321)', badge: '0% Comm.', badgeColor: const Color(0xFF6366F1),
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_t(lang, en: 'Direct Bank Deposit Active', mr: 'थेट बँक जमा सक्रिय', hi: 'सीधा बैंक भुगतान चालू')), behavior: SnackBarBehavior.floating))),

        _buildInfoTile(icon: Icons.storefront_rounded, color: const Color(0xFF8B5CF6),
          title: _t(lang, en: 'My Shop', mr: 'माझे दुकान', hi: 'मेरी दुकान'),
          value: _t(lang, en: '$productCount items active', mr: '$productCount वस्तू उपलब्ध', hi: '$productCount उत्पाद उपलब्ध'), badge: _t(lang, en: 'Open', mr: 'सुरू', hi: 'चालू'), badgeColor: AppColors.success,
          onTap: () => context.go('/artisan/products')),

        const SizedBox(height: 20),

        // Earnings Card
        _buildSectionTitle(_t(lang, en: 'Earnings & Trust', mr: 'कमाई व विश्वास', hi: 'कमाई और भरोसा')),
        const SizedBox(height: 12),
        _buildEarningsCard(context, profile, lang),

        const SizedBox(height: 20),

        // Official ID Card
        _buildSectionTitle(_t(lang, en: 'Official Identity Card', mr: 'अधिकृत ओळखपत्र', hi: 'आधिकारिक पहचान पत्र')),
        const SizedBox(height: 12),
        _buildOfficialIdCard(profile, lang, pehchanId, productCount),

        const SizedBox(height: 20),

        // Sign Out
        _buildSignOutButton(context, lang),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textPrimary));

  Widget _buildInfoTile({required IconData icon, required Color color, required String title, required String value, required String badge, required Color badgeColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: const TextStyle(fontSize: 11.5, color: AppColors.textLight, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                        child: Text(badge, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: badgeColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(value, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: color.withValues(alpha: 0.5), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard(BuildContext context, UserProfileModel profile, String lang) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF064E3B), Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF059669).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(_t(lang, en: 'Total Earnings', mr: 'एकूण कमाई', hi: 'कुल कमाई'),
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 13)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                child: Text(_t(lang, en: '✓ Direct to Bank', mr: '✓ थेट बँकेत', hi: '✓ सीधे बैंक में'),
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(profile.globalSales, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(
            _t(lang, en: '100% credited directly — 0% commission, 0% middlemen.', mr: '१००% थेट बँकेत जमा — ०% दलाली, ०% कमिशन.', hi: '100% सीधे बैंक में — 0% कमीशन, 0% बिचौलिया.'),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 18),
            const SizedBox(width: 5),
            Text('${profile.rating.toStringAsFixed(1)} / 5.0', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(width: 8),
            Text('• ${profile.totalReviews}+ ${_t(lang, en: 'reviews', mr: 'अभिप्राय', hi: 'रिव्यू')}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12)),
          ]),
        ],
      ),
    );
  }

  Widget _buildOfficialIdCard(UserProfileModel profile, String lang, String pehchanId, int productCount) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFFDF8), Color(0xFFFFF6E8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5C096), width: 1.5),
        boxShadow: [BoxShadow(color: const Color(0x1A8B4513), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Tricolor stripe
            Row(children: [
              Expanded(child: Container(height: 4, color: const Color(0xFFFF9933))),
              Expanded(child: Container(height: 4, color: Colors.white)),
              Expanded(child: Container(height: 4, color: const Color(0xFF138808))),
            ]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(
                      _t(lang, en: 'GOVT. RECOGNIZED ARTISAN PEHCHAN CARD', mr: 'कारागीर ओळखपत्र', hi: 'कारीगर पहचान पत्र'),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF6B3004), letterSpacing: 0.5),
                    )),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(8)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.verified, size: 10, color: Colors.white),
                        const SizedBox(width: 3),
                        Text(_t(lang, en: 'VERIFIED', mr: 'प्रमाणित', hi: 'सत्यापित'), style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w800)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    _buildIdField(_t(lang, en: 'Name', mr: 'नाव', hi: 'नाम'), profile.name),
                    const SizedBox(width: 16),
                    _buildIdField(_t(lang, en: 'Craft', mr: 'हस्तकला', hi: 'हस्तशिल्प'), profile.craftType),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    _buildIdField(_t(lang, en: 'Pehchan ID', mr: 'ओळख क्रमांक', hi: 'पहचान ID'), pehchanId),
                    const SizedBox(width: 16),
                    _buildIdField(_t(lang, en: 'Active Products', mr: 'उत्पादने', hi: 'उत्पाद'), '$productCount'),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    _buildIdField(_t(lang, en: 'Location', mr: 'स्थान', hi: 'स्थान'), profile.location),
                    const SizedBox(width: 16),
                    _buildIdField(_t(lang, en: 'State', mr: 'राज्य', hi: 'राज्य'), profile.state.isNotEmpty ? profile.state : 'Maharashtra'),
                  ]),
                  const SizedBox(height: 12),
                  Text(_t(lang, en: 'Ministry of Textiles & ShilpSetu Digital Registry', mr: 'वस्त्रोद्योग मंत्रालय व शिल्पसेतू', hi: 'वस्त्र मंत्रालय एवं शिल्पसेतु'),
                    style: TextStyle(fontSize: 10, color: Colors.brown.shade600, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdField(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.textLight, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context, String lang) {
    return GestureDetector(
      onTap: () => _confirmSignOut(context, lang),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red.shade600, size: 20),
            const SizedBox(width: 8),
            Text(_t(lang, en: 'Sign Out', mr: 'बाहेर पडा', hi: 'साइन आउट करें'),
              style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  // ── Schemes Tab ─────────────────────────────────────────────────────────────
  Widget _buildSchemesTab(BuildContext context, String lang) {
    final schemes = [
      _SchemeData(
        emoji: '🏗️',
        title: 'PM Vishwakarma Scheme',
        subtitle: _t(lang, en: '₹3L loan at 5% + ₹15,000 toolkit', mr: '₹३ लाख ५% व्याज + ₹१५,००० टूलकिट', hi: '₹3 लाख 5% ब्याज + ₹15,000 टूलकिट'),
        tag: _t(lang, en: 'Govt. of India', mr: 'भारत सरकार', hi: 'भारत सरकार'),
        color: AppColors.primary,
        detail: _t(lang,
          en: '✓ ₹15,000 toolkit grant\n✓ Up to ₹3,00,000 at 5% interest\n✓ Official Artisan identity card\n✓ Free skill training programs',
          mr: '✓ ₹१५,००० मोफत टूलकिट\n✓ ₹३ लाखांपर्यंत ५% कर्ज\n✓ अधिकृत ओळखपत्र\n✓ मोफत कौशल्य प्रशिक्षण',
          hi: '✓ ₹15,000 फ्री टूलकिट\n✓ ₹3 लाख तक 5% ऋण\n✓ आधिकारिक पहचान पत्र\n✓ निःशुल्क कौशल प्रशिक्षण'),
      ),
      _SchemeData(
        emoji: '🌏',
        title: 'ODOP – One District One Product',
        subtitle: _t(lang, en: 'Export support & state pavilions', mr: 'निर्यात मदत व राज्य प्रदर्शनी', hi: 'निर्यात सहायता और राज्य प्रदर्शनी'),
        tag: _t(lang, en: 'National Initiative', mr: 'राष्ट्रीय उपक्रम', hi: 'राष्ट्रीय पहल'),
        color: const Color(0xFF0EA5E9),
        detail: _t(lang,
          en: '✓ Direct export market access\n✓ State pavilion stalls in Delhi\n✓ Premium branding support\n✓ Free packaging assistance',
          mr: '✓ थेट निर्यात बाजार\n✓ दिल्लीत राज्य प्रदर्शनी\n✓ प्रीमियम ब्रँडिंग मदत\n✓ मोफत पॅकेजिंग सहाय्य',
          hi: '✓ सीधी निर्यात बाजार पहुंच\n✓ दिल्ली में राज्य मंडप\n✓ प्रीमियम ब्रांडिंग सहायता\n✓ मुफ्त पैकेजिंग सहायता'),
      ),
      _SchemeData(
        emoji: '🏷️',
        title: 'GI-Tag Heritage Certification',
        subtitle: _t(lang, en: 'Geographical Indication protection', mr: 'भौगोलिक मानांकन संरक्षण', hi: 'भौगोलिक पहचान संरक्षण'),
        tag: _t(lang, en: 'Legal Protection', mr: 'कायदेशीर', hi: 'कानूनी'),
        color: const Color(0xFF8B5CF6),
        detail: _t(lang,
          en: '✓ Legal protection for your craft\n✓ Premium market prices\n✓ Protection from fake copies\n✓ Free government documentation',
          mr: '✓ कलेला कायदेशीर संरक्षण\n✓ बाजारात जास्त भाव\n✓ बनावट वस्तूंपासून संरक्षण\n✓ मोफत शासकीय कागदपत्र',
          hi: '✓ शिल्प को कानूनी सुरक्षा\n✓ बाजार में बेहतर मूल्य\n✓ नकली माल से सुरक्षा\n✓ मुफ्त सरकारी दस्तावेज़'),
      ),
      _SchemeData(
        emoji: '📸',
        title: _t(lang, en: 'Digital Photography Masterclass', mr: 'डिजिटल फोटोग्राफी वर्कशॉप', hi: 'डिजिटल फोटोग्राफी मास्टरक्लास'),
        subtitle: _t(lang, en: 'Free workshop • This Saturday 4 PM', mr: 'मोफत कार्यशाळा • हा शनिवार ४ PM', hi: 'निःशुल्क वर्कशॉप • इस शनिवार 4 PM'),
        tag: _t(lang, en: 'Skill Training', mr: 'कौशल्य', hi: 'कौशल'),
        color: const Color(0xFFEC4899),
        detail: _t(lang,
          en: '✓ Mobile photography lighting tips\n✓ Product background setup\n✓ Editing for better listings\n✓ All ShilpSetu artisans welcome',
          mr: '✓ मोबाईल फोटोग्राफी टिप्स\n✓ उत्पाद बॅकग्राउंड सेटअप\n✓ फोटो सुधारणा तंत्र\n✓ सर्व नोंदणीकृत कारागीर',
          hi: '✓ मोबाइल फोटोग्राफी टिप्स\n✓ उत्पाद बैकग्राउंड सेटअप\n✓ फोटो एडिटिंग तकनीक\n✓ सभी ShilpSetu कारीगर'),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            const Text('🏛️', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(child: Text(
              _t(lang, en: 'Government schemes & opportunities available for you.', mr: 'तुमच्यासाठी शासकीय योजना उपलब्ध आहेत.', hi: 'आपके लिए सरकारी योजनाएं उपलब्ध हैं।'),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.primaryDark),
            )),
          ]),
        ),
        const SizedBox(height: 16),
        ...schemes.map((s) => _buildSchemeCard(context, s, lang)).toList(),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSchemeCard(BuildContext context, _SchemeData s, String lang) {
    return GestureDetector(
      onTap: () => _showSchemeDetail(context, s),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: s.color.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: s.color.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: s.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(s.emoji, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: s.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(s.tag, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: s.color)),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(s.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(s.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: s.color),
          ],
        ),
      ),
    );
  }

  void _showSchemeDetail(BuildContext context, _SchemeData s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Text(s.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                Text(s.subtitle, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
              ])),
            ]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: s.color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14)),
              child: Text(s.detail, style: const TextStyle(fontSize: 14, height: 1.7, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: s.color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Support Tab ─────────────────────────────────────────────────────────────
  Widget _buildSupportTab(BuildContext context, String lang) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Helpline Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFE65100), Color(0xFFFF6D00)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: const Color(0xFFE65100).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 22)),
                const SizedBox(width: 10),
                Text(_t(lang, en: 'Artisan Helpline', mr: 'कारागीर मदत केंद्र', hi: 'कारीगर हेल्पलाइन'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              ]),
              const SizedBox(height: 8),
              Text(_t(lang, en: 'Free assistance in Marathi & Hindi', mr: 'मराठी व हिंदीत मोफत सहाय्य', hi: 'मराठी और हिंदी में निःशुल्क'),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12.5)),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Toll-Free: 1800-123-4567'), behavior: SnackBarBehavior.floating)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.call, color: Color(0xFFE65100), size: 18),
                      const SizedBox(width: 6),
                      Text(_t(lang, en: 'Call Now', mr: 'फोन करा', hi: 'कॉल करें'), style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.w800, fontSize: 13)),
                    ]),
                  ),
                )),
                const SizedBox(width: 10),
                Expanded(child: GestureDetector(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_t(lang, en: 'Opening WhatsApp...', mr: 'व्हॉट्सअॅप उघडत आहे...', hi: 'व्हाट्सएप खुल रहा है...')), behavior: SnackBarBehavior.floating)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.5))),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.chat_rounded, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text('WhatsApp', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                    ]),
                  ),
                )),
              ]),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // FAQ Items
        _buildSectionTitle(_t(lang, en: 'Frequently Asked', mr: 'वारंवार विचारले', hi: 'अक्सर पूछे जाते')),
        const SizedBox(height: 12),

        ...[
          (_t(lang, en: 'How do I get paid?', mr: 'पैसे कसे मिळतात?', hi: 'पैसे कैसे मिलते हैं?'),
           _t(lang, en: 'All buyer payments go directly to your registered bank account within 2-3 business days. Zero commission.', mr: 'सर्व ग्राहकांचे पैसे थेट तुमच्या बँक खात्यात २-३ दिवसांत जमा होतात. कोणतीही दलाली नाही.', hi: 'सभी भुगतान सीधे आपके बैंक खाते में 2-3 दिन में जमा होते हैं। कोई कमीशन नहीं।')),
          (_t(lang, en: 'How to add more products?', mr: 'अधिक वस्तू कशा जोडाव्यात?', hi: 'अधिक उत्पाद कैसे जोड़ें?'),
           _t(lang, en: 'Go to Dashboard → Take Photo or Speak Details. AI will create the listing automatically.', mr: 'डॅशबोर्ड वर जा → फोटो काढा किंवा बोलून सांगा. AI आपोआप तयार करेल.', hi: 'डैशबोर्ड → फोटो लें या बोलकर बताएं। AI अपने आप लिस्टिंग बना देगा।')),
          (_t(lang, en: 'How to contact buyers?', mr: 'ग्राहकांशी कसे बोलावे?', hi: 'खरीदारों से कैसे संपर्क करें?'),
           _t(lang, en: 'Use the "Buyer Chats" section on the Dashboard to message buyers directly.', mr: 'डॅशबोर्डवरील "खरेदीदार संवाद" विभागात थेट ग्राहकांशी बोला.', hi: 'डैशबोर्ड के "खरीदार चैट" अनुभाग में सीधे संपर्क करें।')),
        ].map((faq) => _buildFaqTile(faq.$1, faq.$2)).toList(),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.outlineVariant)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        shape: const Border(),
        leading: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 18)),
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.textPrimary)),
        children: [Text(answer, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5))],
      ),
    );
  }

  // ── Modals ───────────────────────────────────────────────────────────────────
  void _showAudioProfile(BuildContext context, UserProfileModel profile, String lang, int productCount) {
    HapticFeedback.heavyImpact();
    final phone = profile.phone.isNotEmpty ? profile.phone : '+91 98765 43210';
    final text = lang == 'mr'
      ? '🙏 नमस्कार! माझे नाव ${profile.name} आहे.\n\nमी ${profile.location} येथील ${profile.craftType} कारागीर आहे.\n\nफोन: $phone\n\nशिल्पसेतू दुकानात माझ्या $productCount वस्तू विक्रीसाठी उपलब्ध आहेत.\n\nमाझी सर्व कमाई थेट बँकेत विना दलाल जमा होते.'
      : lang == 'hi'
        ? '🙏 नमस्ते! मेरा नाम ${profile.name} है।\n\nमैं ${profile.location} से ${profile.craftType} का कारीगर हूँ।\n\nफोन: $phone\n\nशिल्पसेतु दुकान में मेरे $productCount उत्पाद हैं।\n\nमेरी कमाई सीधे बैंक में जमा होती है।'
        : '🙏 Hello! My name is ${profile.name}.\n\nI am a ${profile.craftType} artisan from ${profile.location}.\n\nPhone: $phone\n\nI have $productCount items in my ShilpSetu shop.\n\nAll earnings are credited directly to my bank account.';

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Row(children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
                child: const Icon(Icons.graphic_eq_rounded, color: AppColors.primary, size: 26)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_t(lang, en: 'Artisan Audio Profile', mr: 'माहिती बोलून दाखवत आहे 🔊', hi: 'आवाज में पहचान 🔊'),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                Text(_t(lang, en: 'Your profile in your language', mr: 'तुमची माहिती मराठीत', hi: 'आपकी जानकारी हिंदी में'),
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ])),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
            ]),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFFF8EE), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5C096))),
              child: Text(text, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.6)),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_t(lang, en: 'Replaying...', mr: 'पुन्हा ऐकवत आहे...', hi: 'फिर से...')), duration: const Duration(seconds: 2))),
                icon: const Icon(Icons.replay_rounded, size: 17),
                label: Text(_t(lang, en: 'Replay 🔊', mr: 'पुन्हा ऐका 🔊', hi: 'फिर सुनें 🔊')),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 13), side: const BorderSide(color: AppColors.primary), foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              )),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(_t(lang, en: 'Got it 👍', mr: 'समजले 👍', hi: 'समझ गया 👍')),
              )),
            ]),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, UserProfileModel profile, String lang) {
    final nameCtrl = TextEditingController(text: profile.name);
    final phoneCtrl = TextEditingController(text: profile.phone);
    final craftCtrl = TextEditingController(text: profile.craftType);
    final locationCtrl = TextEditingController(text: profile.location);
    final provider = context.read<UserProfileProvider>();

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text(_t(lang, en: 'Edit Profile', mr: 'माहिती बदला', hi: 'प्रोफाइल संपादित करें'),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 16),
              _editField(nameCtrl, _t(lang, en: 'Full Name', mr: 'पूर्ण नाव', hi: 'पूरा नाम'), Icons.person_outline),
              const SizedBox(height: 10),
              _editField(phoneCtrl, _t(lang, en: 'Mobile Number', mr: 'मोबाईल नंबर', hi: 'मोबाइल नंबर'), Icons.phone_outlined, keyboard: TextInputType.phone),
              const SizedBox(height: 10),
              _editField(craftCtrl, _t(lang, en: 'Craft Type', mr: 'हस्तकला प्रकार', hi: 'हस्तशिल्प प्रकार'), Icons.palette_outlined),
              const SizedBox(height: 10),
              _editField(locationCtrl, _t(lang, en: 'Location / Village', mr: 'ठिकाण / गाव', hi: 'स्थान / गाँव'), Icons.location_on_outlined),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await provider.updateProfile(name: nameCtrl.text.trim(), phone: phoneCtrl.text.trim(), craftType: craftCtrl.text.trim(), location: locationCtrl.text.trim());
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_t(lang, en: 'Profile updated!', mr: 'माहिती अद्यतन झाली!', hi: 'प्रोफाइल अपडेट हुई!')), backgroundColor: AppColors.success));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: Text(_t(lang, en: 'Save Changes', mr: 'बदल जतन करा', hi: 'परिवर्तन सहेजें'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _editField(TextEditingController ctrl, String label, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: const Color(0xFFF7F4F0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13.5),
      ),
    );
  }

  void _showShareSheet(BuildContext context, UserProfileModel profile, String lang) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(_t(lang, en: 'Share My Profile', mr: 'प्रोफाइल शेअर करा', hi: 'प्रोफाइल शेयर करें'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(14)),
              child: Column(children: [
                Text('🏺 ${profile.name} — ${profile.craftType}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primaryDark)),
                const SizedBox(height: 4),
                Text('📍 ${profile.location}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text('🛍️ shilpsetu.in/artisan/${profile.id}', style: const TextStyle(fontSize: 12.5, color: AppColors.primary, fontWeight: FontWeight.w700)),
              ]),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: ElevatedButton.icon(
                onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Portfolio link copied!'), behavior: SnackBarBehavior.floating)); },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(_t(lang, en: 'Copy Link', mr: 'लिंक कॉपी करा', hi: 'लिंक कॉपी करें')),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              )),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(
                onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening WhatsApp share...'), behavior: SnackBarBehavior.floating)); },
                icon: const Icon(Icons.share_rounded, size: 18),
                label: const Text('WhatsApp'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 13), side: const BorderSide(color: AppColors.outline), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              )),
            ]),
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, String lang, UserProfileProvider provider) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(_t(lang, en: 'Settings', mr: 'सेटिंग्ज', hi: 'सेटिंग्स'),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 12),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.key_rounded, color: AppColors.primary, size: 20)),
                title: Text(_t(lang, en: 'AI API Key', mr: 'AI API की', hi: 'AI API कुंजी'), style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(_t(lang, en: 'Configure Gemini API', mr: 'Gemini API सेट करा', hi: 'Gemini API सेट करें'), style: const TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () { Navigator.pop(ctx); context.push('/settings'); },
              ),
              ListTile(
                leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.logout_rounded, color: Colors.red.shade600, size: 20)),
                title: Text(_t(lang, en: 'Sign Out', mr: 'बाहेर पडा', hi: 'साइन आउट'), style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red.shade600)),
                trailing: Icon(Icons.chevron_right, color: Colors.red.shade300),
                onTap: () { Navigator.pop(ctx); _confirmSignOut(context, lang); },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
              child: Icon(Icons.logout_rounded, color: Colors.red.shade600, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _t(lang, en: 'Sign Out?', mr: 'बाहेर पडायचे आहे?', hi: 'साइन आउट करना है?'),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          _t(lang,
            en: 'You will be signed out and returned to the login screen.',
            mr: 'तुम्ही बाहेर पडाल आणि लॉगिन स्क्रीनवर पोहोचाल.',
            hi: 'आप साइन आउट हो जाएंगे और लॉगिन स्क्रीन पर पहुंचेंगे।',
          ),
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              _t(lang, en: 'Cancel', mr: 'रद्द करा', hi: 'रद्द करें'),
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await AuthService().signOut();
              } catch (e) {
                debugPrint('AuthService signOut error: $e');
              }
              if (context.mounted) {
                try {
                  await context.read<UserProfileProvider>().clearProfile();
                  context.read<NavigationProvider>().setIndex(0);
                } catch (e) {
                  debugPrint('Profile clear error: $e');
                }
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              _t(lang, en: 'Sign Out', mr: 'बाहेर पडा', hi: 'साइन आउट'),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sliver Tab Bar Delegate ───────────────────────────────────────────────────
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height + 1;
  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(children: [tabBar, const Divider(height: 1)]),
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => tabBar != oldDelegate.tabBar;
}

// ── Scheme Data Model ─────────────────────────────────────────────────────────
class _SchemeData {
  final String emoji, title, subtitle, tag, detail;
  final Color color;
  const _SchemeData({required this.emoji, required this.title, required this.subtitle, required this.tag, required this.color, required this.detail});
}
