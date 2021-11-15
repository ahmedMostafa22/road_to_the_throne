import 'package:road_to_the_throne/constants/assets.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget {
   const Error(this.errorMessage, {Key? key}) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(Assets.error),
        const SizedBox(height: 16),
        Text(
          errorMessage,
          style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
