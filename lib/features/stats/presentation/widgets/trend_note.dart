import 'package:flutter/material.dart';

class TrendNote extends StatelessWidget {
  final bool isImproving;

  const TrendNote({super.key, required this.isImproving});

  @override
  Widget build(BuildContext context) {
    return Text(
      isImproving
          ? 'Your usage is trending down compared to last week.'
          : 'Your usage is steady. Awareness comes before change.',
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey[600],
      ),
    );
  }
}
