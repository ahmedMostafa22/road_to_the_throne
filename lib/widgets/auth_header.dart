import 'package:flutter/material.dart';
import 'package:road_to_the_throne/constants/assets.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
            padding: const EdgeInsets.all(32),
            child: Image.asset(Assets.splash, color: Colors.white)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .3);
  }
}
