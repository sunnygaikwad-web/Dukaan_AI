import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shilpsetu_ai/main.dart';
import 'package:shilpsetu_ai/core/providers/user_profile_provider.dart';
import 'package:shilpsetu_ai/core/providers/product_provider.dart';
import 'package:shilpsetu_ai/core/providers/buyer_request_provider.dart';
import 'package:shilpsetu_ai/core/providers/shortlist_provider.dart';

void main() {
  testWidgets('ShilpSetu app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProfileProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => BuyerRequestProvider()),
          ChangeNotifierProvider(create: (_) => ShortlistProvider()),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ],
        child: const ShilpSetuApp(),
      ),
    );

    // Settle all splash screen animations and navigation delays
    await tester.pumpAndSettle();
    expect(find.byType(ShilpSetuApp), findsOneWidget);
  });
}
