// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../reflection/presentation/bloc/reflection_bloc.dart';

// class TodayStatusCard extends StatelessWidget {
//   const TodayStatusCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: context.read<ReflectionBloc>().repository.getTodayReflection(),
//       builder: (context, snapshot) {
//         // Show the card even if no reflection yet
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('⏭️ Focus',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 Text(
//                   snapshot.hasData && snapshot.data != null
//                       ? snapshot.data!.tomorrowIntention
//                       : 'Awareness matters more than perfection.',
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
