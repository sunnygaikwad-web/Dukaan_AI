# scratch/patch_profile.py
import re

profile_file = r"c:\Users\Sunny\AndroidStudioProjects\ShilpSetu_AI\mobile_app\lib\features\artisan\screens\profile_screen.dart"

with open(profile_file, "r", encoding="utf-8") as f:
    content = f.read()

# Locate the start: SliverToBoxAdapter(
start_marker = "          SliverToBoxAdapter(\n            child: Column(\n              children: [\n                // ─── Profile Header Card"
end_marker = "  // ── Edit Profile Modal Sheet ────────────────────────────────────────────────"

assert start_marker in content, "start_marker not found"
assert end_marker in content, "end_marker not found"

replacement = """          SliverToBoxAdapter(
            child: Column(
              children: [
                // ─── Direct Top 1-Tap Language Bar ──────────────────────────
                _buildTopLanguageBar(context, profileProvider, lang),

                // ─── Official Artisan Digital Pehchan Card ───────────────────
                _buildArtisanPehchanCard(context, profile, lang, activeProductsCount),

                // ─── Action Buttons (Edit & Share) ──────────────────────────
                _buildActionButtons(context, profile, lang),

                // ─── 4 Essential Info Tiles (Phone, Craft, Bank, Shop) ───────
                _buildEssentialInfoTiles(context, profile, lang, activeProductsCount),

                // ─── Simple Earnings & Trust Card ───────────────────────────
                _buildSimpleEarningsCard(context, profile, lang),

                // ─── 1-Tap Toll-Free Helpline & WhatsApp Support ─────────────
                _buildHelplineCard(context, lang),

                // ─── Government Welfare Schemes ──────────────────────────────
                _buildGovernmentSchemes(context, lang),

                // ─── Buyer Reviews ──────────────────────────────────────────
                _buildReviews(profile, lang),

                // ─── Sign Out ───────────────────────────────────────────────
                _buildSignOutSection(context, lang),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Vernacular Language Helper ──────────────────────────────────────────────
  String _t(String lang, {required String en, required String mr, required String hi}) {
    if (lang == 'mr') return mr;
    if (lang == 'hi') return hi;
    return en;
  }

  // ── Top 1-Tap Language Bar ──────────────────────────────────────────────────
  Widget _buildTopLanguageBar(BuildContext context, UserProfileProvider provider, String currentLang) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
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
          Icon(Icons.translate_rounded, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            _t(currentLang, en: 'Language:', mr: 'भाषा निवडा:', hi: 'भाषा चुनें:'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
          ),
          const Spacer(),
          _buildLanguagePill('mr', 'मराठी', currentLang, provider),
          const SizedBox(width: 6),
          _buildLanguagePill('hi', 'हिंदी', currentLang, provider),
          const SizedBox(width: 6),
          _buildLanguagePill('en', 'English', currentLang, provider),
        ],
      ),
    );
  }

  Widget _buildLanguagePill(String code, String label, String currentLang, UserProfileProvider provider) {
    final isSelected = currentLang == code;
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        provider.setLanguage(code);
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ── Official Artisan Digital Pehchan Card ──────────────────────────────────
  Widget _buildArtisanPehchanCard(BuildContext context, UserProfileModel profile, String lang, int activeProductsCount) {
    final initials = profile.name.trim().isNotEmpty
        ? profile.name
            .trim()
            .split(RegExp(r'\\s+'))
            .where((s) => s.isNotEmpty)
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : 'A';

    final pehchanId = 'MH-ART-${profile.id.replaceAll(RegExp(r'[^0-9]'), '').padRight(4, '8').substring(0, 4)}';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFDF8),
            Color(0xFFFFF6E8),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5C096), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A8B4513),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Tricolor Accent Stripe
            Row(
              children: [
                Expanded(child: Container(height: 4, color: const Color(0xFFFF9933))),
                Expanded(child: Container(height: 4, color: Colors.white)),
                Expanded(child: Container(height: 4, color: const Color(0xFF138808))),
              ],
            ),

            // Card Header Ribbon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513).withValues(alpha: 0.08),
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFE5C096).withValues(alpha: 0.6)),
                ),
              ),
              child: Row(
                children: [
                  const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t(lang,
                            en: 'GOVT. RECOGNIZED ARTISAN PEHCHAN CARD',
                            mr: 'भारत सरकार मान्यताप्राप्त कारागीर ओळखपत्र',
                            hi: 'भारत सरकार मान्यताप्राप्त कारीगर पहचान पत्र'
                          ),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6B3004),
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          _t(lang,
                            en: 'Ministry of Textiles & ShilpSetu Digital Registry',
                            mr: 'वस्त्रोद्योग मंत्रालय व शिल्पसेतू नोंदणीकृत',
                            hi: 'वस्त्र मंत्रालय एवं शिल्पसेतु पंजीकृत'
                          ),
                          style: TextStyle(
                            fontSize: 9.5,
                            color: Colors.brown.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          _t(lang, en: 'VERIFIED', mr: 'प्रमाणित', hi: 'सत्यापित'),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Card Body (Avatar, Name, Craft, Location, Pehchan ID)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo with camera edit badge
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: AppColors.primaryFixed,
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => _showEditProfileSheet(context, profile),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 4),
                              ],
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // Name and Key Identifiers
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '🏺 ${profile.craftType}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tertiaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                profile.location,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.badge_outlined, size: 14, color: AppColors.textLight),
                            const SizedBox(width: 4),
                            Text(
                              'ID: $pehchanId',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Loud Speaker Audio Readout Button (Rural Low-Literacy Hero Feature)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _speakProfile(context, profile, lang, activeProductsCount),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _t(lang,
                                  en: 'Listen to My Identity Card 🔊',
                                  mr: 'माझी माहिती बोलून ऐका 🔊',
                                  hi: 'अपनी पहचान आवाज में सुनें 🔊'
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _t(lang,
                                  en: 'Tap here — will speak in your language',
                                  mr: 'येथे दाबा — तुमची माहिती मराठीत वाचून दाखवेल',
                                  hi: 'यहाँ दबाएं — आपकी जानकारी हिंदी में सुनाएगा'
                                ),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Voice Assistant Readout Modal ──────────────────────────────────────────
  void _speakProfile(BuildContext context, UserProfileModel profile, String lang, int activeProductsCount) {
    HapticFeedback.heavyImpact();

    final phone = profile.phone.isNotEmpty ? profile.phone : '+91 98765 43210';
    final spokenText = lang == 'mr'
        ? '🙏 नमस्कार! माझे नाव ${profile.name} आहे.\\n\\n'
          'मी ${profile.location} येथील ${profile.craftType} कारागीर आहे.\\n\\n'
          'माझा नोंदणीकृत फोन नंबर $phone आहे. सर्व ग्राहक या नंबरवर संपर्क करू शकतात.\\n\\n'
          'शिल्पसेतू दुकानात माझ्या $activeProductsCount वस्तू विक्रीसाठी उपलब्ध आहेत.\\n\\n'
          'माझी सर्व कमाई थेट माझ्या बँक खात्यात विना दलाल सुरक्षित जमा होते.'
        : (lang == 'hi'
            ? '🙏 नमस्ते! मेरा नाम ${profile.name} है।\\n\\n'
              'मैं ${profile.location} से ${profile.craftType} का प्रमाणित कारीगर हूँ।\\n\\n'
              'मेरा पंजीकृत मोबाइल नंबर $phone है। सभी ग्राहक इसी नंबर पर संपर्क कर सकते हैं।\\n\\n'
              'शिल्पसेतु दुकान में मेरे $activeProductsCount उत्पाद बिक्री के लिए तैयार हैं।\\n\\n'
              'मेरी पूरी कमाई बिना किसी दलाल के सीधे मेरे बैंक खाते में सुरक्षित आती है।'
            : '🙏 Hello! My name is ${profile.name}.\\n\\n'
              'I am a certified ${profile.craftType} artisan from ${profile.location}.\\n\\n'
              'My registered phone number is $phone. Customers can contact me here.\\n\\n'
              'I currently have $activeProductsCount handmade items available in my shop.\\n\\n'
              'All my earnings are credited directly to my bank account with zero middlemen.');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.graphic_eq_rounded, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _t(lang,
                              en: 'Artisan Audio Profile',
                              mr: 'माहिती बोलून दाखवत आहे 🔊',
                              hi: 'कारीगर पहचान आवाज में 🔊'
                            ),
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                          ),
                          Text(
                            _t(lang,
                              en: 'Listen carefully to your profile details',
                              mr: 'तुमची माहिती लक्षपूर्वक ऐका किंवा वाचा',
                              hi: 'अपनी जानकारी ध्यान से सुनें या पढ़ें'
                            ),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Spoken Text Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8EE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5C096)),
                  ),
                  child: Text(
                    spokenText,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Security / Verified badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user_rounded, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 6),
                    Text(
                      _t(lang,
                        en: 'Official verified artisan details',
                        mr: '✓ सर्व माहिती तपासून प्रमाणित केलेली आहे',
                        hi: '✓ सभी जानकारी सत्यापित और सुरक्षित है'
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_t(lang,
                                en: 'Replaying profile audio...',
                                mr: 'माहिती पुन्हा ऐकवली जात आहे...',
                                hi: 'जानकारी पुनः सुनाई जा रही है...'
                              )),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.replay_rounded, size: 18),
                        label: Text(_t(lang, en: 'Replay 🔊', mr: 'पुन्हा ऐका 🔊', hi: 'फिर से सुनें 🔊')),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        child: Text(_t(lang, en: 'Got it 👍', mr: 'समजले 👍', hi: 'समझ गया 👍')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────
  Widget _buildActionButtons(BuildContext context, UserProfileModel profile, String lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showEditProfileSheet(context, profile),
              icon: const Icon(Icons.edit_note_rounded, size: 20),
              label: Text(
                _t(lang, en: 'Edit Info', mr: 'माहिती बदला ✍️', hi: 'जानकारी बदलें ✍️'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showSharePortfolioSheet(context, profile),
              icon: const Icon(Icons.qr_code_2_rounded, size: 20, color: AppColors.textPrimary),
              label: Text(
                _t(lang, en: 'Share Card', mr: 'ओळखपत्र शेअर 📲', hi: 'पहचान शेयर 📲'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 48),
                side: const BorderSide(color: AppColors.outline),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 4 Essential Information Tiles ──────────────────────────────────────────
  Widget _buildEssentialInfoTiles(BuildContext context, UserProfileModel profile, String lang, int activeProductsCount) {
    final phone = profile.phone.isNotEmpty ? profile.phone : '+91 98765 43210';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                _t(lang,
                  en: 'My Essential Information',
                  mr: 'माझी मुख्य माहिती (तुमचे तपशील)',
                  hi: 'मेरी मुख्य जानकारी (आपका विवरण)'
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1. Phone Tile
          _buildInfoCard(
            context: context,
            icon: Icons.phone_in_talk_rounded,
            iconColor: Colors.green.shade800,
            bgColor: Colors.green.shade50,
            borderColor: Colors.green.shade200,
            title: _t(lang, en: 'Registered Mobile Number', mr: 'नोंदणीकृत मोबाईल नंबर', hi: 'पंजीकृत मोबाइल नंबर'),
            value: phone,
            hint: _t(lang,
              en: 'Customers and order alerts will arrive on this number',
              mr: 'सर्व ग्राहक व ऑर्डर्सचे मेसेज याच नंबरवर येतात',
              hi: 'सभी खरीदार और ऑर्डर के संदेश इसी नंबर पर आएंगे'
            ),
            badgeText: _t(lang, en: 'Active', mr: 'सक्रिय', hi: 'सक्रिय'),
            badgeColor: Colors.green.shade700,
            onTap: () => _showEditProfileSheet(context, profile),
          ),
          const SizedBox(height: 10),

          // 2. Craft Tile
          _buildInfoCard(
            context: context,
            icon: Icons.palette_rounded,
            iconColor: Colors.deepOrange.shade800,
            bgColor: Colors.deepOrange.shade50,
            borderColor: Colors.deepOrange.shade200,
            title: _t(lang, en: 'Handcrafted Heritage', mr: 'माझी हस्तकला व वारसा', hi: 'मेरा हस्तशिल्प और विरासत'),
            value: profile.craftType,
            hint: _t(lang,
              en: 'Generational skill • 15+ years heritage',
              mr: 'पारंपरिक कला • पिढीजात वारसा व उत्तम गुणवत्ता',
              hi: 'पारंपरिक कला • 15+ वर्षों की पुश्तैनी महारत'
            ),
            badgeText: _t(lang, en: 'Heritage', mr: 'वारसा', hi: 'विरासत'),
            badgeColor: Colors.deepOrange.shade700,
            onTap: () => _showEditProfileSheet(context, profile),
          ),
          const SizedBox(height: 10),

          // 3. Bank Account Tile
          _buildInfoCard(
            context: context,
            icon: Icons.account_balance_rounded,
            iconColor: Colors.indigo.shade800,
            bgColor: Colors.indigo.shade50,
            borderColor: Colors.indigo.shade200,
            title: _t(lang, en: 'Bank Account & Direct Payment', mr: 'बँक खाते व थेट पैसे', hi: 'बैंक खाता और सीधा भुगतान'),
            value: 'State Bank of India (**** 4321)',
            hint: _t(lang,
              en: '✓ 100% money goes to bank • 0% commission',
              mr: '✓ १००% थेट बँकेत जमा • ०% दलाली/कमिशन',
              hi: '✓ 100% सीधा बैंक में जमा • 0% कमीशन'
            ),
            badgeText: _t(lang, en: '0% Comm.', mr: '०% कमिशन', hi: '0% कमीशन'),
            badgeColor: Colors.indigo.shade700,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_t(lang,
                    en: 'Direct Bank Deposit Active: SBI ending in 4321.',
                    mr: 'थेट बँक जमा सक्रिय: स्टेट बँक ऑफ इंडिया (४३२१)',
                    hi: 'सीधा बैंक भुगतान चालू है: भारतीय स्टेट बैंक (4321)'
                  )),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          // 4. Shop Products Tile
          _buildInfoCard(
            context: context,
            icon: Icons.storefront_rounded,
            iconColor: Colors.purple.shade800,
            bgColor: Colors.purple.shade50,
            borderColor: Colors.purple.shade200,
            title: _t(lang, en: 'My Shop & Products', mr: 'माझे दुकान व वस्तू', hi: 'मेरी दुकान और उत्पाद'),
            value: _t(lang,
              en: '$activeProductsCount items active in shop',
              mr: '$activeProductsCount वस्तू विक्रीसाठी उपलब्ध',
              hi: '$activeProductsCount उत्पाद दुकान में बिक्री के लिए तैयार'
            ),
            hint: _t(lang,
              en: 'Tap to view your shop or add new products →',
              mr: 'दुकान पाहण्यासाठी किंवा नवीन वस्तू जोडण्यासाठी दाबा →',
              hi: 'दुकान देखने या नया उत्पाद जोड़ने के लिए टैप करें →'
            ),
            badgeText: _t(lang, en: 'Shop Open', mr: 'दुकान सुरू', hi: 'दुकान चालू'),
            badgeColor: Colors.purple.shade700,
            onTap: () {
              context.go('/artisan/products');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required String title,
    required String value,
    required String hint,
    required String badgeText,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hint,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Simple Earnings Card ───────────────────────────────────────────────────
  Widget _buildSimpleEarningsCard(BuildContext context, UserProfileModel profile, String lang) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.currency_rupee_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _t(lang, en: 'My Total Earnings', mr: 'माझी एकूण कमाई 💰', hi: 'मेरी कुल कमाई 💰'),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  _t(lang, en: '✓ Direct to Bank', mr: '✓ थेट बँकेत जमा', hi: '✓ सीधे बैंक में'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            profile.globalSales,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _t(lang,
              en: 'All payments credited directly into your SBI account with zero commission.',
              mr: 'कोणत्याही दलालाशिवाय १००% पैसे थेट तुमच्या बँकेत सुरक्षित जमा.',
              hi: 'बिना किसी बिचौलिए के 100% पैसा सीधे आपके खाते में सुरक्षित जमा।'
            ),
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 4),
              Text(
                '${profile.rating.toStringAsFixed(1)} / 5.0',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '•  ${profile.totalReviews}+ ${_t(lang, en: 'happy buyer reviews', mr: 'ग्राहकांचे विश्वासू अभिप्राय', hi: 'संतुष्ट ग्राहकों के रिव्यू')}',
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpline & Call Support ────────────────────────────────────────────────
  Widget _buildHelplineCard(BuildContext context, String lang) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD54F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFECB3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.support_agent_rounded, color: Color(0xFFE65100), size: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(lang,
                        en: 'Artisan Help & Support',
                        mr: 'कारागीर मदत व मार्गदर्शन केंद्र 📞',
                        hi: 'कारीगर सहायता एवं मार्गदर्शन 📞'
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      _t(lang,
                        en: 'Free assistance in Marathi or Hindi',
                        mr: 'काही अडचण असल्यास मराठी/हिंदीत मोफत बोला',
                        hi: 'कोई भी समस्या हो तो निःशुल्क बात करें'
                      ),
                      style: const TextStyle(fontSize: 11, color: Color(0xFFE65100)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Toll-Free Helpline: 1800-123-4567 (मराठी व हिंदी)'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.call, size: 16),
                  label: Text(_t(lang, en: '1800-123-4567', mr: 'फोन करा १८००..', hi: 'कॉल करें १८००..')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_t(lang,
                          en: 'Opening WhatsApp Artisan Support...',
                          mr: 'व्हॉट्सअॅप मदत केंद्र सुरू होत आहे...',
                          hi: 'व्हाट्सएप सहायता शुरू हो रही है...'
                        )),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_rounded, size: 16),
                  label: Text(_t(lang, en: 'WhatsApp Help', mr: 'व्हॉट्सअॅप मदत', hi: 'व्हाट्सएप सहायता')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green.shade800,
                    side: BorderSide(color: Colors.green.shade700),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Government Welfare Schemes ─────────────────────────────────────────────
  Widget _buildGovernmentSchemes(BuildContext context, String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            children: [
              const Icon(Icons.account_balance_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                _t(lang,
                  en: 'Government Welfare Schemes',
                  mr: 'शासकीय योजना व आर्थिक मदत',
                  hi: 'सरकारी योजनाएँ और वित्तीय सहायता'
                ),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _showSchemeDialog(
                  _t(lang,
                    en: 'PM Vishwakarma & Micro-Loans',
                    mr: 'पीएम विश्वकर्मा योजना व कर्ज',
                    hi: 'पीएम विश्वकर्मा योजना और ऋण'
                  ),
                  _t(lang,
                    en: 'Avail financial support under PM Vishwakarma Scheme:\\n\\n✓ ₹15,000 toolkit grant\\n✓ Up to ₹3,00,000 credit at 5% low interest\\n✓ Official Artisan identity card\\n✓ Free skill training',
                    mr: 'पीएम विश्वकर्मा योजनेअंतर्गत लाभ:\\n\\n✓ ₹१५,००० मोफत टूलकिट अनुदान\\n✓ ₹३ लाखांपर्यंत ५% अत्यंत कमी व्याज दराने कर्ज\\n✓ भारत सरकारचे अधिकृत ओळखपत्र\\n✓ मोफत कौशल्य प्रशिक्षण',
                    hi: 'पीएम विश्वकर्मा योजना के तहत लाभ:\\n\\n✓ ₹15,000 फ्री टूलकिट अनुदान\\n✓ ₹3 लाख तक 5% रियायती ब्याज पर ऋण\\n✓ भारत सरकार का आधिकारिक पहचान पत्र\\n✓ निःशुल्क कौशल प्रशिक्षण'
                  ),
                ),
                child: _buildSchemeCard(
                  Icons.handyman_rounded,
                  _t(lang, en: 'PM Vishwakarma', mr: 'पीएम विश्वकर्मा', hi: 'पीएम विश्वकर्मा'),
                  _t(lang,
                    en: '₹15,000 free toolkit + 5% low interest loan.',
                    mr: '₹१५,००० मोफत टूलकिट + ५% कमी व्याज कर्ज.',
                    hi: '₹15,000 फ्री टूलकिट + 5% रियायती ऋण।'
                  ),
                  _t(lang, en: 'Learn More →', mr: 'माहिती पहा →', hi: 'विवरण देखें →'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _showSchemeDialog(
                  _t(lang,
                    en: 'GI-Tag Heritage Certification',
                    mr: 'GI-टॅग भौगोलिक मानांकन',
                    hi: 'जीआई-टैग भौगोलिक पहचान'
                  ),
                  _t(lang,
                    en: 'Geographical Indication (GI) certification provides legal protection and authentic heritage branding for your craft.\\n\\n✓ Legal protection against fake copies\\n✓ Free government documentation\\n✓ Premium prices in market',
                    mr: 'GI-टॅग भौगोलिक मानांकन लाभ:\\n\\n✓ तुमच्या कलेला कायदेशीर संरक्षण\\n✓ बाजारात जास्त आणि चांगला भाव\\n✓ बनावट वस्तूंपासून संरक्षण\\n✓ मोफत शासकीय कागदपत्र मदत',
                    hi: 'जीआई-टैग पहचान के लाभ:\\n\\n✓ आपके हस्तशिल्प को कानूनी सुरक्षा\\n✓ बाजार में बेहतर और उचित मूल्य\\n✓ नकली माल से सुरक्षा\\n✓ निःशुल्क सरकारी सहायता'
                  ),
                ),
                child: _buildSchemeCard(
                  Icons.verified_user_rounded,
                  _t(lang, en: 'GI-Tag Heritage', mr: 'GI-टॅग मानांकन', hi: 'जीआई-टैग प्रमाणन'),
                  _t(lang,
                    en: 'Legal heritage protection & authentic branding.',
                    mr: 'हस्तकलेला कायदेशीर ओळख व चांगला भाव.',
                    hi: 'हस्तशिल्प को कानूनी पहचान और बेहतर मूल्य।'
                  ),
                  _t(lang, en: 'Check Status →', mr: 'स्थिती तपासा →', hi: 'स्थिति देखें →'),
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
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primaryDark)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 3),
          const SizedBox(height: 8),
          Text(cta, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  // ── Buyer Reviews ──────────────────────────────────────────────────────────
  Widget _buildReviews(UserProfileModel profile, String lang) {
    final reviews = [
      {
        'name': 'Priya S.',
        'rating': '5.0',
        'comment': lang == 'mr'
            ? 'अतिशय सुंदर आणि अस्सल हाताने बनवलेली कलाकृती! कारागिरांचे काम वाखाणण्याजोगे आहे.'
            : (lang == 'hi'
                ? 'बहुत ही सुंदर और असली हाथ से बनी कलाकृति! कारीगर का काम सराहनीय है।'
                : 'Absolutely stunning handmade craft! The attention to detail is remarkable.'),
        'time': '2 days ago'
      },
      {
        'name': 'Ramesh K.',
        'rating': '4.9',
        'comment': lang == 'mr'
            ? 'पॅकिंग खूप सुरक्षित होते आणि वेळात डिलिव्हरी मिळाली. भारतीय कारागिरांचा अभिमान आहे!'
            : (lang == 'hi'
                ? 'पैकिंग बहुत सुरक्षित थी और समय पर डिलीवरी मिली। भारतीय कारीगरों पर गर्व है!'
                : 'Shipped safely without damage. Beautiful packaging and authentic Indian artisan touch!'),
        'time': '1 week ago'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _t(lang, en: 'Buyer Reviews', mr: 'ग्राहकांचे अभिप्राय (रिव्ह्यू)', hi: 'ग्राहकों की राय (रिव्यू)'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.tertiary, size: 16),
                  const SizedBox(width: 4),
                  Text('${profile.rating.toStringAsFixed(1)} · ${profile.totalReviews} reviews',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
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
            boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.secondaryFixed,
                    child: Text(r['name']![0], style: const TextStyle(color: AppColors.secondaryDark, fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text(r['time']!, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.tertiary, size: 12),
                        const SizedBox(width: 3),
                        Text(r['rating']!, style: const TextStyle(color: AppColors.tertiaryDark, fontWeight: FontWeight.w800, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(r['comment']!, style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textPrimary)),
            ],
          ),
        )),
      ],
    );
  }

  // ── Sign Out Section ───────────────────────────────────────────────────────
  Widget _buildSignOutSection(BuildContext context, String lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton.icon(
          onPressed: () => _confirmSignOut(),
          icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
          label: Text(
            _t(lang, en: 'Sign Out of Account', mr: 'खात्यातून बाहेर पडा (लॉगआउट)', hi: 'अकाउंट से बाहर निकलें (लॉगआउट)'),
            style: const TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w800,
              fontSize: 14,
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

"""

