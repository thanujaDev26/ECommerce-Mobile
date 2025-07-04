import 'dart:convert';

import 'package:e_commerce/features/auth/views/password_changer.dart';
import 'package:e_commerce/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:http/http.dart' as http;


class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String otpCode = "";
  bool isVerifying = false;

  void _verifyOtp() async {
    if (otpCode.length < 6) {
      CustomSnackbar.show(
        context,
        message: 'Please enter the full 6-digit OTP',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }
    setState(() => isVerifying = true);
    try {
      final response = await http.post(
        Uri.parse('http://172.20.10.2:3001/api/v1/otp/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp': otpCode,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordChanger(
              email: widget.email,
              otp: otpCode,
            ),
          ),
        );
      } else {
        CustomSnackbar.show(
          context,
          message: 'OTP Verification failed',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } catch (e) {
      debugPrint('OTP Verification Error: $e');
      CustomSnackbar.show(
        context,
        message: 'Error: ${e}',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() => isVerifying = false);
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
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Enter the OTP sent to\n',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: themeColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                            TextSpan(
                              text: widget.email,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: themeColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // OTP input field
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        onChanged: (value) => setState(() => otpCode = value),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 50,
                          fieldWidth: 45,
                          activeColor: themeColor,
                          selectedColor: themeColor.withOpacity(0.7),
                          inactiveColor: themeColor.withOpacity(0.3),
                        ),
                        cursorColor: themeColor,
                      ),

                      const SizedBox(height: 32),

                      // Verify OTP button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isVerifying ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                          ),
                          child: isVerifying
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                              : const Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Resend OTP
                      TextButton(
                        onPressed: () {
                          // TODO: Resend OTP logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('OTP resent')),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: themeColor,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: const Text('Resend OTP'),
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
