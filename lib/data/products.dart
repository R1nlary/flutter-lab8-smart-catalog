import 'package:flutter/material.dart';

import '../models/product.dart';

/// Initial catalog (seed data). Used on start and by "Reset Catalog".
/// Returns a new growable copy each time: a `const` list cannot be modified
/// by removeAt/insert.
List<Product> seedProducts() => List.of(_seed);

const _seed = [
  Product(
    id: 1,
    title: 'Wireless Headphones',
    category: 'Audio',
    rating: 4.7,
    price: 89.99,
    icon: Icons.headphones,
    color: Colors.indigo,
  ),
  Product(
    id: 2,
    title: 'Smart Watch Series 5',
    category: 'Wearables',
    rating: 4.5,
    price: 199.00,
    icon: Icons.watch,
    color: Colors.teal,
  ),
  Product(
    id: 3,
    title: 'Mechanical Keyboard',
    category: 'Computers',
    rating: 4.8,
    price: 129.50,
    icon: Icons.keyboard,
    color: Colors.deepOrange,
  ),
  Product(
    id: 4,
    title: 'Gaming Mouse',
    category: 'Computers',
    rating: 4.4,
    price: 49.90,
    icon: Icons.mouse,
    color: Colors.purple,
  ),
  Product(
    id: 5,
    title: 'Bluetooth Speaker',
    category: 'Audio',
    rating: 4.3,
    price: 59.00,
    icon: Icons.speaker,
    color: Colors.blue,
  ),
  Product(
    id: 6,
    title: 'Action Camera 4K',
    category: 'Photo',
    rating: 4.6,
    price: 249.00,
    icon: Icons.camera_alt,
    color: Colors.red,
  ),
  Product(
    id: 7,
    title: 'Tablet 11"',
    category: 'Mobile',
    rating: 4.5,
    price: 329.00,
    icon: Icons.tablet_mac,
    color: Colors.green,
  ),
  Product(
    id: 8,
    title: 'Smartphone Pro Max',
    category: 'Mobile',
    rating: 4.9,
    price: 999.00,
    icon: Icons.smartphone,
    color: Colors.blueGrey,
  ),
  Product(
    id: 9,
    title: 'Fitness Tracker',
    category: 'Wearables',
    rating: 4.1,
    price: 39.99,
    icon: Icons.monitor_heart,
    color: Colors.pink,
  ),
  Product(
    id: 10,
    title: 'Laptop Stand',
    category: 'Accessories',
    rating: 4.2,
    price: 25.00,
    icon: Icons.laptop,
    color: Colors.brown,
  ),
  Product(
    id: 11,
    title: 'USB-C Power Bank',
    category: 'Accessories',
    rating: 4.0,
    price: 34.50,
    icon: Icons.battery_charging_full,
    color: Colors.amber,
  ),
  Product(
    id: 12,
    title: 'Drone Mini',
    category: 'Photo',
    rating: 4.6,
    price: 459.00,
    icon: Icons.flight,
    color: Colors.cyan,
  ),
];

const _freshTemplates = [
  (
    title: 'VR Headset',
    category: 'Gaming',
    icon: Icons.vrpano,
    color: Colors.deepPurple,
  ),
  (
    title: 'Game Controller',
    category: 'Gaming',
    icon: Icons.sports_esports,
    color: Colors.lightGreen,
  ),
  (
    title: 'E-Book Reader',
    category: 'Mobile',
    icon: Icons.menu_book,
    color: Colors.orange,
  ),
  (
    title: 'Smart Bulb',
    category: 'Smart Home',
    icon: Icons.lightbulb,
    color: Colors.yellow,
  ),
  (
    title: 'Studio Microphone',
    category: 'Audio',
    icon: Icons.mic,
    color: Colors.lime,
  ),
  (
    title: 'Router Wi-Fi 7',
    category: 'Network',
    icon: Icons.router,
    color: Colors.lightBlue,
  ),
];

/// "Server response" for pull-to-refresh: builds a new product with [id].
Product generateProduct(int id) {
  final t = _freshTemplates[id % _freshTemplates.length];
  return Product(
    id: id,
    title: '${t.title} #$id',
    category: t.category,
    rating: 3.5 + (id * 7 % 15) / 10, // 3.5 .. 4.9
    price: 19.99 + (id * 37 % 400),
    icon: t.icon,
    color: t.color,
  );
}
