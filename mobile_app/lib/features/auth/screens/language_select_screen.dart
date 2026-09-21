import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shilpsetu_ai/core/theme/app_theme.dart';
import 'package:shilpsetu_ai/core/providers/user_profile_provider.dart';
import 'package:shilpsetu_ai/services/local_storage_service.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  // Default is Hindi ('hi') as specified in the project requirements
  String _selectedLang = 'hi';

  final List<Map<String, String>> _languages = [
    {
      'code': 'hi',
      'label': 'हिंदी',
      'sublabel': 'Hindi (Default)',
      'flag': '🇮🇳',
      'sample': 'नमस्ते! शिल्पसेतु में आपका स्वागत है',
    },
    {
      'code': 'mr',
      'label': 'मराठी',
      'sublabel': 'Marathi',
      'flag': '🇮🇳',
      'sample': 'नमस्कार! शिल्पसेतू मध्ये आपले स्वागत आहे',
    },
    {
      'code': 'en',
      'label': 'English',
      'sublabel': 'English',
      'flag': '🌐',
      'sample': 'Welcome to ShilpSetu AI Platform',
    },
  ];

  @override
  void initState() {
    super.initState();
    final current = Provider.of<UserProfileProvider>(context, listen: false).selectedLanguage;
    if (current.isNotEmpty) {
      _selectedLang = current;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // App Logo & Cultural Header
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primary,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'भाषा निवडा / भाषा चुनें\nSelect Language',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                  color: AppColors.textPrimary,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your preferred language for the whole application\nसंपूर्ण ॲपसाठी तुमची पसंतीची भाषा निवडा',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Tri-lingual Selection List
              ..._languages.map((lang) => Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: _LanguageTile(
                  flag: lang['flag']!,
                  label: lang['label']!,
                  sublabel: lang['sublabel']!,
                  sample: lang['sample']!,
                  isSelected: _selectedLang == lang['code'],
                  onTap: () {
                    setState(() => _selectedLang = lang['code']!);
                  },
                ),
              )),

              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final provider = context.read<UserProfileProvider>();
                  await LocalStorageService().setLanguage(_selectedLang);
                  await provider.setLanguage(_selectedLang);
                  if (!context.mounted) return;
                  context.go('/profile_setup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: Text(
                  _selectedLang == 'mr'
                      ? 'पुढे जा →'
                      : (_selectedLang == 'hi' ? 'आगे बढ़ें →' : 'Continue →'),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String flag;
  final String label;
  final String sublabel;
  final String sample;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.flag,
    required this.label,
    required this.sublabel,
    required this.sample,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainerLowest : AppColors.surfaceContainerLowest.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  const BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryFixed : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(flag, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '($sublabel)',
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.textLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    sample,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24)
            else
              const Icon(Icons.radio_button_unchecked, color: AppColors.outline, size: 22),
          ],
        ),
      ),
    );
  }
}
