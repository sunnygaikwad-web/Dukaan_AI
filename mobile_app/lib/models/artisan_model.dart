// lib/models/artisan_model.dart
class ArtisanModel {
  final String id;
  final String name;
  final String location;
  final String state;
  final String craftType;
  final int experienceYears;
  final String phone;
  final String? profileImageUrl;
  final String languagePreference;
  final String? craftStory;

  ArtisanModel({
    required this.id,
    required this.name,
    required this.location,
    required this.state,
    required this.craftType,
    required this.experienceYears,
    required this.phone,
    this.profileImageUrl,
    this.languagePreference = 'en',
    this.craftStory,
  });

  factory ArtisanModel.fromMap(Map<String, dynamic> map, String id) {
    return ArtisanModel(
      id: id,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      state: map['state'] ?? '',
      craftType: map['craft_type'] ?? '',
      experienceYears: map['experience_years'] ?? 0,
      phone: map['phone'] ?? '',
      profileImageUrl: map['profile_image_url'],
      languagePreference: map['language_preference'] ?? 'en',
      craftStory: map['craft_story'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'state': state,
      'craft_type': craftType,
      'experience_years': experienceYears,
      'phone': phone,
      'profile_image_url': profileImageUrl,
      'language_preference': languagePreference,
      'craft_story': craftStory,
    };
  }

  // Demo artisans
  static final List<ArtisanModel> demoArtisans = [
    ArtisanModel(
      id: 'artisan_001',
      name: 'Savita Patil',
      location: 'Paithan, Aurangabad',
      state: 'Maharashtra',
      craftType: 'Paithani',
      experienceYears: 18,
      phone: '+919876543210',
      languagePreference: 'mr',
      craftStory: 'I learned Paithani weaving from my mother at age 10. Each saree takes 2-3 months to complete by hand.',
    ),
    ArtisanModel(
      id: 'artisan_002',
      name: 'Ramesh Kumar',
      location: 'Jaipur',
      state: 'Rajasthan',
      craftType: 'Blue Pottery',
      experienceYears: 25,
      phone: '+919876543211',
      languagePreference: 'hi',
    ),
    ArtisanModel(
      id: 'artisan_003',
      name: 'Asha Devi',
      location: 'Madhubani',
      state: 'Bihar',
      craftType: 'Madhubani',
      experienceYears: 12,
      phone: '+919876543212',
      languagePreference: 'hi',
    ),
  ];

  // Currently logged-in demo artisan
  static ArtisanModel get currentDemo => demoArtisans[0];
}
