import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const AppSidebar({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
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
            _buildDrawerItem(context, Icons.help_outline, "FAQ", isDarkMode),
            _buildDrawerItem(context, Icons.group, "Community", isDarkMode),
            _buildDrawerItem(context, Icons.phone, "Contact Us", isDarkMode),
            SwitchListTile(
              title: Text(
                isDarkMode ? "Light Mode" : "Dark Mode",
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              secondary: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              value: isDarkMode,
              onChanged: (value) {
                onThemeChanged(value);
              },
            ),
            _buildDrawerItem(context, Icons.settings, "Settings", isDarkMode),
            const Spacer(),
            const Divider(),
            _buildDrawerItem(
              context,
              Icons.logout,
              "Logout",
              isDarkMode,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context,
      IconData icon,
      String label,
      bool isDarkMode, {
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
      title: Text(
        label,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
      onTap: onTap ?? () {
        Navigator.pop(context);
      },
    );
  }
}
