// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shilpsetu_ai/core/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String get _baseUrl => AppConstants.baseUrl;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Generic GET request
  Future<Map<String, dynamic>?> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint('API GET error: $e');
    }
    return null;
  }

  /// Generic POST request
  Future<Map<String, dynamic>?> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(body),
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint('API POST error: $e');
    }
    return null;
  }

  /// Upload image multipart
  Future<Map<String, dynamic>?> uploadImage(String endpoint, File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl$endpoint'));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      var streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint('API Upload error: $e');
    }
    return null;
  }

  /// Upload voice audio for transcription
  Future<Map<String, dynamic>?> transcribeAudio({
    required File audioFile,
    String language = 'mr',
    String? craftType,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/products/transcribe-voice'));
      request.files.add(await http.MultipartFile.fromPath('audio', audioFile.path));
      request.fields['language'] = language;
      if (craftType != null) {
        request.fields['craft_type'] = craftType;
      }
      var streamedResponse = await request.send().timeout(const Duration(seconds: 45));
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint('Audio transcription API error: $e');
    }
    return null;
  }

  // Convenience methods for specific endpoints
  Future<Map<String, dynamic>?> generateCatalog({
    required String transcript,
    required String artisanLocation,
    required String language,
    File? imageFile,
  }) async {
    return post('/api/products/generate-catalog', {
      'transcript': transcript,
      'artisan_location': artisanLocation,
      'language': language,
    });
  }

  Future<Map<String, dynamic>?> recommendPrice({
    required String category,
    required String material,
    required String craftType,
    required double productionCost,
  }) async {
    return post('/api/products/recommend-price', {
      'category': category,
      'material': material,
      'craft_type': craftType,
      'production_cost': productionCost,
    });
  }

  Future<Map<String, dynamic>?> matchBuyers(String productId) async {
    return post('/api/buyers/match', {'product_id': productId});
  }

  Future<Map<String, dynamic>?> saveProduct(Map<String, dynamic> productData) async {
    return post('/api/products', productData);
  }
}
