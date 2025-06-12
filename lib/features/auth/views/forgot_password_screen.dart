import 'dart:convert';

import 'package:e_commerce/features/auth/views/otp_verification_screen.dart';
import 'package:e_commerce/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;

  void _sendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      CustomSnackbar.show(
        context,
        message: 'Please enter your email',
        backgroundColor: Colors.red,
        icon: Icons.check_circle,
      );

      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://172.20.10.3:3001/api/v1/otp/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email}),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        CustomSnackbar.show(
          context,
          message: "The OTP has been sent to your email",
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpVerificationScreen(email: email)),
        );
      } else {
        final data = jsonDecode(response.body);
        CustomSnackbar.show(
          context,
          message: data['message'],
          backgroundColor: Colors.red,
          icon: Icons.check_circle,
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      CustomSnackbar.show(
        context,
        message: 'Error sending OTP. Please try again later.',
        backgroundColor: Colors.red,
        icon: Icons.check_circle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors().primary;

    return Scaffold(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter your email to receive an OTP',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: themeColor,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Email input
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined, color: themeColor),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: themeColor.withOpacity(0.8)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: themeColor.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: themeColor, width: 2),
                          ),
                        ),
                        cursorColor: themeColor,
                      ),

                      const SizedBox(height: 32),

                      // Send OTP button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                          ),
                          child: isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                              : const Text(
                            'Send OTP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Back to login button
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: themeColor,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: const Text('Back to Login'),
                      ),
                    ],
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
