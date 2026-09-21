// lib/models/buyer_model.dart
class BuyerModel {
  final String id;
  final String name;
  final String organization;
  final String businessCategory;
  final String location;
  final List<String> requiredCategories;
  final String contactEmail;
  final String? contactPhone;
  final int matchScore;
  final String matchReason;

  BuyerModel({
    required this.id,
    required this.name,
    required this.organization,
    required this.businessCategory,
    required this.location,
    required this.requiredCategories,
    required this.contactEmail,
    this.contactPhone,
    this.matchScore = 0,
    this.matchReason = '',
  });

  factory BuyerModel.fromMap(Map<String, dynamic> map, String id) {
    return BuyerModel(
      id: id,
      name: map['name'] ?? '',
      organization: map['organization'] ?? '',
      businessCategory: map['business_category'] ?? '',
      location: map['location'] ?? '',
      requiredCategories: List<String>.from(map['required_categories'] ?? []),
      contactEmail: map['contact_email'] ?? '',
      contactPhone: map['contact_phone'],
      matchScore: map['match_score'] ?? 0,
      matchReason: map['match_reason'] ?? '',
    );
  }

  // Demo buyers with match scores
  static List<BuyerModel> get demoBuyers => [
    BuyerModel(
      id: 'buyer_001',
      name: 'Priya Mehta',
      organization: 'Premium Handloom Boutique',
      businessCategory: 'Luxury Textile Retail',
      location: 'Mumbai, Maharashtra',
      requiredCategories: ['Textiles', 'Saree', 'Silk'],
      contactEmail: 'priya@premiumhandloom.com',
      contactPhone: '+912244556677',
      matchScore: 92,
      matchReason: 'This buyer frequently sources handloom textiles from Maharashtra. They have placed 12 bulk orders for Paithani sarees in the past year.',
    ),
    BuyerModel(
      id: 'buyer_002',
      name: 'Amit Sharma',
      organization: 'Urban Handicrafts',
      businessCategory: 'Handicraft Export',
      location: 'Delhi',
      requiredCategories: ['Textiles', 'Home Decor', 'Jewellery'],
      contactEmail: 'amit@urbanhandicrafts.com',
      matchScore: 78,
      matchReason: 'Urban Handicrafts exports traditional Indian crafts to Europe and USA. They are actively looking for authentic Paithani weavers.',
    ),
    BuyerModel(
      id: 'buyer_003',
      name: 'Ramesh Iyer',
      organization: 'Hotel Heritage Group',
      businessCategory: 'Hospitality & Decor',
      location: 'Pune, Maharashtra',
      requiredCategories: ['Textiles', 'Home Decor', 'Paintings'],
      contactEmail: 'ramesh@hotelheritage.com',
      matchScore: 65,
      matchReason: 'Hotel Heritage Group decorates their heritage properties with authentic local crafts. They purchase seasonal collections.',
    ),
    BuyerModel(
      id: 'buyer_004',
      name: 'Deepa Nair',
      organization: 'Corporate Gifts India',
      businessCategory: 'Corporate Gifting',
      location: 'Bangalore, Karnataka',
      requiredCategories: ['Textiles', 'Home Decor', 'Jewellery', 'Pottery'],
      contactEmail: 'deepa@corporategiftsindia.com',
      matchScore: 58,
      matchReason: 'Corporate Gifts India curates artisan products for premium corporate gifting. They are looking for unique, culturally significant items.',
    ),
  ];
}
