# Flutter Lab 8 — Dynamic Lists, Grids & Scrollable Touch Interactions

"Smart Catalog & Infinite Feed": one catalog shown as a List Feed or a
2-column Grid, with pull-to-refresh, swipe-to-delete + UNDO and an empty state.

## Run

```bash
flutter pub get
flutter run -d chrome
```

```bash
flutter test
```

## Project structure

```
lib/
├── main.dart                     # MaterialApp + theme
├── models/product.dart           # Product data class (id, title, category, rating, price)
├── data/products.dart            # 12 seed products + generator for refresh
├── screens/catalog_screen.dart   # state: list/grid toggle, refresh, delete, undo, reset
└── widgets/
    ├── product_list_tile.dart    # List Feed row
    ├── product_grid_card.dart    # Grid card
    ├── swipe_to_delete.dart      # Dismissible wrapper (ValueKey, red background)
    ├── empty_catalog.dart        # "Catalog is Empty" + Reset Catalog
    ├── category_tag.dart
    └── rating_stars.dart
test/widget_test.dart             # 6 widget tests for every rubric item
```

## How it works (rubric)

1. **ListView.separated & GridView.builder** — both builders are lazy: they
   build only the visible items. `separatorBuilder` returns a thin `Divider`.
   The grid uses `crossAxisCount: 2`, `childAspectRatio: 0.72`; the card image
   is `Expanded` and texts have `maxLines` + ellipsis, so there is no overflow.
2. **RefreshIndicator** — `onRefresh` is `async`, waits
   `Future.delayed(1500 ms)` (fake network), then `_products.insert(0, …)` in
   `setState`. List/grid use `AlwaysScrollableScrollPhysics`, so pull works
   even with few items; the empty state is inside a `ListView` for the same reason.
3. **Dismissible & Undo** — `key: ValueKey(product.id)`, direction
   `endToStart`, red background with `Icons.delete`. `onDismissed` removes the
   item, remembers its index and shows a floating `SnackBar` with `UNDO`, which
   inserts the item back at the same index.
4. **Empty state** — at 0 items: icon, "Catalog is Empty", "Reset Catalog"
   button that restores the seed data.

## Defense notes (possible questions)

* **Why not `Column` + `SingleChildScrollView`?** It builds every child at once:
  1000 items = 1000 widgets in memory and a slow first frame. `ListView.builder`
  / `.separated` builds only what is on screen and recycles elements while scrolling.
* **Why `ValueKey(product.id)` and not the index?** After a removal, indexes
  shift; with index keys Flutter would think a *different* item was dismissed
  ("A dismissed Dismissible widget is still part of the tree" error). The id is
  unique and stable.
* **Why must the item be removed from the list in `onDismissed`?** Dismissible
  only animates; the data must change, otherwise the widget stays in the tree.
* **What does `childAspectRatio: 0.72` mean?** width / height = 0.72, so a cell
  is taller than wide (height ≈ 1.39 × width). Too big a ratio = cell too short = overflow.
* **Why does `onRefresh` return a `Future`?** The spinner stays visible until
  that Future completes.
* **Why `seedProducts()` returns `List.of(...)`?** A `const` list is
  unmodifiable; `removeAt`/`insert` would throw `UnsupportedError`.
* **Why `if (!mounted) return;` after `await`?** The screen may be closed during
  the delay; calling `setState` on a disposed State is an error.
