import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClayPots extends StatefulWidget {
  const ClayPots({super.key});

  @override
  State<ClayPots> createState() => _ClayPotsState();
}

class _ClayPotsState extends State<ClayPots> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clay Pots'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text("Clay Pots"),
          ],
        ),
      ),
    );
  }
}
