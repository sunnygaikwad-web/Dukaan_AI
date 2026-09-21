// lib/core/providers/product_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  static const String _prefKey = 'saved_products_list';

  List<ProductModel> _products = [];
  bool _isLoading = true;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  List<ProductModel> get publishedProducts =>
      _products.where((p) => p.status == 'published').toList();

  List<ProductModel> get draftProducts =>
      _products.where((p) => p.status == 'draft').toList();

  int get totalProductsCount => _products.length;

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedList = prefs.getStringList(_prefKey);

      if (savedList != null && savedList.length >= ProductModel.demoProducts.length) {
        _products = savedList.map((item) {
          final Map<String, dynamic> map = json.decode(item);
          var prod = ProductModel.fromMap(map, map['id'] ?? 'prod_${DateTime.now().millisecondsSinceEpoch}');
          // Sanitize old broken/medical image placeholder
          if ((prod.originalImageUrl != null && prod.originalImageUrl!.contains('1578749556568')) ||
              (prod.enhancedImageUrl != null && prod.enhancedImageUrl!.contains('1578749556568'))) {
            const cleanUrl = 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=1000&q=80';
            prod = prod.copyWith(originalImageUrl: cleanUrl, enhancedImageUrl: cleanUrl);
          }
          return prod;
        }).toList();

        // Deduplicate products by title to avoid repetitive cards
        final seenTitles = <String>{};
        final uniqueProducts = <ProductModel>[];
        for (final p in _products) {
          final titleKey = p.title.trim().toLowerCase();
          if (!seenTitles.contains(titleKey)) {
            seenTitles.add(titleKey);
            uniqueProducts.add(p);
          }
        }
        // Ensure all verified demo crafts are included in the catalog
        for (final demo in ProductModel.demoProducts) {
          final titleKey = demo.title.trim().toLowerCase();
          if (!seenTitles.contains(titleKey)) {
            seenTitles.add(titleKey);
            uniqueProducts.add(demo);
          }
        }
        _products = uniqueProducts;
        await _persistProducts();
      } else {
        // Initialize with default rich demo products with verified online images
        _products = List<ProductModel>.from(ProductModel.demoProducts);
        await _persistProducts();
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
      _products = List<ProductModel>.from(ProductModel.demoProducts);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(ProductModel product) async {
    // Insert at front
    _products.insert(0, product);
    await _persistProducts();
    notifyListeners();

    // Sync to Cloud Firestore
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .set(_productToMap(product))
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Firestore product save note: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    await _persistProducts();
    notifyListeners();

    // Sync deletion to Cloud Firestore
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .delete()
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('Firestore product delete note: $e');
    }
  }

  Future<void> updateStatus(String id, String newStatus) async {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final old = _products[index];
      _products[index] = ProductModel(
        id: old.id,
        artisanId: old.artisanId,
        status: newStatus,
        originalImageUrl: old.originalImageUrl,
        enhancedImageUrl: old.enhancedImageUrl,
        catalog: old.catalog,
        pricing: old.pricing,
        metadata: old.metadata,
        createdAt: old.createdAt,
      );
      await _persistProducts();
      notifyListeners();

      // Sync status update to Cloud Firestore
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(id)
            .set(_productToMap(_products[index]), SetOptions(merge: true))
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint('Firestore product status update note: $e');
      }
    }
  }

  Future<void> _persistProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringList = _products.map((p) => json.encode(_productToMap(p))).toList();
      await prefs.setStringList(_prefKey, stringList);
    } catch (e) {
      debugPrint('Error persisting products: $e');
    }
  }

  Map<String, dynamic> _productToMap(ProductModel p) {
    return {
      'id': p.id,
      'artisan_id': p.artisanId,
      'status': p.status,
      'original_image_url': p.originalImageUrl,
      'enhanced_image_url': p.enhancedImageUrl,
      'catalog': p.catalog.map((k, v) => MapEntry(k, {
        'title': v.title,
        'short_desc': v.shortDesc,
        'description': v.description,
        'heritage_story': v.heritageStory,
        'keywords': v.keywords,
        'seo_title': v.seoTitle,
        'meta_description': v.metaDescription,
      })),
      'pricing': {
        'recommended': p.pricing.recommended,
        'minimum': p.pricing.minimum,
        'market_low': p.pricing.marketLow,
        'market_high': p.pricing.marketHigh,
        'confidence_score': p.pricing.confidenceScore,
        'production_cost': p.pricing.productionCost,
        'factors': p.pricing.factors,
      },
      'metadata': {
        'category': p.metadata.category,
        'subcategory': p.metadata.subcategory,
        'craft_type': p.metadata.craftType,
        'material': p.metadata.material,
        'color': p.metadata.color,
        'origin': p.metadata.origin,
        'region': p.metadata.region,
      },
      'created_at': p.createdAt.toIso8601String(),
    };
  }
}
