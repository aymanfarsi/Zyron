import 'package:flutter_test/flutter_test.dart';
import 'package:zyron/src/rust/frb_generated.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zyron/views/skeleton.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  testWidgets('Can call rust function', (WidgetTester tester) async {
    await tester.pumpWidget(const AppSkeleton());
    expect(find.textContaining('Result: `Hello, Tom!`'), findsOneWidget);
  });
}
