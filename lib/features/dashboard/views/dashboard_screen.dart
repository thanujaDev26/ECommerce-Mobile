import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/app/constants/app_strings.dart';
import 'package:e_commerce/features/dashboard/widgets/banner_carousel.dart';
import 'package:e_commerce/features/dashboard/widgets/category_list.dart';
import 'package:e_commerce/features/dashboard/widgets/recommended_items.dart';
import 'package:e_commerce/features/dashboard/widgets/top_items_grid.dart';
import 'package:flutter/material.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().background,
      appBar: AppBar(
        backgroundColor: AppColors().primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _greetingAndSearch(context),
            const SizedBox(height: 10),
            const BannerCarousel(),
            const CategoryList(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(AppStrings.topItems,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const TopItemsGrid(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(AppStrings.recommended,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const RecommendedItems(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors().primary,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _greetingAndSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("${AppStrings.welcome} 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}
