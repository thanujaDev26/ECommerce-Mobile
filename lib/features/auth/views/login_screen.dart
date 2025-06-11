import 'package:flutter/material.dart';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;  // For password eye toggle

  void _loginUser() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _loginWithGoogle() {
    // TODO: Implement Google login logic here
    print('Google login pressed');
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors().primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome to Ceylona!',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue to your Shopping Journey',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Card container for inputs
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    elevation: 8,
                    shadowColor: themeColor.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 30),
                      child: Column(
                        children: [
                          // Email
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon:
                              Icon(Icons.email_outlined, color: themeColor),
                              labelText: 'Email',
                              labelStyle:
                              TextStyle(color: themeColor.withOpacity(0.8)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                BorderSide(color: themeColor.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: themeColor, width: 2),
                              ),
                            ),
                            cursorColor: themeColor,
                          ),
                          const SizedBox(height: 24),

                          // Password with eye toggle
                          TextField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon:
                              Icon(Icons.lock_outline, color: themeColor),
                              labelText: 'Password',
                              labelStyle:
                              TextStyle(color: themeColor.withOpacity(0.8)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                BorderSide(color: themeColor.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: themeColor, width: 2),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: themeColor.withOpacity(0.6),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            cursorColor: themeColor,
                          ),
                          const SizedBox(height: 32),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _loginUser,
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
                                'Login',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: SignInButton(
                                Buttons.Google,
                                onPressed: _loginWithGoogle,
                                padding: EdgeInsets.symmetric(horizontal: 24),
                              ),
                            ),
                          ),


                          const SizedBox(height: 16),

                          // Register text
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: themeColor,
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            child: const Text("Don't have an account? Register"),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Optional: Forgot password link (professional touch)
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: themeColor.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
