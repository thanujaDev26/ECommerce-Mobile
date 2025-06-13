import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Handcrafts extends StatefulWidget {
  const Handcrafts({super.key});

  @override
  State<Handcrafts> createState() => _HandcraftsState();
}

class _HandcraftsState extends State<Handcrafts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HandCrafts'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text("HandCrafts"),
          ],
        ),
      ),
    );
  }
}
