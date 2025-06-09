import 'package:flutter/material.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(title: Text("Two-Factor Authentication"), trailing: Switch(value: true, onChanged: null)),
        ListTile(title: Text("Login Activity"), subtitle: Text("Last login: 1 day ago")),
      ],
    );
  }
}
