import 'package:digital_discipline/features/digital_app/data/models/digital_app_model.dart';
import 'package:digital_discipline/features/digital_app/presentation/screens/digital_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/digital_app/data/datasources/digital_app_local_datasource.dart';
import 'features/digital_app/data/repositories/digital_app_repository_impl.dart';
import 'features/digital_app/domain/usecases/add_digital_app.dart';
import 'features/digital_app/presentation/bloc/digital_app_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DigitalAppModelAdapter());

  final digitalAppBox = await Hive.openBox<DigitalAppModel>('digitalAppsBox');

  // DI
  final localDataSource = DigitalAppLocalDataSourceImpl(digitalAppBox);
  final repository = DigitalAppRepositoryImpl(localDataSource);
  final addUseCase = AddDigitalApp(repository);

  runApp(MyApp(
    repository: repository,
    addDigitalApp: addUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final DigitalAppRepositoryImpl repository;
  final AddDigitalApp addDigitalApp;

  const MyApp({required this.repository, required this.addDigitalApp, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DigitalAppBloc(addDigitalApp, repository)..add(LoadDigitalApps()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Intent – Digital Discipline',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const DigitalAppScreen(),
      ),
    );
  }
}
