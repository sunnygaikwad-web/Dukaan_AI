import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/providers/product_provider.dart';
import '../../../core/constants/app_craft_images.dart';
import '../../../core/constants/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<UserProfileProvider>();
    final productProvider = context.watch<ProductProvider>();
    final profile = profileProvider.profile;
    final lang = profileProvider.selectedLanguage;
    final activeProductsCount = productProvider.products.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar ─────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text(
              AppLocalizations.tr('nav_profile', lang),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share_outlined, color: AppColors.textPrimary),
                onPressed: () => _showSharePortfolioSheet(context, profile),
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined, color: AppColors.textPrimary),
                onPressed: () => _showSettingsSheet(),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // ─── Profile Header Card ───────────────────────────────────
                _buildProfileHeader(profile),

                // ─── Action Buttons ────────────────────────────────────────
                _buildActionButtons(profile),

                // ─── Language Selector Card ─────────────────────────────────
                _buildLanguageCard(context, profileProvider),

                // ─── Role Switcher ─────────────────────────────────────────
                _buildRoleSwitcherCard(context, profileProvider),

                // ─── Key Metrics Grid ──────────────────────────────────────
                _buildMetricsGrid(profile, activeProductsCount),

                // ─── Earnings Analytics ────────────────────────────────────
                _buildEarningsAnalytics(),

                // ─── Government Scheme Cards ───────────────────────────────
                _buildGovernmentSchemes(),

                // ─── Community Mentor Connect ──────────────────────────────
                _buildCommunitySection(),

                // ─── Upcoming Workshops ────────────────────────────────────
                _buildWorkshops(),

                // ─── Buyer Reviews ─────────────────────────────────────────
                _buildReviews(profile),

                // ─── Sign Out ──────────────────────────────────────────────
                _buildSignOutSection(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile Header ────────────────────────────────────────────────────────
  Widget _buildProfileHeader(UserProfileModel profile) {
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

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor: AppColors.primaryFixed,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: GestureDetector(
                  onTap: () => _showEditProfileSheet(context, profile),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Name
          Text(
            profile.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Verified Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, color: Colors.white, size: 14),
                const SizedBox(width: 5),
                Text(
                  profile.isVerified ? 'Verified Master' : 'Artisan',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          Text(
            '${profile.craftType} • ${profile.location}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),

          // Mastery + Member row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.workspace_premium_outlined, color: AppColors.tertiary, size: 16),
                const SizedBox(width: 5),
                Text(
                  'Mastery: ${profile.masteryLevel}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Container(width: 1, height: 14, color: AppColors.divider),
                const SizedBox(width: 12),
                Icon(Icons.calendar_today_outlined, color: AppColors.textLight, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Member since ${profile.memberSince}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────
  Widget _buildActionButtons(UserProfileModel profile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showEditProfileSheet(context, profile),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showSharePortfolioSheet(context, profile),
              icon: Icon(Icons.share_outlined, size: 18, color: AppColors.textPrimary),
              label: Text('Share Portfolio', style: TextStyle(color: AppColors.textPrimary)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                side: BorderSide(color: AppColors.outline),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Language Selector Card ────────────────────────────────────────────────
  Widget _buildLanguageCard(BuildContext context, UserProfileProvider provider) {
    final lang = provider.selectedLanguage;
    final langName = lang == 'mr' ? 'मराठी (Marathi)' : (lang == 'hi' ? 'हिंदी (Hindi)' : 'English');

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: InkWell(
        onTap: () => _showLanguageSheet(),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.translate_rounded, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.tr('language_label', lang),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    langName,
                    style: const TextStyle(fontSize: 12.5, color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lang == 'mr' ? 'बदला' : (lang == 'hi' ? 'बदलें' : 'Change'),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Role Switcher ─────────────────────────────────────────────────────────
  Widget _buildRoleSwitcherCard(BuildContext context, UserProfileProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.switch_account, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Account Type', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text(
                  '👩‍🎨 Master Artisan',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 14, color: Colors.green.shade700),
                const SizedBox(width: 4),
                Text(
                  'Verified',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Metrics Grid ──────────────────────────────────────────────────────────
  Widget _buildMetricsGrid(UserProfileModel profile, int activeProductsCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricCard('TOTAL GLOBAL SALES', profile.globalSales, '+18.4% this month', AppColors.primary)),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricCard('ACTIVE PRODUCTS', '$activeProductsCount Listings', 'In craft catalog', AppColors.aiAssist)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildMetricCard('GLOBAL RATING', '${profile.rating.toStringAsFixed(1)} / 5.0', '${profile.totalReviews}+ buyer reviews', AppColors.tertiary)),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricCard('AI ASSIST INDEX', '99.2%', 'Fully AI-optimized listings', AppColors.secondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textLight,
              letterSpacing: 0.5,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.success, size: 12),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  sub,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Earnings Analytics ─────────────────────────────────────────────────────
  Widget _buildEarningsAnalytics() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Revenue Breakdown', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('This Year', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Visual chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(0.6, 'Jan', AppColors.primaryLight),
              _buildBar(0.75, 'Feb', AppColors.primary),
              _buildBar(0.5, 'Mar', AppColors.primaryLight),
              _buildBar(0.85, 'Apr', AppColors.primary),
              _buildBar(0.65, 'May', AppColors.primaryLight),
              _buildBar(0.9, 'Jun', AppColors.primary),
              _buildBar(0.7, 'Jul', AppColors.primaryLight),
              _buildBar(1.0, 'Aug', AppColors.primaryDark),
              _buildBar(0.8, 'Sep', AppColors.primaryLight),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRevenueType('Exports', '68%', AppColors.primary),
              Container(width: 1, height: 30, color: AppColors.divider),
              _buildRevenueType('Domestic', '32%', AppColors.secondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double fraction, String label, Color color) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 60 * fraction,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildRevenueType(String label, String percent, Color color) {
    return Column(
      children: [
        Text(percent, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.w800)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  // ── Government Schemes ─────────────────────────────────────────────────────
  Widget _buildGovernmentSchemes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('Government Welfare', style: Theme.of(context).textTheme.titleLarge),
        ),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _showSchemeDialog(
                  'GI-Tag Assistance Program',
                  'Geographical Indication (GI) certification provides legal protection and authentic heritage branding for your craft.\n\n✓ Verification of traditional process\n✓ Free government documentation support\n✓ Protection against imitation products\n✓ Premium price realization in export markets',
                ),
                child: _buildSchemeCard(
                  Icons.verified_user_outlined,
                  'GI-Tag Assistance',
                  'Government certification & legal paperwork support.',
                  'Check Status →',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _showSchemeDialog(
                  'PM Vishwakarma & Micro-Loans',
                  'Avail collateral-free financial support under PM Vishwakarma and Mudra Scheme.\n\n✓ Up to ₹3,00,000 credit at 5% concessional interest\n✓ ₹15,000 toolkit grant\n✓ Digital transaction incentives\n✓ National Artisan ID card integration',
                ),
                child: _buildSchemeCard(
                  Icons.account_balance_outlined,
                  'Micro-Loans',
                  'Low-interest Artisan credit & PM Vishwakarma scheme.',
                  'Explore Loans →',
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildSchemeCard(IconData icon, String title, String desc, String cta) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 26),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11), maxLines: 3),
          const SizedBox(height: 8),
          Text(cta, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  // ── Community Mentor ───────────────────────────────────────────────────────
  Widget _buildCommunitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Community Mentor Connect', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => _showMentorDialog(),
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryFixed,
                child: Text('UR', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Ustad Rahim Khan', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('Master Weaver', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.tertiaryDark, fontSize: 9)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('Specialized in Banarasi Brocade & Natural Dyes', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.tertiary, size: 13),
                        const SizedBox(width: 3),
                        Text('4.9 (120+ Mentees)', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _showMentorDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(70, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                child: const Text('Connect'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Upcoming Workshops ─────────────────────────────────────────────────────
  Widget _buildWorkshops() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upcoming Skill Workshops', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => _registerWorkshop(),
                child: const Text('View Schedule'),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        AppCraftImages.handloomWeaving,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primaryFixed),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.15),
                              Colors.black.withValues(alpha: 0.55),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(10)),
                          child: Text('Tomorrow, 4:00 PM', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Digital Cataloguing & Global Export Masterclass', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('Learn how to photograph and list your handmade crafts for international buyers.', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _registerWorkshop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 40),
                          side: BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        child: const Text('Register Free'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Buyer Reviews ──────────────────────────────────────────────────────────
  Widget _buildReviews(UserProfileModel profile) {
    final reviews = [
      {
        'name': 'Priya S.',
        'rating': '5.0',
        'comment': 'Absolutely stunning handmade craft! The attention to detail is remarkable. Proud to support our local artisans.',
        'time': '2 days ago'
      },
      {
        'name': 'John M.',
        'rating': '4.9',
        'comment': 'Shipped safely across borders without any damage. Beautiful packaging and authentic Indian artisan touch!',
        'time': '1 week ago'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Buyer Reviews', style: Theme.of(context).textTheme.titleLarge),
              Row(
                children: [
                  Icon(Icons.star, color: AppColors.tertiary, size: 16),
                  const SizedBox(width: 4),
                  Text('${profile.rating.toStringAsFixed(1)} · ${profile.totalReviews} reviews', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
        ...reviews.map((r) => Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.secondaryFixed,
                    child: Text(r['name']![0], style: TextStyle(color: AppColors.secondaryDark, fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r['name']!, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                        Text(r['time']!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: AppColors.tertiary, size: 12),
                        const SizedBox(width: 3),
                        Text(r['rating']!, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.tertiaryDark, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(r['comment']!, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5)),
            ],
          ),
        )),
      ],
    );
  }

  // ── Sign Out Section ───────────────────────────────────────────────────────
  Widget _buildSignOutSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: () => _confirmSignOut(),
          icon: Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
          label: Text(
            'Sign Out',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

  // ── Edit Profile Modal Sheet ────────────────────────────────────────────────
  void _showEditProfileSheet(BuildContext context, UserProfileModel profile) {
    final nameController = TextEditingController(text: profile.name);
    final craftController = TextEditingController(text: profile.craftType);
    final locationController = TextEditingController(text: profile.location);
    final stateController = TextEditingController(text: profile.state);
    final phoneController = TextEditingController(text: profile.phone);
    final bioController = TextEditingController(text: profile.bio);

    final craftSuggestions = [
      'Textiles', 'Pottery', 'Woodcraft', 'Jewellery',
      'Paintings', 'Weaving', 'Stone Art', 'Terracotta',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Artisan Profile',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Name
                _buildFieldLabel('Full Name / पूर्ण नाव'),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Sunny Patil',
                    prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 14),

                // Craft Type
                _buildFieldLabel('Craft Type / हस्तकला प्रकार'),
                TextField(
                  controller: craftController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Pottery, Textiles',
                    prefixIcon: Icon(Icons.brush_outlined, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 8),

                // Craft chips suggestions
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: craftSuggestions.map((craft) {
                    final isSelected = craftController.text == craft;
                    return GestureDetector(
                      onTap: () {
                        setSheetState(() {
                          craftController.text = craft;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          ),
                        ),
                        child: Text(
                          craft,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Location
                _buildFieldLabel('City & District / शहर आणि जिल्हा'),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Kolhapur, Maharashtra',
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 14),

                // Phone
                _buildFieldLabel('Phone / दूरध्वनी'),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '+91 9876543210',
                    prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 14),

                // Bio
                _buildFieldLabel('Craft Story / Bio'),
                TextField(
                  controller: bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Share a short story about your craftsmanship...',
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter your name')),
                        );
                        return;
                      }

                      await context.read<UserProfileProvider>().updateProfile(
                        name: nameController.text,
                        craftType: craftController.text.isNotEmpty ? craftController.text : profile.craftType,
                        location: locationController.text.isNotEmpty ? locationController.text : profile.location,
                        state: stateController.text.isNotEmpty ? stateController.text : profile.state,
                        phone: phoneController.text,
                        bio: bioController.text,
                      );

                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: const [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Profile updated successfully! ✨'),
                              ],
                            ),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    child: const Text('Save Profile Details'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Share Portfolio Sheet ─────────────────────────────────────────────────
  void _showSharePortfolioSheet(BuildContext context, UserProfileModel profile) {
    final portfolioUrl = 'https://shilpsetu.in/artisan/${profile.id}';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.qr_code_2_rounded, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 14),
              Text(
                'Share ${profile.name}\'s Portfolio',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Direct buyers to your verified ShilpSetu digital catalogue',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, color: AppColors.textLight, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        portfolioUrl,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      color: AppColors.primary,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: portfolioUrl));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Portfolio link copied to clipboard! 📋'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: 'Check out my craft collection on ShilpSetu: $portfolioUrl'));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ready to share on WhatsApp! Link copied.')),
                        );
                      },
                      icon: const Icon(Icons.message, size: 18),
                      label: const Text('WhatsApp'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: portfolioUrl));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link copied to clipboard! 📋')),
                        );
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Copy Link'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Dialog Helpers ────────────────────────────────────────────────────────
  void _showSchemeDialog(String title, String details) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        content: Text(details, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Verification documents requested. Our field representative will contact you.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Apply Now'),
          ),
        ],
      ),
    );
  }

  void _showMentorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Connect with Ustad Rahim Khan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ustad Rahim Khan has mentored over 120 weavers across India in natural dyes and global cataloguing.',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: InputDecoration(
                hintText: 'Write a note to Ustad ji...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mentorship connect request sent! 🤝'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _registerWorkshop() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.event_available, color: Colors.white),
            SizedBox(width: 8),
            Text('Registered for Masterclass! SMS sent with meeting link.'),
          ],
        ),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Settings Bottom Sheet ──────────────────────────────────────────────────
  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Text('Settings', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.language_outlined, color: AppColors.primary),
              title: const Text('Language / भाषा'),
              subtitle: const Text('मराठी / Hindi / English'),
              trailing: Icon(Icons.chevron_right, color: AppColors.textLight),
              onTap: () {
                Navigator.pop(ctx);
                _showLanguageSheet();
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_outlined, color: AppColors.primary),
              title: const Text('Notifications'),
              trailing: Icon(Icons.chevron_right, color: AppColors.textLight),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications are enabled')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: AppColors.primary),
              title: const Text('Help & Artisan Support'),
              trailing: Icon(Icons.chevron_right, color: AppColors.textLight),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Helpline: Toll-free 1800-SHILP-AI')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: AppColors.error),
              title: Text('Sign Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmSignOut();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet() {
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
            const Text('Choose Language / भाषा निवडा', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('मराठी (Marathi)'),
              trailing: provider.selectedLanguage == 'mr' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                provider.setLanguage('mr');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('हिंदी (Hindi)'),
              trailing: provider.selectedLanguage == 'hi' ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                provider.setLanguage('hi');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('English'),
              trailing: provider.selectedLanguage == 'en' ? const Icon(Icons.check, color: AppColors.primary) : null,
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

  // ── Sign Out Confirmation ──────────────────────────────────────────────────
  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sign Out?', style: Theme.of(context).textTheme.headlineSmall),
        content: Text(
          'Are you sure you want to sign out of your artisan account?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppColors.textLight)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService().signOut();
              if (!mounted) return;
              await context.read<UserProfileProvider>().clearProfile();
              if (!mounted) return;
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
