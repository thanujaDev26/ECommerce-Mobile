import 'dart:async';
import 'package:e_commerce/features/auth/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/features/dashboard/views/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SplashScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<Map<String, String>> splashData = [
    {'image': 'assets/demo_images/garayaka.png', 'text': 'Discover Unique Crafts'},
    {'image': 'assets/main_icon.png', 'text': 'Support Local Artisans'},
    {'image': 'assets/demo_images/wooden_elephant.png', 'text': 'Sustainable Living'},
    {'image': 'assets/main.png', 'text': 'Timeless Traditions'},
    // {'image': 'assets/demo_images/logo5.png', 'text': 'Ceylon Treasures'},
  ];

  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentIndex < splashData.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              // isDarkMode: widget.isDarkMode,
              // onThemeChanged: widget.onThemeChanged,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = splashData[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: Column(
            key: ValueKey(_currentIndex),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                currentItem['image']!,
                height: 120,
              ),
              const SizedBox(height: 30),
              Text(
                currentItem['text']!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
