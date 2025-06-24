import 'dart:ui';

import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/features/cart/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  bool isLoading = true;

  double get subTotal => cartItems.fold(0.0, (sum, item) => sum + item.total);
  double get deliveryFee => cartItems.isEmpty ? 0.0 : 500.0;
  double get discount => cartItems.fold(0.0, (sum, item) => sum + (item.discount * item.quantity));
  double get grandTotal => subTotal + deliveryFee;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => isLoading = true);
    try {
      print("🔄 Fetching cart...");
      final items = await CartService.fetchCartItems();
      print("✅ Cart loaded: ${items.length} items");

      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load cart: $e")));
    }
  }

  Future<void> _removeItem(String cartId) async {
    await CartService.deleteCartItem(cartId);
    await _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? Center(child: Text("Your cart is empty", style: theme.textTheme.titleMedium))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Dismissible(
                    key: ValueKey(item.cartId),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _removeItem(item.cartId),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                            child: item.image.isNotEmpty
                                ? Image.network(
                              item.image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              },
                            )
                                : Container(
                              height: 100,
                              width: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: theme.textTheme.titleMedium),
                                const SizedBox(height: 8),
                                Text('Rs. ${item.finalPrice.toStringAsFixed(2)} x ${item.quantity}'),
                                const SizedBox(height: 4),
                                Text('Total: Rs. ${item.total.toStringAsFixed(2)}'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _summaryRow("Subtotal", subTotal),
                _summaryRow("Discount", -discount),
                _summaryRow("Delivery", deliveryFee),
                Divider(),
                _summaryRow("Grand Total", grandTotal, isBold: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/payment");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Go to Checkout", style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF))),
                )
              ],
            )
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
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text("Rs. ${amount.toStringAsFixed(2)}", style: style),
        ],
      ),
    );
  }
}
