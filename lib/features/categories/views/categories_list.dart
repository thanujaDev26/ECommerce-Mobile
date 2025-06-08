import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  final List<Map<String, dynamic>> categories = [
    {"label": "Handcrafts", "icon": Icons.handyman, "route": "/handcrafts"},
    {"label": "Spices", "icon": Icons.local_fire_department, "route": "/spices"},
    {"label": "Herbal", "icon": Icons.eco, "route": "/herbal"},
    {"label": "Clay Pots", "icon": Icons.rice_bowl, "route": "/claypots"},
    {"label": "Beverages", "icon": Icons.local_cafe, "route": "/beverages"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  child: Icon(category["icon"], size: 28),
                ),
                title: Text(category["label"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.pushNamed(context, category["route"]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}