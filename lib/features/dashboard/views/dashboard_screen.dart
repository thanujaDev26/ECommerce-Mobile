import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/app/constants/app_strings.dart';
import 'package:e_commerce/features/cart/views/cart_page.dart';
import 'package:e_commerce/features/categories/views/categories_list.dart';
import 'package:e_commerce/features/dashboard/widgets/banner_carousel.dart';
import 'package:e_commerce/features/dashboard/widgets/category_list.dart';
import 'package:e_commerce/features/dashboard/widgets/recommended_items.dart';
import 'package:e_commerce/features/dashboard/widgets/top_items_grid.dart';
import 'package:e_commerce/features/profile/views/profile_page.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CategoriesList(),
    CartPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().background,
      appBar: AppBar(
        backgroundColor: AppColors().primary,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        selectedItemColor: AppColors().primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 1:
        return "Categories";
      case 2:
        return "Cart";
      case 3:
        return "Profile";
      default:
        return "Home";
    }
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
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
    );
  }

  Widget _greetingAndSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: const Text(
              "${AppStrings.welcome} 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(30),
            shadowColor: Colors.black12,
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
