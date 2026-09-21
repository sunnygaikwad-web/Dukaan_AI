import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shilpsetu_ai/core/theme/app_theme.dart';

import 'package:shilpsetu_ai/core/constants/app_localizations.dart';
import 'package:shilpsetu_ai/models/product_model.dart';
import 'package:shilpsetu_ai/features/products/screens/multilingual_catalog_screen.dart';
import 'package:shilpsetu_ai/features/products/screens/heritage_story_screen.dart';
import 'package:shilpsetu_ai/features/products/screens/smart_pricing_screen.dart';

// Auth Screens
import 'package:shilpsetu_ai/features/auth/screens/splash_screen.dart';
import 'package:shilpsetu_ai/features/auth/screens/login_screen.dart';
import 'package:shilpsetu_ai/features/auth/screens/register_screen.dart';
import 'package:shilpsetu_ai/features/auth/screens/welcome_screen.dart';
import 'package:shilpsetu_ai/features/auth/screens/language_select_screen.dart';
import 'package:shilpsetu_ai/features/auth/screens/profile_setup_screen.dart';

// Artisan Screens
import 'package:shilpsetu_ai/features/artisan/screens/home_screen.dart';
import 'package:shilpsetu_ai/features/artisan/screens/profile_screen.dart';
import 'package:shilpsetu_ai/features/artisan/screens/buyer_requests_screen.dart';

// Product Screens
import 'package:shilpsetu_ai/features/products/screens/add_product_screen.dart';
import 'package:shilpsetu_ai/features/products/screens/ai_studio_screen.dart';
import 'package:shilpsetu_ai/features/products/screens/voice_cataloger_screen.dart';
import 'package:shilpsetu_ai/features/products/screens/catalog_preview_screen.dart';
import 'package:shilpsetu_ai/features/products/screens/publish_success_screen.dart';
import 'package:shilpsetu_ai/features/products/screens/my_products_screen.dart';

// Buyer Screens
import 'package:shilpsetu_ai/features/buyers/screens/buyer_portal_screen.dart';
import 'package:shilpsetu_ai/features/buyers/screens/buyer_matching_screen.dart';

// Digital Mela
import 'package:shilpsetu_ai/features/digital_mela/screens/digital_mela_screen.dart';

// Admin Screen
import 'package:shilpsetu_ai/features/admin/screens/admin_dashboard_screen.dart';

// Providers
import 'package:shilpsetu_ai/core/providers/user_profile_provider.dart';
import 'package:shilpsetu_ai/core/providers/product_provider.dart';
import 'package:shilpsetu_ai/core/providers/buyer_request_provider.dart';
import 'package:shilpsetu_ai/core/providers/shortlist_provider.dart';

class NavigationProvider extends ChangeNotifier {
  int currentIndex = 0;
  void setIndex(int idx) {
    if (currentIndex != idx) {
      currentIndex = idx;
      notifyListeners();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Skip Firebase on web (requires explicit options we don't have yet)
  // On Android, try to init from google-services.json; fall back to demo mode
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase not configured – running in demo mode: $e');
    }
  } else {
    debugPrint('Running on web – demo mode (Firebase skipped)');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => BuyerRequestProvider()),
        ChangeNotifierProvider(create: (_) => ShortlistProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const ShilpSetuApp(),
    ),
  );
}

