// lib/services/local_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _keyLanguage = 'selected_language';
  static const String _keyOnboardingDone = 'onboarding_done';
  static const String _keyArtisanId = 'artisan_id';
  static const String _keyArtisanName = 'artisan_name';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<String> getLanguage() async {
    final prefs = await _prefs;
    return prefs.getString(_keyLanguage) ?? 'en';
  }

  Future<void> setLanguage(String lang) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLanguage, lang);
  }

  Future<bool> isOnboardingDone() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  Future<void> setOnboardingDone(bool done) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyOnboardingDone, done);
  }

  Future<String?> getArtisanId() async {
    final prefs = await _prefs;
    return prefs.getString(_keyArtisanId);
  }

  Future<void> setArtisanId(String id) async {
    final prefs = await _prefs;
    await prefs.setString(_keyArtisanId, id);
  }

  Future<String?> getArtisanName() async {
    final prefs = await _prefs;
    return prefs.getString(_keyArtisanName);
  }

  Future<void> setArtisanName(String name) async {
    final prefs = await _prefs;
    await prefs.setString(_keyArtisanName, name);
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}
