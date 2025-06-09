import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Spices extends StatefulWidget {
  const Spices({super.key});

  @override
  State<Spices> createState() => _SpicesState();
}

class _SpicesState extends State<Spices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spices'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text("Spices"),
          ],
        ),
      ),
    );
  }
}
