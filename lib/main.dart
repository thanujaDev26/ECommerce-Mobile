import 'package:e_commerce/features/cart/views/cart_page.dart';
import 'package:e_commerce/features/categories/views/categories_list.dart';
import 'package:e_commerce/features/categories/views/clay_pots.dart';
import 'package:e_commerce/features/categories/views/handcrafts.dart';
import 'package:e_commerce/features/categories/views/herbal.dart';
import 'package:e_commerce/features/categories/views/spices.dart';
import 'package:e_commerce/features/categories/views/tea.dart';
import 'package:e_commerce/features/dashboard/views/dashboard_screen.dart';
import 'package:e_commerce/features/profile/views/profile_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ECommerceMobileAPp());
}

class ECommerceMobileAPp extends StatelessWidget {
  const ECommerceMobileAPp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const DashboardScreen(),
        '/categories': (context) => const CategoriesList(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
        '/handcrafts': (context) => const Handcrafts(),
        '/spices': (context) => const Spices(),
        '/herbal': (context) => const Herbal(),
        '/claypots': (context) => const ClayPots(),
        '/beverages': (context) => const Tea(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const DashboardScreen(),
    );
  }
}


