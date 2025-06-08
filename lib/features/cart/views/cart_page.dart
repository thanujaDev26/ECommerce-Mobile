import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> cartItems = [
    {
      "name": "Handcrafted Vase",
      "image": "assets/categories/handcrafts.png",
      "price": 1200,
      "quantity": 1
    },
    {
      "name": "Organic Spices Pack",
      "image": "assets/categories/spices.png",
      "price": 800,
      "quantity": 2
    },
  ];

  int get totalPrice => cartItems.fold<int>(
    0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
  );
  void updateQuantity(int index, bool increment) {
    setState(() {
      if (increment) {
        cartItems[index]['quantity']++;
      } else if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Dismissible(
                    key: ValueKey(item['name'] + index.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: Color(0xFF490A06),
                          borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        cartItems.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['name']} removed from cart')),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(16)),
                            child: Image.asset(
                              item['image'],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Text('Rs. ${item['price']}',
                                    style: const TextStyle(
                                        color: Colors.grey)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () =>
                                          updateQuantity(index, false),
                                    ),
                                    Text('${item['quantity']}'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () =>
                                          updateQuantity(index, true),
                                    ),
                                  ],
                                )
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rs. $totalPrice",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/payment");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Go to Checkout",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: AppColors().primary),
                    ),
                    child: const Text(
                      "More Products",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
