// lib/features/products/screens/heritage_story_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_localizations.dart';
import '../../../core/constants/app_craft_images.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../models/product_model.dart';

class HeritageStoryScreen extends StatefulWidget {
  final ProductModel? product;

  const HeritageStoryScreen({super.key, this.product});

  @override
  State<HeritageStoryScreen> createState() => _HeritageStoryScreenState();
}

class _HeritageStoryScreenState extends State<HeritageStoryScreen> {
  bool _isPlaying = false;
  int _playbackSec = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleAudio() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _timer = Timer.periodic(const Duration(seconds: 1), (t) {
          if (mounted) {
            setState(() {
              _playbackSec = (_playbackSec >= 120) ? 0 : _playbackSec + 1;
            });
          }
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s < 10 ? '0' : ''}$s';
  }

  @override
  Widget build(BuildContext context) {
    final appLang = context.watch<UserProfileProvider>().selectedLanguage;
    final p = widget.product ?? ProductModel.demoProducts.first;

    final catalogContent = p.catalog[appLang] ?? p.catalog['hi'] ?? p.catalog['en'];
    final String storyText = catalogContent?.heritageStory.isNotEmpty == true
        ? catalogContent!.heritageStory
        : _getDefaultHeritageStory(appLang);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.tr('heritage_story_title', appLang),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Master Artisan Banner with Legacy ──────────────────
              Container(
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 14, offset: Offset(0, 4)),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        AppCraftImages.savitaWheel,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primaryLight),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.35),
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 18,
                      left: 18,
                      right: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified, size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.tr('cultural_heritage_verified', appLang),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            catalogContent?.title ?? p.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${p.metadata.origin} • 4th Generation Artisan Lineage',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Audio Story Player Widget ──────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.outline),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleAudio,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _isPlaying ? AppColors.secondary : AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.tr('audio_story_title', appLang),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${AppLocalizations.tr('audio_story_subtitle', appLang)} • ${_isPlaying ? _formatTime(_playbackSec) : '2:00 mins'}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'HD Audio',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Waveform Simulation
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.lavenderLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(24, (idx) {
                          final baseH = 8.0 + (idx * 7) % 24;
                          final dynamicH = _isPlaying ? (baseH + (_playbackSec * (idx % 3 + 2)) % 22) : (baseH * 0.5);
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 3.5,
                            height: dynamicH.clamp(6.0, 34.0),
                            decoration: BoxDecoration(
                              color: _isPlaying ? AppColors.secondary : AppColors.secondary.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── The Artisan's Journey Story ────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.tr('artisans_journey_title', appLang),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      storyText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                            fontSize: 15.5,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ── Artisan Quote Card ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.sandLight,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.sandDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote_rounded, size: 36, color: AppColors.primary),
                    Text(
                      _getArtisanQuote(appLang),
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '— Savita Ben, Master Craftsperson (4th Gen)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Continue to Smart Pricing Button ───────────────────
              ElevatedButton(
                onPressed: () {
                  context.push('/smart_pricing', extra: p);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payments_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.tr('continue_pricing', appLang),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _getDefaultHeritageStory(String lang) {
    if (lang == 'hi') {
      return 'चार पीढ़ियों से हमारा परिवार इस पारंपरिक कला को सहेज रहा है। हमारी कार्यशाला में उपयोग की जाने वाली हर सामग्री प्राकृतिक और पर्यावरण-अनुकूल है। हाथों से तैयार किया गया प्रत्येक टुकड़ा हमारी संस्कृति, धैर्य और विरासत की अमूल्य कहानी कहता है।';
    }
    if (lang == 'mr') {
      return 'गेल्या चार पिढ्यांपासून आमचे कुटुंब ही पारंपरिक हस्तकला जोपासत आहे. आमच्या कलेमध्ये वापरले जाणारे साहित्य पूर्णपणे अस्सल व नैसर्गिक आहे. हाताने घडवलेली प्रत्येक कलाकृती ही आमच्या मातीशी, संस्कृतीशी आणि पूर्वापार कौशल्याशी घट्ट जोडलेली आहे.';
    }
    return 'For over four generations, our artisan family has preserved this indigenous handicraft technique. Every product is patiently shaped by hand with natural sustainable materials, embodying authentic cultural heritage and centuries of master craftsmanship.';
  }

  String _getArtisanQuote(String lang) {
    if (lang == 'hi') {
      return '"जब मेरे हाथ गीली मिट्टी और करघे को छूते हैं, तो मुझे अपने पूर्वजों की आवाज सुनाई देती है। यह केवल एक उत्पाद नहीं, हमारी आत्मा का अंश है।"';
    }
    if (lang == 'mr') {
      return '"जेव्हा माझे हात मातीला आणि हातमागाला स्पर्श करतात, तेव्हा मला माझ्या पूर्वजांचे आशीर्वाद जाणवतात. ही केवळ वस्तू नसून आमचा जीव आणि संस्कृती आहे."';
    }
    return '"When my hands touch the wet clay and handloom, I hear the whispers of my ancestors guiding every contour. This soil carries our history, our pride, and our soul."';
  }
}
