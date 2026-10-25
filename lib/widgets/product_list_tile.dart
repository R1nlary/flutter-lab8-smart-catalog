import 'package:flutter/material.dart';

import '../models/product.dart';
import 'category_tag.dart';
import 'rating_stars.dart';

/// Row of the List Feed: avatar, title, category tag, rating, price.
class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: product.color.withValues(alpha: 0.15),
        child: Icon(product.icon, color: product.color),
      ),
      title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Flexible(
              child: CategoryTag(label: product.category, color: product.color),
            ),
            const SizedBox(width: 8),
            RatingStars(rating: product.rating),
          ],
        ),
      ),
      trailing: Text(
        '\$${product.price.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
