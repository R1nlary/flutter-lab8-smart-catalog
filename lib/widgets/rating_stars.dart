import 'package:flutter/material.dart';

/// Star icon + numeric rating, e.g. ★ 4.7
class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
