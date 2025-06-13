import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/features/auth/views/forgot_password_screen.dart';
import 'package:e_commerce/features/auth/views/login_screen.dart';
import 'package:e_commerce/features/auth/views/otp_verification_screen.dart';
import 'package:e_commerce/features/auth/views/password_changer.dart';
import 'package:e_commerce/features/auth/views/register_screen.dart';
import 'package:e_commerce/features/flash/views/flash_screen.dart';
import 'package:e_commerce/features/notifications/views/noitifications_page.dart';
import 'package:e_commerce/features/onboarding/views/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/features/dashboard/views/dashboard_screen.dart';
import 'package:e_commerce/features/categories/views/categories_list.dart';
import 'package:e_commerce/features/cart/views/cart_page.dart';
import 'package:e_commerce/features/profile/views/profile_page.dart';
import 'package:e_commerce/features/categories/catgories_pages/handcrafts.dart';
import 'package:e_commerce/features/categories/catgories_pages/spices.dart';
import 'package:e_commerce/features/categories/catgories_pages/herbal.dart';
import 'package:e_commerce/features/categories/catgories_pages/clay_pots.dart';
import 'package:e_commerce/features/categories/catgories_pages/tea.dart';
import 'package:e_commerce/features/payment/views/payment_ui_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  runApp(ECommerceAppRoot());
}

class ECommerceAppRoot extends StatefulWidget {
  const ECommerceAppRoot({super.key,});

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
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8D6E63),
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
        '/notifications':(context) => const NotificationsPage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/change-password':(context) => const PasswordChanger(email: "", otp: ""),
      },
      home: SplashScreen(isDarkMode: isDarkMode, onThemeChanged: _toggleTheme),
    );
  }
}
