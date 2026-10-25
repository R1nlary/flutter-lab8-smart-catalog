import 'package:flutter/material.dart';

import '../data/products.dart';
import '../models/product.dart';
import '../widgets/empty_catalog.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/product_list_tile.dart';
import '../widgets/swipe_to_delete.dart';

enum ViewMode { list, grid }

/// Dual-view catalog: List Feed / Grid Catalog with pull-to-refresh,
/// swipe-to-delete + UNDO and an empty state.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Product> _products = seedProducts();
  ViewMode _mode = ViewMode.list;
  int _nextId = 100; // ids for "downloaded" items, never clash with seed ids

  void _toggleView() {
    setState(
      () => _mode = _mode == ViewMode.list ? ViewMode.grid : ViewMode.list,
    );
  }

  /// Pull-to-refresh: fake 1.5 s network request, then new item at index 0.
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _products.insert(0, generateProduct(_nextId++)));
  }

  /// Swipe-to-delete: remove from data, then offer UNDO.
  void _removeAt(int index) {
    final removed = _products[index];
    setState(() => _products.removeAt(index));

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        content: Text('"${removed.title}" deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Back to the original index (clamped in case the list changed).
            setState(
              () => _products.insert(index.clamp(0, _products.length), removed),
            );
          },
        ),
      ),
    );
  }

  void _resetCatalog() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => _products = seedProducts());
  }

  @override
  Widget build(BuildContext context) {
    final isList = _mode == ViewMode.list;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Catalog'),
        actions: [
          Center(child: Text('${_products.length} items')),
          IconButton(
            tooltip: isList ? 'Show as grid' : 'Show as list',
            icon: Icon(
              isList ? Icons.grid_view_rounded : Icons.view_list_rounded,
            ),
            onPressed: _toggleView,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _products.isEmpty
            ? _buildEmpty()
            : isList
            ? _buildList()
            : _buildGrid(),
      ),
    );
  }

  /// RefreshIndicator needs a scrollable child, so the empty state lives
  /// inside a ListView — pull-to-refresh still works on an empty catalog.
  Widget _buildEmpty() {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: EmptyCatalog(onReset: _resetCatalog),
          ),
        ],
      ),
    );
  }

  /// Lazy list: only visible rows (+ separators) are built.
  Widget _buildList() {
    return ListView.separated(
      key: const PageStorageKey('list'),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _products.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 80),
      itemBuilder: (context, index) {
        final product = _products[index];
        return SwipeToDelete(
          product: product,
          onDismissed: () => _removeAt(index),
          child: ProductListTile(product: product),
        );
      },
    );
  }

  /// Lazy 2-column grid, cell height = width / 0.72.
  Widget _buildGrid() {
    return GridView.builder(
      key: const PageStorageKey('grid'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return SwipeToDelete(
          product: product,
          borderRadius: BorderRadius.circular(16),
          onDismissed: () => _removeAt(index),
          child: ProductGridCard(product: product),
        );
      },
    );
  }
}
