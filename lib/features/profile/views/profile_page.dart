import 'package:e_commerce/features/profile/widgets/account_settings.dart';
import 'package:e_commerce/features/profile/widgets/activity_log.dart';
import 'package:e_commerce/features/profile/widgets/payment_history.dart';
import 'package:e_commerce/features/profile/widgets/payment_methods.dart';
import 'package:e_commerce/features/profile/widgets/profile_overview.dart';
import 'package:e_commerce/features/profile/widgets/security_settings.dart';
import 'package:e_commerce/features/profile/widgets/sidebar_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;

  final List<Widget> _actions = const [
    ProfileOverview(),
    AccountSettings(),
    SecuritySettings(),
    PaymentMethods(),
    PaymentHistory(),
    ActivityLog(),
  ];

  final List<String> _titles = const [
    "Profile Overview",
    "Account Settings",
    "Security Settings",
    "Payment Methods",
    "Payment History",
    "Activity Log",
  ];

  void _onSelectSection(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarMenu(
            selectedIndex: selectedIndex,
            onTap: _onSelectSection,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _titles[selectedIndex],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: _actions[selectedIndex])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
