// lib/core/providers/user_profile_provider.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role; // 'artisan', 'buyer', 'admin'
  final String craftType;
  final String location;
  final String state;
  final String bio;
  final String masteryLevel;
  final String memberSince;
  final String? avatarUrl;
  final bool isVerified;
  final double rating;
  final int totalReviews;
  final String globalSales;
  final String businessName;
  final String businessType;

  UserProfileModel({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
    this.role = 'artisan',
    this.craftType = 'Traditional Crafts',
    this.location = 'Maharashtra',
    this.state = 'Maharashtra',
    this.bio = 'Passionate artisan committed to preserving indigenous handcraft traditions.',
    this.masteryLevel = 'Master Craftsman (Tier V)',
    this.memberSince = '2026',
    this.avatarUrl,
    this.isVerified = true,
    this.rating = 4.9,
    this.totalReviews = 1420,
    this.globalSales = '₹24,85,400',
    this.businessName = '',
    this.businessType = '',
  });

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? craftType,
    String? location,
    String? state,
    String? bio,
    String? masteryLevel,
    String? memberSince,
    String? avatarUrl,
    bool? isVerified,
    double? rating,
    int? totalReviews,
    String? globalSales,
    String? businessName,
    String? businessType,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      craftType: craftType ?? this.craftType,
      location: location ?? this.location,
      state: state ?? this.state,
      bio: bio ?? this.bio,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      memberSince: memberSince ?? this.memberSince,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      globalSales: globalSales ?? this.globalSales,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'craft_type': craftType,
      'location': location,
      'state': state,
      'bio': bio,
      'mastery_level': masteryLevel,
      'member_since': memberSince,
      'avatar_url': avatarUrl,
      'is_verified': isVerified,
      'rating': rating,
      'total_reviews': totalReviews,
      'global_sales': globalSales,
      'business_name': businessName,
      'business_type': businessType,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map, [String? fallbackId]) {
    return UserProfileModel(
      id: map['id'] ?? fallbackId ?? 'user_default',
      name: (map['name'] as String?)?.isNotEmpty == true ? map['name'] : 'Artisan',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'artisan',
      craftType: (map['craft_type'] as String?)?.isNotEmpty == true ? map['craft_type'] : 'Traditional Crafts',
      location: (map['location'] as String?)?.isNotEmpty == true ? map['location'] : 'Maharashtra',
      state: (map['state'] as String?)?.isNotEmpty == true ? map['state'] : 'Maharashtra',
      bio: map['bio'] ?? 'Passionate artisan committed to preserving indigenous handcraft traditions.',
      masteryLevel: map['mastery_level'] ?? 'Master Craftsman (Tier V)',
      memberSince: map['member_since'] ?? '2026',
      avatarUrl: map['avatar_url'],
      isVerified: map['is_verified'] ?? true,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.9,
      totalReviews: (map['total_reviews'] as num?)?.toInt() ?? 1420,
      globalSales: map['global_sales'] ?? '₹24,85,400',
      businessName: map['business_name'] ?? '',
      businessType: map['business_type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory UserProfileModel.fromJson(String source) => UserProfileModel.fromMap(json.decode(source));
}

class UserProfileProvider extends ChangeNotifier {
  static const String _prefKey = 'saved_user_profile';

  UserProfileModel _profile = UserProfileModel(
    id: 'user_default',
    name: 'Om Gaikwad',
    craftType: 'Traditional Crafts',
    location: 'Kolhapur, Maharashtra',
    state: 'Maharashtra',
    role: 'artisan',
  );

  static const String _langPrefKey = 'app_selected_language';

  bool _isLoading = true;
  String _selectedLanguage = 'hi'; // Default language is Hindi: 'hi', 'mr', 'en'

  UserProfileModel get profile => _profile;
  String get currentRole => _profile.role;
  bool get isLoading => _isLoading;
  String get selectedLanguage => _selectedLanguage;

  UserProfileProvider() {
    loadProfile();
  }

  Future<void> setLanguage(String lang) async {
    _selectedLanguage = lang;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_langPrefKey, lang);
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }

  Future<void> switchRole(String newRole) async {
    _profile = _profile.copyWith(role: newRole);
    await _persistProfile();
    notifyListeners();
  }

  /// Initial profile load from local storage and sync with Firebase
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString(_langPrefKey);
      if (savedLang != null && savedLang.isNotEmpty) {
        _selectedLanguage = savedLang;
      }

      final localJson = prefs.getString(_prefKey);

      if (localJson != null && localJson.isNotEmpty) {
        _profile = UserProfileModel.fromJson(localJson);
      }

      // Check Firebase Auth state
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final displayName = firebaseUser.displayName;
        final email = firebaseUser.email;
        final uid = firebaseUser.uid;

        if (_profile.name == 'Artisan' && displayName != null && displayName.isNotEmpty) {
          _profile = _profile.copyWith(
            id: uid,
            name: displayName,
            email: email ?? '',
          );
        } else if (_profile.id == 'user_default') {
          _profile = _profile.copyWith(
            id: uid,
            email: email ?? _profile.email,
            name: (displayName?.isNotEmpty == true) ? displayName : _profile.name,
          );
        }

        // Attempt Firestore sync in background if available
        _syncWithFirestore(uid);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set up profile when registering an artisan account
  Future<void> saveNewArtisanProfile({
    required String name,
    required String email,
    required String craftType,
    String? location,
    String? phone,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'artisan_${DateTime.now().millisecondsSinceEpoch}';
    final currentYear = DateTime.now().year.toString();

    _profile = UserProfileModel(
      id: uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone?.trim() ?? '',
      role: 'artisan',
      craftType: craftType.isNotEmpty ? craftType : 'Handmade Crafts',
      location: location?.isNotEmpty == true ? location! : 'Maharashtra, India',
      state: 'Maharashtra',
      memberSince: currentYear,
      isVerified: true,
      bio: 'Creating authentic handmade $craftType crafted with care and heritage techniques.',
      masteryLevel: 'Verified Craftsman',
    );

    await _persistProfile();
    notifyListeners();
  }

  /// Set up profile when registering a buyer account
  Future<void> saveNewBuyerProfile({
    required String name,
    required String email,
    required String businessName,
    required String businessType,
    String? location,
    String? phone,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'buyer_${DateTime.now().millisecondsSinceEpoch}';

    _profile = UserProfileModel(
      id: uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone?.trim() ?? '',
      role: 'buyer',
      businessName: businessName.trim(),
      businessType: businessType.trim(),
      location: location?.isNotEmpty == true ? location! : 'Mumbai, India',
      state: 'Maharashtra',
      memberSince: DateTime.now().year.toString(),
      isVerified: true,
      bio: 'Sourcing authentic artisan crafts and handloom textiles.',
    );

    await _persistProfile();
    notifyListeners();
  }

  /// Update profile details (e.g. from Edit Profile screen)
  Future<void> updateProfile({
    required String name,
    required String craftType,
    required String location,
    required String state,
    required String phone,
    required String bio,
    String? role,
  }) async {
    _profile = _profile.copyWith(
      name: name.trim(),
      craftType: craftType.trim(),
      location: location.trim(),
      state: state.trim(),
      phone: phone.trim(),
      bio: bio.trim(),
      role: role ?? _profile.role,
    );

    await _persistProfile();
    notifyListeners();
  }

  /// Persist to SharedPreferences and Cloud Firestore
  Future<void> _persistProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, _profile.toJson());

      // Attempt Firestore write silently if available (non-blocking)
      final user = FirebaseAuth.instance.currentUser;
      final docId = user?.uid ?? _profile.id;
      if (docId.isNotEmpty && docId != 'user_default') {
        FirebaseFirestore.instance
            .collection('users')
            .doc(docId)
            .set(_profile.toMap(), SetOptions(merge: true))
            .timeout(const Duration(seconds: 5))
            .catchError((_) {});
      }
    } catch (e) {
      debugPrint('Local/Firestore profile save note: $e');
    }
  }

  /// Background sync with Firestore
  Future<void> _syncWithFirestore(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 5));
      if (doc.exists && doc.data() != null) {
        final serverProfile = UserProfileModel.fromMap(doc.data()!, uid);
        _profile = serverProfile;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_prefKey, _profile.toJson());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Firestore read note: $e');
    }
  }

  /// Clear profile data on logout
  Future<void> clearProfile() async {
    _profile = UserProfileModel(
      id: 'user_default',
      name: 'Artisan',
      craftType: 'Traditional Crafts',
      location: 'Maharashtra',
      state: 'Maharashtra',
      role: 'artisan',
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKey);
    } catch (e) {
      debugPrint('Error clearing profile: $e');
    }
    notifyListeners();
  }
}
