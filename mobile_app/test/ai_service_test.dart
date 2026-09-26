// test/ai_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shilpsetu_ai/core/services/ai_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('AiService Tests', () {
    late AiService aiService;

    setUp(() {
      aiService = AiService();
    });

    test('generateCatalog returns valid catalog for Textile', () async {
      final result = await aiService.generateCatalog(
        voiceTranscript: 'हाताने विणलेली पैठणी साडी मोर नक्षी',
        craftType: 'Textiles',
      );

      expect(result, isNotNull);
      expect(result['title_en'], contains('Paithani'));
      expect(result['category'], equals('Textiles'));
      expect(result['recommended_price'], isNotEmpty);
      expect(result['heritage_story'], isNotEmpty);
    });

    test('generateCatalog returns valid catalog for Woodcraft', () async {
      final result = await aiService.generateCatalog(
        voiceTranscript: 'Handcarved wooden jharokha frame',
        craftType: 'Woodcraft',
      );

      expect(result, isNotNull);
      expect(result['title_en'], contains('Wood'));
      expect(result['category'], equals('Woodcraft'));
      expect(result['material'], contains('Sheesham'));
    });

    test('generateCatalog returns valid catalog for Metal and Brass', () async {
      final result = await aiService.generateCatalog(
        voiceTranscript: 'Pure brass engraved urli bowl',
        craftType: 'Brass & Metal',
      );

      expect(result, isNotNull);
      expect(result['title_en'], contains('Brass'));
      expect(result['category'], equals('Metal & Brass'));
    });

    test('generateCatalog returns valid catalog for Jewelry', () async {
      final result = await aiService.generateCatalog(
        voiceTranscript: 'Kundan choker necklace with meenakari',
        craftType: 'Jewelry',
      );

      expect(result, isNotNull);
      expect(result['title_en'], contains('Kundan'));
      expect(result['category'], equals('Jewelry & Accessories'));
    });

    test('generateCatalog returns valid catalog for Terracotta Pottery', () async {
      final result = await aiService.generateCatalog(
        voiceTranscript: 'Handmade clay dhoopdaani',
        craftType: 'Pottery',
      );

      expect(result, isNotNull);
      expect(result['title_en'], contains('Terracotta'));
      expect(result['category'], equals('Pottery & Clay'));
    });

    test('calculateSmartPricing calculates accurate pricing breakdown', () {
      final pricing = aiService.calculateSmartPricing(
        productionCost: 1000,
        laborDays: 5,
        craftType: 'Silk Weaving',
      );

      expect(pricing['production_cost'], equals('₹1000'));
      expect(pricing['recommended_price'], isNotEmpty);
      expect(pricing['market_range'], isNotEmpty);
      expect(pricing['confidence'], equals('94%'));
      expect(pricing['factors'], isNotEmpty);
    });

    test('generateHeritageStory generates authentic craft story', () async {
      final story = await aiService.generateHeritageStory(
        craftType: 'Paithani Handloom',
        origin: 'Paithan, Maharashtra',
      );

      expect(story, isNotEmpty);
      expect(story, contains('Paithani'));
    });
  });
}
