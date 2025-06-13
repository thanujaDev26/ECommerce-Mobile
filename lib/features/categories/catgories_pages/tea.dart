import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tea extends StatefulWidget {
  const Tea({super.key});

  @override
  State<Tea> createState() => _TeaState();
}

class _TeaState extends State<Tea> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tea'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text("Tea"),
          ],
        ),
      ),
    );
  }
}
