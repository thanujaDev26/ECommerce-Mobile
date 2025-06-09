import 'package:flutter/material.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.credit_card),
          title: Text("**** **** **** 1234"),
          trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {}),
        ),
        ElevatedButton(onPressed: () {}, child: const Text("Add Payment Method"))
      ],
    );
  }
}