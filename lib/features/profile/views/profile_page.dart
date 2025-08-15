import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/features/profile/service/user_profile_service.dart';
import 'package:e_commerce/features/profile/viewmodels/user_profile_model.dart';
import 'package:e_commerce/features/sidebar/service/user_avatar_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController =
  TextEditingController(text: "Thanuja Priyadarshane");
  final TextEditingController _emailController =
  TextEditingController(text: "thanujapriyadarshane26@gmail.com");
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  List<String> _paymentMethods = ["Visa **** 1234", "Mastercard **** 9876"];

  bool _twoFactorEnabled = false;

  UserProfileModel? userProfileModel;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initProfile();
  }

  Future<void> _initProfile() async {
    final model = await UserAvatarService.fetchUserAvatar();
    if (model != null) {
      setState(() {
        userProfileModel = UserProfileModel(
          id: model.id,
          fName: model.fName,
          lName: model.lName,
          email: model.email,
          avatar: model.avatar,
          mobile: null,
          addressLine: null,
          city: null,
          district: null,
          province: null,
          postalCode: null,
          sex: null,
          birthday: null,
          createdAt: null,
        );
        _usernameController.text = model.fullName;
        _emailController.text = model.email;
      });
    }
  }




  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      bool passwordChanged = true;

      // Only attempt password change if fields are filled
      if (_passwordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty) {
        passwordChanged = await UserProfileService.changePassword(
          currentPassword: _passwordController.text,
          newPassword: _newPasswordController.text,
        );

        if (!passwordChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to change password')),
          );
          return;
        }
      }



      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );


      _passwordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() {});
    }
  }


  void _addPaymentMethod() {
    setState(() {
      _paymentMethods.add("New Card **** ${1000 + _paymentMethods.length}");
    });
  }

  void _removePaymentMethod(int index) {
    setState(() {
      _paymentMethods.removeAt(index);
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userProfileModel?.avatar != null
                          ? NetworkImage(userProfileModel!.avatar!)
                          : null,
                      child: userProfileModel?.avatar == null
                          ? const Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProfileModel?.fullName ?? "Loading...",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(userProfileModel?.email ?? ""),
                          const SizedBox(height: 4),
                          Text(
                            userProfileModel?.createdAt != null
                                ? "Joined: ${userProfileModel!.createdAt!.substring(0, 10)}"
                                : "",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),

              _buildSectionTitle("Account Settings"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: "Username"),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Username cannot be empty";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ExpansionTile(
                  title: const Text("Change Password"),
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      decoration:
                      const InputDecoration(labelText: "Current Password"),
                      obscureText: true,
                      validator: (val) {
                        if (_newPasswordController.text.isNotEmpty ||
                            _confirmPasswordController.text.isNotEmpty) {
                          if (val == null || val.isEmpty) {
                            return "Enter current password";
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration:
                      const InputDecoration(labelText: "New Password"),
                      obscureText: true,
                      validator: (val) {
                        if (_passwordController.text.isNotEmpty ||
                            _confirmPasswordController.text.isNotEmpty) {
                          if (val == null || val.isEmpty) {
                            return "Enter new password";
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration:
                      const InputDecoration(labelText: "Confirm New Password"),
                      obscureText: true,
                      validator: (val) {
                        if (_newPasswordController.text.isNotEmpty) {
                          if (val != _newPasswordController.text) {
                            return "Passwords do not match";
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const Divider(height: 32),

              // Security Settings
              _buildSectionTitle("Security"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SwitchListTile(
                  title: const Text("Enable Two-Factor Authentication (2FA)"),
                  value: _twoFactorEnabled,
                  onChanged: (val) {
                    setState(() {
                      _twoFactorEnabled = val;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  title: const Text("Login History"),
                  subtitle: const Text("View recent login activity"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Show login history page or dialog
                  },
                ),
              ),
              const Divider(height: 32),

              // Payment Methods
              _buildSectionTitle("Payment Methods"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ..._paymentMethods.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final method = entry.value;
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.credit_card),
                          title: Text(method),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removePaymentMethod(idx),
                          ),
                        ),
                      );
                    }),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: 300,
                          child: ElevatedButton.icon(
                            onPressed: _addPaymentMethod,
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                              "Add Payment Method",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors().primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),

              // Payment History
              _buildSectionTitle("Payment History"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _paymentHistoryItem("Order #1234", "Paid \$29.99", "Mar 1, 2025"),
                    _paymentHistoryItem("Order #9876", "Paid \$15.49", "Feb 15, 2025"),
                    _paymentHistoryItem("Order #5432", "Paid \$10.00", "Jan 20, 2025"),
                  ],
                ),
              ),
              const Divider(height: 32),

              // Activity Logs
              _buildSectionTitle("Activity Logs"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.login),
                      title: Text("Logged in from iPhone 12"),
                      subtitle: Text("Mar 5, 2025 - 8:00 AM"),
                    ),
                    ListTile(
                      leading: Icon(Icons.lock),
                      title: Text("Changed password"),
                      subtitle: Text("Feb 28, 2025 - 7:45 PM"),
                    ),
                    ListTile(
                      leading: Icon(Icons.payment),
                      title: Text("Added new payment method"),
                      subtitle: Text("Feb 20, 2025 - 5:30 PM"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentHistoryItem(String title, String subtitle, String date) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(date, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
