import 'package:flutter/material.dart';
import 'package:road_to_the_throne/constants/colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {Key? key, required this.label, required this.validator, this.controller})
      : super(key: key);
  final String label;
  final TextEditingController? controller;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: AppColors.primaryColor),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColor))));
  }
}
