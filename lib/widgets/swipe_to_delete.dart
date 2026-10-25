import 'package:flutter/material.dart';

import '../models/product.dart';

/// Wraps an item in Dismissible: swipe right-to-left shows a red
/// background with a delete icon and removes the item.
class SwipeToDelete extends StatelessWidget {
  const SwipeToDelete({
    super.key,
    required this.product,
    required this.onDismissed,
    required this.child,
    this.borderRadius = BorderRadius.zero,
  });

  final Product product;
  final VoidCallback onDismissed;
  final Widget child;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Unique stable key: Flutter must know exactly which item was removed.
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: borderRadius,
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: child,
    );
  }
}
