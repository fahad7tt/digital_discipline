import 'package:flutter_test/flutter_test.dart';
import 'package:digital_discipline/main.dart';
import 'package:digital_discipline/features/digital_app/data/repositories/digital_app_repository_impl.dart';
import 'package:digital_discipline/features/digital_app/domain/usecases/add_digital_app.dart';
import 'package:digital_discipline/features/digital_app/data/datasources/digital_app_local_datasource.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:digital_discipline/features/digital_app/data/models/digital_app_model.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DigitalAppModelAdapter());
  final focusAppBox = await Hive.openBox<DigitalAppModel>('focusAppsBox');

  final localDataSource = DigitalAppLocalDataSourceImpl(focusAppBox);
  final repository = DigitalAppRepositoryImpl(localDataSource);
  final addDigitalApp = AddDigitalApp(repository);

  testWidgets('DigitalAppPage loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(repository: repository, addDigitalApp: addDigitalApp),
    );

    // Example test: check if app bar exists
    expect(find.text('Digital Apps'), findsOneWidget);
  });
}
