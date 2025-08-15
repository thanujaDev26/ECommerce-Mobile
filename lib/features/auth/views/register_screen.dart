import 'dart:convert';
import 'dart:io';
import 'package:e_commerce/app/utils/config.dart';
import 'package:e_commerce/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileController = TextEditingController();
  final address1Controller = TextEditingController();
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

  // --- avatar picking ---
  final ImagePicker _picker = ImagePicker();
  XFile? _avatar;

  Future<void> _pickAvatar() async {
    final img = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (img == null) return;

    final file = File(img.path);
    final bytes = await file.length();
    if (bytes > 5 * 1024 * 1024) {
      CustomSnackbar.show(context, message: 'Max file size is 5MB', backgroundColor: Colors.red, icon: Icons.warning_rounded);
      return;
    }


    setState(() => _avatar = img);
  }

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
    if (picked != null) setState(() => birthday = picked);
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final url = Uri.parse('$BASE_URL/api/v1/auth/register');
      final req = http.MultipartRequest('POST', url);


      req.fields.addAll({
        "fName": firstNameController.text.trim(),
        "lName": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "confirmPassword": confirmPasswordController.text,
        "mobile": mobileController.text.trim(),
        "address_line": address1Controller.text.trim(),
        "city": cityController.text.trim(),
        "district": selectedDistrict ?? '',
        "province": selectedProvince ?? '',
        "postalCode": postalCodeController.text.trim(),
        "sex": gender ?? '',
        if (birthday != null) "birthday": DateFormat('yyyy-MM-dd').format(birthday!),
      });


      if (_avatar != null) {
        String mimeType = 'image/jpeg';
        final ext = p.extension(_avatar!.path).toLowerCase();

        if (ext == '.png') mimeType = 'image/png';
        else if (ext == '.webp') mimeType = 'image/webp';
        else if (ext == '.heic' || ext == '.heif') mimeType = 'image/heic';

        req.files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            _avatar!.path,
            filename: p.basename(_avatar!.path),
            contentType: MediaType('image', mimeType.split('/')[1]),
          ),
        );
      }

      final streamed = await req.send();
      final response = await http.Response.fromStream(streamed);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        CustomSnackbar.show(
          context,
          message: data['message'] ?? 'Registration Successful!',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        CustomSnackbar.show(
          context,
          message: data['message'] ?? 'Registration failed',
          backgroundColor: Colors.red,
          icon: Icons.warning_rounded,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Something went wrong!',
        backgroundColor: Colors.red,
        icon: Icons.warning_rounded,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = AppColors().primary;

    return Scaffold(
      appBar: AppBar(backgroundColor: themeColor),
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
                  // ---- Avatar section ----
                  _buildSectionTitle('Profile Photo'),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _avatar != null ? FileImage(File(_avatar!.path)) : null,
                        child: _avatar == null
                            ? const Icon(Icons.person, size: 36, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _pickAvatar,
                        icon: const Icon(Icons.photo),
                        label: const Text('Choose Photo'),
                      ),
                      if (_avatar != null) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => setState(() => _avatar = null),
                          child: const Text('Remove'),
                        ),
                      ]
                    ],
                  ),

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
                        icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
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
                        icon: Icon(isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible),
                      ),
                    ),
                    validator: (v) => v == passwordController.text ? null : 'Passwords do not match',
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
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
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
