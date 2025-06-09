import 'package:flutter/material.dart';

class AppSidebar extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const AppSidebar({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  // Text(
                  //   "Thanuja",
                  //   style: TextStyle(
                  //     color: widget.isDarkMode ? Colors.white : Colors.black,
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // )
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      children: const [
                        TextSpan(text: 'Thanuja\n'),
                        TextSpan(
                          text: 'Priyadarshane',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            _buildDrawerItem(Icons.help_outline, "FAQ"),
            _buildDrawerItem(Icons.group, "Community"),
            _buildDrawerItem(Icons.phone, "Contact Us"),
            SwitchListTile(
              title: Text(
                widget.isDarkMode ? "Light Mode" : "Dark Mode",
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              secondary: Icon(
                widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              value: widget.isDarkMode,
              onChanged: widget.onThemeChanged,
            ),
            _buildDrawerItem(Icons.settings, "Settings"),
            Spacer(),
            Divider(),
            _buildDrawerItem(Icons.logout, "Logout"),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: widget.isDarkMode ? Colors.white : Colors.black),
      title: Text(
        label,
        style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
      ),
      onTap: () {
        // Handle navigation
        Navigator.pop(context);
      },
    );
  }
}
