// lib/core/providers/shortlist_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShortlistProvider extends ChangeNotifier {
  static const String _prefKey = 'shilpsetu_shortlisted_products';
  final Set<String> _shortlistedIds = {};

  Set<String> get shortlistedIds => _shortlistedIds;

  ShortlistProvider() {
    _loadShortlist();
  }

  bool isShortlisted(String productId) {
    return _shortlistedIds.contains(productId);
  }

  Future<void> _loadShortlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_prefKey);
      if (list != null) {
        _shortlistedIds.clear();
        _shortlistedIds.addAll(list);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading shortlist: $e');
    }
  }

  Future<void> toggleShortlist(String productId) async {
    if (_shortlistedIds.contains(productId)) {
      _shortlistedIds.remove(productId);
    } else {
      _shortlistedIds.add(productId);
    }
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefKey, _shortlistedIds.toList());
    } catch (e) {
      debugPrint('Error saving shortlist: $e');
    }
  }
}
