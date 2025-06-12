import 'dart:convert';

import 'package:e_commerce/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:http/http.dart' as http;

class PasswordChanger extends StatefulWidget {
  final String email;
  final String otp;
  const PasswordChanger({Key? key, required this.email, required this.otp}) : super(key: key);


  @override
  State<PasswordChanger> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<PasswordChanger> {
  final _formKey = GlobalKey<FormState>();
  String newPassword = "";
  String confirmPassword = "";
  bool isSubmitting = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  void _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.104:3001/api/v1/otp/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp': widget.otp,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        CustomSnackbar.show(
          context,
          message: 'Password updated successfully',
          backgroundColor: Colors.green,
          icon: Icons.error,
        );
        Navigator.pushNamed(context, "/login");
      } else {
        final data = jsonEncode(response.body);
        CustomSnackbar.show(
          context,
          message: 'Error in Password Re-creation',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Error: $e',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors().primary;

    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: themeColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 8,
                  shadowColor: themeColor.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Enter your new password',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: themeColor,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // New Password field
                          TextFormField(
                            obscureText: !showNewPassword,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showNewPassword ? Icons.visibility_off : Icons.visibility,
                                  color: themeColor,
                                ),
                                onPressed: () => setState(() => showNewPassword = !showNewPassword),
                              ),
                            ),
                            onChanged: (value) => newPassword = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a new password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Confirm Password field
                          TextFormField(
                            obscureText: !showConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: themeColor,
                                ),
                                onPressed: () => setState(() => showConfirmPassword = !showConfirmPassword),
                              ),
                            ),
                            onChanged: (value) => confirmPassword = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != newPassword) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isSubmitting ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                                  : const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
