import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Herbal extends StatefulWidget {
  const Herbal({super.key});

  @override
  State<Herbal> createState() => _HerbalState();
}

class _HerbalState extends State<Herbal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Herbal'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text("Herbal"),
          ],
        ),
      ),
    );
  }
}
