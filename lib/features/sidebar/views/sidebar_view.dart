import 'package:e_commerce/features/dashboard/services/user_service.dart';
import 'package:e_commerce/features/dashboard/viewmodels/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late bool _currentDarkMode;
  String? _token;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    _currentDarkMode = widget.isDarkMode;
    _loadToken();
    _loadUserProfile();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('authToken');
    });
    debugPrint("JWT Token: $_token");
  }

  Future<void> _loadUserProfile() async {
    final model = await UserService.fetchUser();
    if (model != null) {
      final fullName = model.name.trim();
      final nameParts = fullName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';
      setState(() {
        userProfile = UserProfile.fromUserModel(model);
      });
    }
  }

  String _getFirstName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : '';
  }

  String _getLastName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length > 1) {
      return parts.sublist(1).join(' ');
    }
    return '';
  }


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
                  userProfile == null ? const CircularProgressIndicator() :
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(text: _getFirstName(userProfile!.name) + '\n'),
                        TextSpan(
                          text: _getLastName(userProfile!.name),
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
                _currentDarkMode ? "Light Mode" : "Dark Mode",
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              secondary: Icon(
                _currentDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              value: _currentDarkMode,
              onChanged: (value) {
                setState(() {
                  _currentDarkMode = value;
                });
                widget.onThemeChanged(value);
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
              onTap: () async{
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('authToken');
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
