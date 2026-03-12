// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:winp_flux_assessment/main.dart';
import 'package:winp_flux_assessment/services/product_service.dart';
import 'package:winp_flux_assessment/models/product_model.dart';

void main() {
  setUp(() {
    // Register a mock ProductService
    if (!GetIt.instance.isRegistered<ProductService>()) {
      GetIt.instance.registerLazySingleton<ProductService>(() => _MockProductService());
    }
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('ProductListing app loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProductListing());
    await tester.pumpAndSettle();

    // Verify the app loaded
    expect(find.byType(ProductListing), findsOneWidget);
  });
}

class _MockProductService extends ProductService {
  @override
  Future<List<ProductModel>> fetchProducts() async {
    return [];
  }
}
