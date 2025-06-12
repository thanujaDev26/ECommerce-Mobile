import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  Future<void> _registerUser() async {
    final url = Uri.parse('http://172.20.10.3:3001/api/v1/auth/register');

    final body = {
      "fName": firstNameController.text,
      "lName": lastNameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "confirmPassword": confirmPasswordController.text,
      "mobile": mobileController.text,
      "address_line": address1Controller.text,
      "city": cityController.text,
      "district": selectedDistrict,
      "province": selectedProvince,
      "postalCode": postalCodeController.text,
      "sex": gender,
      "birthday": birthday != null ? DateFormat('yyyy-MM-dd').format(birthday!) : null,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileController = TextEditingController();
  final address1Controller = TextEditingController();
  // final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();

  String? selectedDistrict;
  String? selectedProvince;
  String? gender;
  DateTime? birthday;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final districts = [
    'Ampara', 'Anuradhapura', 'Badulla', 'Batticaloa', 'Colombo',
    'Galle', 'Gampaha', 'Hambantota', 'Jaffna', 'Kalutara',
    'Kandy', 'Kegalle', 'Kilinochchi', 'Kurunegala', 'Mannar',
    'Matale', 'Matara', 'Monaragala', 'Mullaitivu', 'Nuwara Eliya',
    'Polonnaruwa', 'Puttalam', 'Ratnapura', 'Trincomalee', 'Vavuniya'
  ];

  final provinces = [
    'Central', 'Eastern', 'North Central', 'Northern', 'North Western',
    'Sabaragamuwa', 'Southern', 'Uva', 'Western'
  ];

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'At least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include at least 1 uppercase';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include at least 1 number';
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = birthday ?? DateTime(2000);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => birthday = picked);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors().primary;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Personal Information'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: _inputDecoration('First Name'),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: _inputDecoration('Last Name'),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('Email'),
                    validator: (v) => v!.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: _inputDecoration('Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => isPasswordVisible = !isPasswordVisible),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: const Text(
                      'Use at least 8 characters, 1 uppercase letter, and 1 number.',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    decoration: _inputDecoration('Confirm Password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(() =>
                        isConfirmPasswordVisible = !isConfirmPasswordVisible),
                      ),
                    ),
                    validator: (v) => v == passwordController.text
                        ? null
                        : 'Passwords do not match',
                  ),

                  _buildSectionTitle('Contact Details'),
                  TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration('Mobile Number'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: address1Controller,
                    decoration: _inputDecoration('Address Line 1'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: cityController,
                    decoration: _inputDecoration('City'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration('District'),
                    value: selectedDistrict,
                    items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (v) => setState(() => selectedDistrict = v),
                    validator: (v) => v == null ? 'Select a district' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Province'),
                    value: selectedProvince,
                    items: provinces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                    onChanged: (v) => setState(() => selectedProvince = v),
                    validator: (v) => v == null ? 'Select a province' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: postalCodeController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Postal Code'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),

                  _buildSectionTitle('Other'),
                  Row(children: [
                    const Text('Gender: ', style: TextStyle(fontWeight: FontWeight.w500)),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: gender,
                        onChanged: (v) => setState(() => gender = v),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: gender,
                        onChanged: (v) => setState(() => gender = v),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: _inputDecoration('Birthday'),
                      child: Text(
                        birthday == null
                            ? 'Select your birthday'
                            : DateFormat('yyyy-MM-dd').format(birthday!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _registerUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Register', style: TextStyle(fontSize: 18,color: Colors.white),),
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