class ShilpSetuApp extends StatelessWidget {
  const ShilpSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ShilpSetu AI',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // --- Onboarding & Auth ---
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/language_select',
      builder: (context, state) => const LanguageSelectScreen(),
    ),
    GoRoute(
      path: '/profile_setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),

    // --- Main App Shell ---
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainNavigation(),
    ),

    // --- Product Flow ---
    GoRoute(
      path: '/add_product',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/ai_studio',
      builder: (context, state) {
        final imageFile = state.extra as File;
        return AiStudioScreen(imageFile: imageFile);
      },
    ),
    GoRoute(
      path: '/voice_cataloger',
      builder: (context, state) {
        final imageFile = state.extra is File ? state.extra as File : File('');
        return VoiceCatalogerScreen(imageFile: imageFile);
      },
    ),
    GoRoute(
      path: '/catalog_preview',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return CatalogPreviewScreen(
          imageFile: data['image'] as File,
          transcript: data['transcript'] as String,
        );
      },
    ),
    GoRoute(
      path: '/multilingual_catalog',
      builder: (context, state) {
        final product = state.extra as ProductModel?;
        return MultilingualCatalogScreen(product: product);
      },
    ),
    GoRoute(
      path: '/heritage_story',
      builder: (context, state) {
        final product = state.extra as ProductModel?;
        return HeritageStoryScreen(product: product);
      },
    ),
    GoRoute(
      path: '/smart_pricing',
      builder: (context, state) {
        final product = state.extra as ProductModel?;
        return SmartPricingScreen(product: product);
      },
    ),
    GoRoute(
      path: '/publish_success',
      builder: (context, state) => const PublishSuccessScreen(),
    ),

    // --- Artisan Specific Routes ---
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/my_products',
      builder: (context, state) => const MyProductsScreen(),
    ),
    GoRoute(
      path: '/buyer_matching',
      builder: (context, state) => const BuyerMatchingScreen(),
    ),
    GoRoute(
      path: '/buyer_requests',
      builder: (context, state) => const BuyerRequestsScreen(),
    ),

    // --- Buyer Portal & Digital Mela ---
    GoRoute(
      path: '/buyer_portal',
      builder: (context, state) => const BuyerPortalScreen(),
    ),
    GoRoute(
      path: '/digital_mela',
      builder: (context, state) => const DigitalMelaScreen(),
    ),

    // --- Admin Dashboard ---
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),

    // --- Redirect root to splash ---
    GoRoute(
      path: '/',
      redirect: (_, _) => '/splash',
    ),
  ],
);

// ─── Main App Shell with Adaptive Role-Aware Navigation ──────────────────────

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  static const List<Widget> _artisanScreens = [
    HomeScreen(),
    MyProductsScreen(),
    DigitalMelaScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfileProvider>();
    final role = userProfile.currentRole;

    // Direct role rendering if in Buyer or Admin persona
    if (role == 'buyer') {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          userProfile.switchRole('artisan');
        },
        child: const BuyerPortalScreen(),
      );
    } else if (role == 'admin') {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          userProfile.switchRole('artisan');
        },
        child: const AdminDashboardScreen(),
      );
    }

    // Default Artisan Navigation
    final nav = context.watch<NavigationProvider>();
    final currentIndex = nav.currentIndex.clamp(0, 3);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (currentIndex != 0) {
          context.read<NavigationProvider>().setIndex(0);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: _artisanScreens,
        ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                _buildNavItem(context, 0, Icons.home_outlined, Icons.home_rounded, AppLocalizations.tr('nav_home', userProfile.selectedLanguage), currentIndex),
                _buildNavItem(context, 1, Icons.inventory_2_outlined, Icons.inventory_2_rounded, AppLocalizations.tr('nav_products', userProfile.selectedLanguage), currentIndex),
                
                // AI Assist Center Button
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push('/add_product'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          AppLocalizations.tr('nav_ai_assist', userProfile.selectedLanguage),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                _buildNavItem(context, 2, Icons.festival_outlined, Icons.festival_rounded, AppLocalizations.tr('nav_mela', userProfile.selectedLanguage), currentIndex),
                _buildNavItem(context, 3, Icons.person_outline_rounded, Icons.person_rounded, AppLocalizations.tr('nav_profile', userProfile.selectedLanguage), currentIndex),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildNavItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label, int currentIndex) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.read<NavigationProvider>().setIndex(index),
        child: SizedBox(
          height: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? AppColors.primary : AppColors.textLight,
                size: 26,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textLight,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
