import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  // API - Automatically adapts to Android Emulator vs Web/Desktop
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    } catch (_) {}
    return 'http://localhost:8000';
  }

  // Demo Mode
  static const bool demoMode = true;

  // Languages
  static const Map<String, String> languages = {
    'en': 'English',
    'mr': 'मराठी',
    'hi': 'हिंदी',
  };

  // Craft types
  static const List<String> craftTypes = [
    'Paithani',
    'Blue Pottery',
    'Madhubani',
    'Kantha',
    'Dhokra',
    'Channapatna',
    'Warli',
    'Phulkari',
    'Kashmiri Embroidery',
    'Bidriware',
    'Other',
  ];

  // States
  static const List<String> states = [
    'Maharashtra',
    'Rajasthan',
    'Uttar Pradesh',
    'Bihar',
    'West Bengal',
    'Gujarat',
    'Madhya Pradesh',
    'Odisha',
    'Telangana',
    'Karnataka',
    'Tamil Nadu',
    'Other',
  ];
}

class AppStrings {
  // General
  static const String appName = 'ShilpSetu AI';
  static const String tagline = 'From Artisan Hands to Digital Markets.';

  // Onboarding
  static const String welcomeTitle = 'Welcome to ShilpSetu';
  static const String welcomeSubtitle = 'Turn your craftsmanship into digital opportunities.';
  static const String getStarted = 'Get Started';
  static const String selectLanguage = 'Select Your Language';

  // Home
  static const String homeGreeting = 'Namaste';
  static const String todaysOpportunities = "Today's Opportunities";
  static const String addProduct = '+ Add Product';
  static const String myProducts = 'My Products';
  static const String findBuyers = 'Find Buyers';
  static const String myEarnings = 'My Earnings';
  static const String digitalMela = 'Digital Mela';

  // Product
  static const String captureProduct = 'Capture Product';
  static const String takePhoto = 'Take Photo';
  static const String chooseFromGallery = 'Choose From Gallery';
  static const String useThisPhoto = 'Use This Photo';
  static const String retake = 'Retake';

  // AI Studio
  static const String aiStudioTitle = 'Making your product ready for the market...';

  // Voice
  static const String voiceTitle = 'Tell us about your product';
  static const String voiceSubtitle = 'You can speak in your own language.';

  // Catalog
  static const String catalogTitle = 'AI Catalog Preview';
  static const String publishProduct = 'Publish Product';
  static const String saveAsDraft = 'Save as Draft';

  // Success
  static const String publishSuccessTitle = 'Your craft is now digitally visible! 🎉';

  // Errors
  static const String aiUnavailable = 'AI service temporarily unavailable. You can continue manually.';
  static const String imageProcessingFailed = "We couldn't enhance the image. Your original image is safe.";
  static const String speechFailed = "We couldn't understand the recording. Please try again.";
}
