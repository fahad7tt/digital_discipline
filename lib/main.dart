import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/utils/app_di.dart';
import 'features/digital_app/data/models/digital_app_model.dart';
import 'features/digital_app/presentation/bloc/digital_app_bloc.dart';
import 'features/digital_app/presentation/screens/digital_app_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(DigitalAppModelAdapter());

  await AppDI.init();

  runApp(const IntentApp());
}

class IntentApp extends StatelessWidget {
  const IntentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DigitalAppBloc(
        AppDI.addDigitalApp,
        AppDI.digitalAppRepository,
      )..add(LoadDigitalApps()),
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
