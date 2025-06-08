import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentUiScreen extends StatefulWidget {
  const PaymentUiScreen({super.key});
  @override
  State<PaymentUiScreen> createState() => _PaymentDashboardState();
}

class _PaymentDashboardState extends State<PaymentUiScreen> {
  String selectedPaymentMethod = "Credit Card";
  final primaryColor = AppColors().primary;
  final TextEditingController couponController = TextEditingController();

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  String couponMessage = "";
  bool isCvvObscured = true;
  bool isLoading = false;
  double totalAmount = 1000;
  double discountPercent = 0;

  bool get isFormValid {
    return _validateCardNumber(cardNumberController.text) &&
        _validateExpiry(expiryController.text) &&
        _validateCvv(cvvController.text);
  }

  bool _validateCardNumber(String input) {
    return RegExp(r'^\d{16}$').hasMatch(input);
  }

  bool _validateExpiry(String input) {

    return RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(input);
  }

  bool _validateCvv(String input) {
    return RegExp(r'^\d{3,4}$').hasMatch(input);
  }

  void _redeemCoupon() {
    setState(() {
      if (couponController.text.trim().isEmpty) {
        couponMessage = "Please enter a coupon code.";
        discountPercent = 0;
      } else {
        if (couponController.text.trim().toLowerCase() == "flutter50") {
          couponMessage = "Coupon applied! You got 50% off.";
          discountPercent = 50;
        } else {
          couponMessage = "Invalid coupon code.";
          discountPercent = 0;
        }
      }
    });
  }

  void _onPayNow() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields correctly.")),
      );
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment processed successfully!")),
    );
  }

  double get finalAmount {
    return totalAmount * (1 - discountPercent / 100);
  }

  @override
  void dispose() {
    couponController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Payment"),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Amount Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor.withOpacity(0.9), primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    offset: const Offset(0, 8),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Rs. ${finalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Select Payment Method",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _paymentMethodButton("Credit/Debit", "assets/CrediCard.png"),
                _paymentMethodButton("Cash On Delivery", "assets/cash-on-delivery.png"),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Sponsored",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 6),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage("assets/banners/add.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),


            Text(
              "Have a Coupon?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: couponController,
                    decoration: InputDecoration(
                      hintText: "Enter coupon code",
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _redeemCoupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Redeem",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (couponMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  couponMessage,
                  style: TextStyle(
                    color: couponMessage.contains("Invalid") ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Payment Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 6),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField("Card Number", TextInputType.number,
                      controller: cardNumberController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "Expiry Date (MM/YY)",
                          TextInputType.datetime,
                          controller: expiryController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          "CVV",
                          TextInputType.number,
                          obscure: isCvvObscured,
                          controller: cvvController,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isCvvObscured ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                isCvvObscured = !isCvvObscured;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : _onPayNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 10,
                  shadowColor: primaryColor.withOpacity(0.7),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  "Pay Now",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodButton(String method, String assetPath) {
    bool isSelected = selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 168,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: primaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              assetPath,
              width: 50,
              height: 50,
              // color: isSelected ? Colors.white : null,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField(
      String label,
      TextInputType keyboardType, {
        bool obscure = false,
        TextEditingController? controller,
        Widget? suffixIcon,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
