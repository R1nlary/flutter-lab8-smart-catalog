import 'package:flutter/material.dart';

/// Shown when all items were dismissed.
class EmptyCatalog extends StatelessWidget {
  const EmptyCatalog({super.key, required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 96, color: scheme.outline),
            const SizedBox(height: 16),
            Text(
              'Catalog is Empty',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'All products were removed. Restore the initial data or pull down to load a new item.',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset Catalog'),
            ),
          ],
        ),
      ),
    );
  }
}
