import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/digital_app_bloc.dart';

class DigitalAppScreen extends StatelessWidget {
  const DigitalAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Digital Intentions'),
      ),
      body: BlocBuilder<DigitalAppBloc, DigitalAppState>(
        builder: (context, state) {

          // 1️⃣ Loading state
          if (state is DigitalAppLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2️⃣ EMPTY STATE
          if (state is DigitalAppLoaded && state.apps.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Choose one app you want to be more intentional with.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // 3️⃣ DATA STATE
          if (state is DigitalAppLoaded) {
            return ListView.builder(
              itemCount: state.apps.length,
              itemBuilder: (context, index) {
                final app = state.apps[index];
                return ListTile(
                  title: Text(app.name),
                  subtitle: Text(
                    'Daily limit: ${app.dailyLimitMinutes} min',
                  ),
                );
              },
            );
          }

          // 4️⃣ ERROR STATE
          if (state is DigitalAppError) {
            return Center(
              child: Text(state.message),
            );
          }

          // 5️⃣ FALLBACK (should rarely hit)
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
