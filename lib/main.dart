import 'package:flutter/material.dart';
import 'package:e_commerce/features/dashboard/views/dashboard_screen.dart';
import 'package:e_commerce/features/categories/views/categories_list.dart';
import 'package:e_commerce/features/cart/views/cart_page.dart';
import 'package:e_commerce/features/profile/views/profile_page.dart';
import 'package:e_commerce/features/categories/views/handcrafts.dart';
import 'package:e_commerce/features/categories/views/spices.dart';
import 'package:e_commerce/features/categories/views/herbal.dart';
import 'package:e_commerce/features/categories/views/clay_pots.dart';
import 'package:e_commerce/features/categories/views/tea.dart';
import 'package:e_commerce/features/payment/views/payment_ui_screen.dart';

void main() {
  runApp(ECommerceAppRoot());
}

class ECommerceAppRoot extends StatefulWidget {
  const ECommerceAppRoot({super.key});

  @override
  State<ECommerceAppRoot> createState() => _ECommerceAppRootState();
}

class _ECommerceAppRootState extends State<ECommerceAppRoot> {
  bool isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      routes: {
        '/home': (context) => DashboardScreen(
          isDarkMode: isDarkMode,
          onThemeChanged: _toggleTheme,
        ),
        '/categories': (context) => const CategoriesList(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
        '/handcrafts': (context) => const Handcrafts(),
        '/spices': (context) => const Spices(),
        '/herbal': (context) => const Herbal(),
        '/claypots': (context) => const ClayPots(),
        '/beverages': (context) => const Tea(),
        '/foods': (context) => const Tea(),
        '/payment': (context) => const PaymentUiScreen(),
      },
      home: DashboardScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}
