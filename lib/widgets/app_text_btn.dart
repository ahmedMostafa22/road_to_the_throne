import 'package:flutter/material.dart';
import 'package:road_to_the_throne/constants/colors.dart';

import 'loading.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton(
      this.isLoading, this.text, this.function, this.widthFactor,
      {Key? key})
      : super(key: key);

  final bool isLoading;
  final String text;
  final Function function;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading(loadingMessage: 'Loading', size: 50)
        : FractionallySizedBox(
            widthFactor: widthFactor,
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () => function(),
                child: Text(
                  text,
                  style:const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                )));
  }
}
