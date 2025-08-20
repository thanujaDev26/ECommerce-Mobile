import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/app/utils/config.dart';
import 'package:e_commerce/features/cart/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentUiScreen extends StatefulWidget {
  const PaymentUiScreen({super.key});

  @override
  State<PaymentUiScreen> createState() => _PaymentUiScreenState();
}

class _PaymentUiScreenState extends State<PaymentUiScreen> {
  String selectedPaymentMethod = "";
  bool isLoading = false;

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<CartItem> cartItems = [];
  bool isCartLoading = true;

  double get subTotal => cartItems.fold(0.0, (sum, item) => sum + item.total);
  double get deliveryFee => cartItems.isEmpty ? 0.0 : 500.0;
  double get grandTotal => subTotal + deliveryFee;

  @override
  void initState() {
    super.initState();
    _loadCartTotal();
  }

  Future<void> _loadCartTotal() async {
    setState(() => isCartLoading = true);
    try {
      final items = await CartService.fetchCartItems();
      setState(() {
        cartItems = items;
        isCartLoading = false;
      });
    } catch (e) {
      setState(() => isCartLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load cart: $e")),
      );
    }
  }

  Future<void> _placeOrder(Map<String, dynamic> body) async {
    try {
      setState(() => isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("authToken");

      final response = await http.post(
        Uri.parse("$BASE_URL/api/v1/cart/checkout/confirm"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Checkout completed")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Checkout failed: ${response.body}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _onPayNow() {
    if (selectedPaymentMethod == "Credit/Debit") {
      if (!_validateCardNumber(cardNumberController.text) ||
          !_validateExpiry(expiryController.text) ||
          !_validateCvv(cvvController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid card details.")),
        );
        return;
      }

      _placeOrder({
        "method": "card",
        "cardNumber": cardNumberController.text,
        "expiry": expiryController.text,
        "cvv": cvvController.text,
        "amount": grandTotal,
      });
    } else if (selectedPaymentMethod == "Cash On Delivery") {
      if (nameController.text.isEmpty ||
          addressController.text.isEmpty ||
          phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all delivery details.")),
        );
        return;
      }

      _placeOrder({
        "method": "cod",
        "name": nameController.text,
        "address": addressController.text,
        "phone": phoneController.text,
        "amount": grandTotal,
      });
    }
  }

  bool _validateCardNumber(String input) {
    return RegExp(r'^(\d{4} \d{4} \d{4} \d{4})$').hasMatch(input);
  }

  bool _validateExpiry(String input) {
    try {
      final parts = input.split('/');
      final month = int.parse(parts[0]);
      final year = int.parse('20' + parts[1]);
      final now = DateTime.now();
      final expiryDate = DateTime(year, month + 1, 0);
      return expiryDate.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  bool _validateCvv(String input) => RegExp(r'^\d{3}$').hasMatch(input);

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors().primary;

    return GestureDetector(
      onTap: () {
        // This will hide the keyboard if user taps outside TextField
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Payment"),
          backgroundColor: primaryColor,
          centerTitle: true,
        ),
        body: isCartLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _summaryCard(),
                      const SizedBox(height: 25),
                      const Text(
                        "Select Payment Method",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          _paymentMethodButton(
                              "Credit/Debit", "assets/CrediCard.png"),
                          _paymentMethodButton("Cash On Delivery",
                              "assets/cash-on-delivery.png"),
                        ],
                      ),
                      const SizedBox(height: 30),
                      if (selectedPaymentMethod == "Credit/Debit")
                        _buildCardForm(),
                      if (selectedPaymentMethod == "Cash On Delivery")
                        _buildDeliveryForm(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: ElevatedButton(
            onPressed: isLoading ? null : _onPayNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: isLoading
                ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : const Text(
              "Confirm Order",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }


  Widget _summaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _summaryRow("Subtotal", subTotal),
            _summaryRow("Delivery Fee", deliveryFee),
            const Divider(),
            _summaryRow("Grand Total", grandTotal, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double amount, {bool isBold = false}) {
    final style = isBold
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        : const TextStyle(fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text("LKR. ${amount.toStringAsFixed(2)}", style: style)
        ],
      ),
    );
  }

  Widget _paymentMethodButton(String label, String assetPath) {
    final theme = Theme.of(context);
    final isSelected = selectedPaymentMethod == label;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors().primary : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color:
              isSelected ? AppColors().primary : Colors.grey.shade300,
              width: 2),
          boxShadow: isSelected
              ? [
            BoxShadow(
                color: AppColors().primary.withOpacity(0.3),
                blurRadius: 10)
          ]
              : [],
        ),
        child: Column(
          children: [
            Image.asset(assetPath, height: 50),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Column(
      children: [
        TextField(
          controller: cardNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberInputFormatter(),
          ],
          decoration: InputDecoration(
            labelText: "Card Number",
            hintText: "xxxx xxxx xxxx xxxx",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: expiryController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Expiry Date",
                  hintText: "MM/YY",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onTap: () async {
                  DateTime now = DateTime.now();
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: DateTime(now.year, now.month),
                    firstDate: DateTime(now.year, now.month),
                    lastDate: DateTime(now.year + 20),
                    helpText: 'Select Expiry Date',
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                              primary: AppColors().primary),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (selected != null) {
                    expiryController.text =
                    "${selected.month.toString().padLeft(2, '0')}/${selected.year.toString().substring(2)}";
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "CVV",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryForm() {
    return Column(
      children: [
        _inputField(nameController, "Full Name", TextInputType.name),
        const SizedBox(height: 12),
        _inputField(
            addressController, "Delivery Address", TextInputType.streetAddress),
        const SizedBox(height: 12),
        _inputField(phoneController, "Phone Number", TextInputType.phone),
      ],
    );
  }

  Widget _inputField(
      TextEditingController controller, String label, TextInputType type,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      keyboardType: type,
      obscureText: obscure,
    );
  }
}

// Custom input formatter for card number
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digitsOnly = newValue.text.replaceAll(' ', '');
    var newText = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i % 4 == 0 && i != 0) newText += ' ';
      newText += digitsOnly[i];
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
