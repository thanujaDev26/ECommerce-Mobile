import 'package:e_commerce/features/dashboard/views/dashboard_screen.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const DashboardScreen(),
    );
  }
}