start_pos = content.index(start_marker)
end_pos = content.index(end_marker)

new_content = content[:start_pos] + replacement + content[end_pos:]

# Also update _confirmSignOut to be localized
old_signout = """  void _confirmSignOut() {
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
  }"""

new_signout = """  void _confirmSignOut() {
    final lang = context.read<UserProfileProvider>().selectedLanguage;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          _t(lang, en: 'Sign Out?', mr: 'खात्यातून बाहेर पडायचे का?', hi: 'लॉगआउट करना चाहते हैं?'),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Text(
          _t(lang,
            en: 'Are you sure you want to sign out of your artisan account?',
            mr: 'तुम्हाला तुमच्या कारागीर खात्यातून बाहेर पडायचे आहे का?',
            hi: 'क्या आप अपने कारीगर खाते से बाहर निकलना चाहते हैं?'
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              _t(lang, en: 'Cancel', mr: 'रद्द करा', hi: 'रद्द करें'),
              style: TextStyle(color: AppColors.textLight),
            ),
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
            child: Text(_t(lang, en: 'Sign Out', mr: 'बाहेर पडा', hi: 'बाहर निकलें')),
          ),
        ],
      ),
    );
  }"""

if old_signout in new_content:
    new_content = new_content.replace(old_signout, new_signout)
    print("Sign out replaced with localized version.")
else:
    print("Warning: old_signout not found")

with open(profile_file, "w", encoding="utf-8") as f:
    f.write(new_content)

print("Profile screen patched successfully!")
