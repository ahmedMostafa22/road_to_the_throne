import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
   const Empty(this.emptyMessage, {Key? key}) : super(key: key);

  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Text(emptyMessage,
        style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }
}
