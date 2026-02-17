import 'package:flutter/material.dart';

class CategoryItem {
  const CategoryItem({
    required this.name,
    required this.count,
    required this.icon,
  });

  final String name;
  final int count;
  final IconData icon;
}
