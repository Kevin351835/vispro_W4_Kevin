import 'package:flutter/material.dart';

class CategoryBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const categories = [
    'Semua',
    'Xianxia / Fantasy',
    'Wuxia / Martial Arts',
    'Historical / Palace',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8), // Ganti (_, __)
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return FilterChip(
            selected: isSelected,
            label: Text(category),
            onSelected: (_) => onCategorySelected(category),
          );
        },
      ),
    );
  }
}