import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const SidebarMenu({super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      'Profile',
      'Settings',
      'Security',
      'Payments',
      'History',
      'Activity'
    ];

    return Container(
      width: 200,
      color: Colors.grey.shade200,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            selected: selectedIndex == index,
            selectedTileColor: Colors.blue.shade100,
            title: Text(items[index]),
            onTap: () => onTap(index),
          );
        },
      ),
    );
  }
}
