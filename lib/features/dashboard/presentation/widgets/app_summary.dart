// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../digital_app/presentation/bloc/digital_app_bloc.dart';

// class AppSummary extends StatelessWidget {
//   const AppSummary({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<DigitalAppBloc, DigitalAppState>(
//       builder: (context, state) {
//         if (state is DigitalAppLoaded) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Focus Apps', style: TextStyle(fontSize: 16)),
//               const SizedBox(height: 8),
//               ...state.apps.map((app) => ListTile(
//                     title: Text(app.name),
//                     subtitle: Text('Limit: ${app.dailyLimitMinutes} min'),
//                     trailing: const Icon(Icons.chevron_right),
//                   )),
//             ],
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }
// }
