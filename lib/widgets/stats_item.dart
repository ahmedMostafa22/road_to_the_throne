import 'package:flutter/material.dart';

class StatisticsItem extends StatelessWidget {
  const StatisticsItem({Key? key, required this.t1, required this.t2})
      : super(key: key);
  final String t1, t2;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(t1,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      Text(t2,
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
    ]);
  }
}
