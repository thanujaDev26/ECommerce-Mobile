import 'package:flutter/material.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextField(decoration: InputDecoration(labelText: "Username")),
        TextField(decoration: InputDecoration(labelText: "Email")),
        TextField(obscureText: true, decoration: InputDecoration(labelText: "New Password")),
        ElevatedButton(onPressed: () {}, child: const Text("Save Changes"))
      ],
    );
  }
}