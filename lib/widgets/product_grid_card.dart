import 'package:flutter/material.dart';

import '../models/product.dart';
import 'category_tag.dart';
import 'rating_stars.dart';

/// Card of the 2-column Grid Catalog.
/// The image area is `Expanded`, so the card adapts to any cell height
/// produced by `childAspectRatio: 0.72` and never overflows.
class ProductGridCard extends StatelessWidget {
  const ProductGridCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: product.color.withValues(alpha: 0.15),
              child: Icon(product.icon, size: 56, color: product.color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                CategoryTag(label: product.category, color: product.color),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RatingStars(rating: product.rating),
                    const SizedBox(width: 6),
                    // Price shrinks on narrow phones instead of overflowing.
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
