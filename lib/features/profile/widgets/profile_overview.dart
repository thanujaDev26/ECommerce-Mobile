import 'package:flutter/material.dart';

class ProfileOverview extends StatelessWidget {
  const ProfileOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/avatar.png')),
        SizedBox(height: 10),
        Text("John Doe"),
        Text("@john123"),
        Text("john@example.com"),
        Text("Role: User"),
        Text("Joined: Jan 2024"),
      ],
    );
  }
}