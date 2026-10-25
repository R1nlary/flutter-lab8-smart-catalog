import 'package:flutter/material.dart';

/// One catalog item. `id` is unique and never reused, so it is safe to use
/// as `ValueKey(product.id)` for Dismissible.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.price,
    required this.icon,
    required this.color,
  });

  final int id;
  final String title;
  final String category;
  final double rating;
  final double price;
  final IconData icon;
  final Color color;
}
