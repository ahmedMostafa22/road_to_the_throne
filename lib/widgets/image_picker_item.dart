import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePickerItem extends StatelessWidget {
  const ImagePickerItem(
      {Key? key,
      required this.icon,
      required this.text,
      required this.function})
      : super(key: key);
  final IconData icon;
  final String text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: CupertinoButton(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
          onPressed: () => function()),
    );
  }
}
