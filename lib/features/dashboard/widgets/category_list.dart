import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"label": "Electronics", "icon": Icons.phone_android},
      {"label": "Fashion", "icon": Icons.shopping_bag},
      {"label": "Home", "icon": Icons.chair_alt},
      {"label": "Books", "icon": Icons.menu_book},
      {"label": "Beauty", "icon": Icons.brush},
      {"label": "Sports", "icon": Icons.sports_soccer},
      {"label": "Toys", "icon": Icons.toys},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            children: [
              CircleAvatar(
                backgroundColor: AppColors().primary.withOpacity(0.1),
                radius: 26,
                child: Icon(category["icon"], color: AppColors().primary, size: 28),
              ),
              const SizedBox(height: 6),
              Text(category["label"],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          );
        },
      ),
    );
  }
}
