import 'package:flutter/material.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          title: Text("Invoice #001"),
          subtitle: Text("April 10, 2024"),
          trailing: Text("LKR29.99"),
        ),
        ListTile(
          title: Text("Invoice #002"),
          subtitle: Text("May 10, 2024"),
          trailing: Text("LKR29.99"),
        ),
      ],
    );
  }
}