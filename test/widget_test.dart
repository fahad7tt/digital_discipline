import 'package:digital_discipline/intent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:digital_discipline/features/digital_app/data/models/digital_app_model.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DigitalAppModelAdapter());

  testWidgets('DigitalAppPage loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      IntentApp(),
    );

    // Example test: check if app bar exists
    expect(find.text('Digital Apps'), findsOneWidget);
  });
}
