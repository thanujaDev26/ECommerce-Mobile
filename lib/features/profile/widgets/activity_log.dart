import 'package:flutter/material.dart';

class ActivityLog extends StatelessWidget {
  const ActivityLog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(title: Text("Logged in from Chrome, Colombo, Sri Lanka")),
        ListTile(title: Text("Changed password")),
        ListTile(title: Text("Removed payment method")),
      ],
    );
  }
}
