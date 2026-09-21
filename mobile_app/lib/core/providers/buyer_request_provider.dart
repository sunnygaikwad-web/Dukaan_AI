// lib/core/providers/buyer_request_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyerRequestModel {
  final String id;
  final String buyerName;
  final String buyerOrg;
  final String buyerLocation;
  final String productId;
  final String productTitle;
  final String productPrice;
  final int quantity;
  final String expectedDelivery;
  final String message;
  final String status; // 'pending', 'accepted', 'rejected', 'completed'
  final DateTime createdAt;
  final String artisanId;

  BuyerRequestModel({
    required this.id,
    required this.buyerName,
    required this.buyerOrg,
    required this.buyerLocation,
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.quantity,
    required this.expectedDelivery,
    required this.message,
    this.status = 'pending',
    required this.createdAt,
    this.artisanId = '',
  });

  BuyerRequestModel copyWith({String? status}) {
    return BuyerRequestModel(
      id: id,
      buyerName: buyerName,
      buyerOrg: buyerOrg,
      buyerLocation: buyerLocation,
      productId: productId,
      productTitle: productTitle,
      productPrice: productPrice,
      quantity: quantity,
      expectedDelivery: expectedDelivery,
      message: message,
      status: status ?? this.status,
      createdAt: createdAt,
      artisanId: artisanId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerName': buyerName,
      'buyerOrg': buyerOrg,
      'buyerLocation': buyerLocation,
      'productId': productId,
      'productTitle': productTitle,
      'productPrice': productPrice,
      'quantity': quantity,
      'expectedDelivery': expectedDelivery,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'artisanId': artisanId,
    };
  }

  factory BuyerRequestModel.fromMap(Map<String, dynamic> map, String id) {
    return BuyerRequestModel(
      id: id,
      buyerName: map['buyerName'] ?? map['buyer_name'] ?? 'Verified Buyer',
      buyerOrg: map['buyerOrg'] ?? map['organization'] ?? 'Heritage Boutique',
      buyerLocation: map['buyerLocation'] ?? map['location'] ?? 'Mumbai, MH',
      productId: map['productId'] ?? map['product_id'] ?? '',
      productTitle: map['productTitle'] ?? map['product_title'] ?? 'Handcrafted Art',
      productPrice: map['productPrice'] ?? map['product_price'] ?? '₹3,499',
      quantity: (map['quantity'] is int) ? map['quantity'] : int.tryParse(map['quantity']?.toString() ?? '10') ?? 10,
      expectedDelivery: map['expectedDelivery'] ?? map['expected_delivery'] ?? '15-20 Days',
      message: map['message'] ?? 'We are interested in sourcing this collection for our festive showcase.',
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      artisanId: map['artisanId'] ?? map['artisan_id'] ?? '',
    );
  }

  static List<BuyerRequestModel> get initialDemoRequests => [
    BuyerRequestModel(
      id: 'req_001',
      buyerName: 'Priya Mehta',
      buyerOrg: 'Premium Handloom Boutique',
      buyerLocation: 'Mumbai, Maharashtra',
      productId: 'prod_demo_01',
      productTitle: 'Handwoven Paithani Silk Saree',
      productPrice: '₹8,499',
      quantity: 15,
      expectedDelivery: 'Next Month (Diwali Season)',
      message: 'Looking for 15 authentic handwoven sarees with peacock pallu motifs. Can you fulfill in 30 days?',
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    BuyerRequestModel(
      id: 'req_002',
      buyerName: 'Amit Sharma',
      buyerOrg: 'Urban Handicrafts Export',
      buyerLocation: 'New Delhi',
      productId: 'prod_demo_02',
      productTitle: 'Terracotta Incense Burner',
      productPrice: '₹279',
      quantity: 50,
      expectedDelivery: '20 Days',
      message: 'Urgent bulk order for international exhibition pavilion. Requires careful protective packaging.',
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}

class BuyerRequestProvider extends ChangeNotifier {
  static const String _prefKey = 'shilpsetu_buyer_requests_cache';
  List<BuyerRequestModel> _requests = [];
  bool _isLoading = false;

  List<BuyerRequestModel> get requests => _requests;
  bool get isLoading => _isLoading;
  int get pendingCount => _requests.where((r) => r.status == 'pending').length;

  BuyerRequestProvider() {
    loadRequests();
  }

  Future<void> loadRequests() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getStringList(_prefKey);

      if (savedData != null && savedData.isNotEmpty) {
        _requests = savedData.map((str) {
          final Map<String, dynamic> map = json.decode(str);
          return BuyerRequestModel.fromMap(map, map['id'] ?? 'req_${DateTime.now().millisecondsSinceEpoch}');
        }).toList();
      } else {
        _requests = List<BuyerRequestModel>.from(BuyerRequestModel.initialDemoRequests);
        await _persistRequests();
      }
    } catch (e) {
      debugPrint('Error loading buyer requests: $e');
      _requests = List<BuyerRequestModel>.from(BuyerRequestModel.initialDemoRequests);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitRequest(BuyerRequestModel request) async {
    _requests.insert(0, request);
    await _persistRequests();
    notifyListeners();

    // Sync to Firestore if online
    try {
      await FirebaseFirestore.instance.collection('buyerRequests').doc(request.id).set(request.toMap());
    } catch (e) {
      debugPrint('Firestore buyer request sync note: $e');
    }
  }

  Future<void> updateStatus(String requestId, String newStatus) async {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _requests[index] = _requests[index].copyWith(status: newStatus);
      await _persistRequests();
      notifyListeners();

      try {
        await FirebaseFirestore.instance
            .collection('buyerRequests')
            .doc(requestId)
            .set(_requests[index].toMap(), SetOptions(merge: true));
      } catch (e) {
        debugPrint('Firestore buyer request status update note: $e');
      }
    }
  }

  Future<void> _persistRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _requests.map((r) => json.encode(r.toMap())).toList();
      await prefs.setStringList(_prefKey, list);
    } catch (e) {
      debugPrint('Error persisting buyer requests: $e');
    }
  }
}
