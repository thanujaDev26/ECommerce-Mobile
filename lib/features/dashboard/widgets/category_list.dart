import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"label": "Handcrafts", "icon": Icons.handyman, "route": "/handcrafts"},
      {"label": "Spices", "icon": Icons.local_fire_department, "route": "/spices"},
      {"label": "Herbal", "icon": Icons.eco, "route": "/herbal"},
      {"label": "Clay Pots", "icon": Icons.rice_bowl, "route": "/claypots"},
      {"label": "Tea", "icon": Icons.local_cafe, "route": "/beverages"},
    ];

    final Map<String, Color> categoryColors = {
      "Handcrafts": Colors.brown,
      "Spices": Colors.redAccent,
      "Herbal": Colors.green,
      "Clay Pots": Colors.deepOrange,
      "Tea": Colors.brown.shade300,
    };

    return SizedBox(
      height: 90,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth * 0.05;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(categories.length, (index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, category["route"]);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors().primary.withOpacity(0.1),
                            radius: 30,
                            child: Icon(
                              category["icon"],
                              color: categoryColors[category["label"]] ?? AppColors().primary,
                              size: 35,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category["label"],
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
