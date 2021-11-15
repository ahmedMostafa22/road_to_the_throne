import 'package:flutter/material.dart';

class AppBarHeaderItem extends StatelessWidget {
  const AppBarHeaderItem(
      {Key? key,
      required this.text,
      required this.icon,
      required this.fontSize})
      : super(key: key);
  final String text;
  final IconData icon;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              icon,
              size: 50,
              color: Theme.of(context).primaryColor,
            )),
        const SizedBox(height: 8),
        Text(text, style: TextStyle(color: Colors.white, fontSize: fontSize))
      ],
    );
  }
}
