import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/auth/auth_cubit.dart';
import 'package:road_to_the_throne/constants/assets.dart';
import 'package:road_to_the_throne/screens/auth_screens/sign_in.dart';
import 'package:road_to_the_throne/screens/profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    BlocProvider.of<AuthCubit>(context).checkUserState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
        builder: (c, state) => state is AuthLoadingState
            ? Container(
                color: Theme.of(context).primaryColor,
                child: Image.asset(Assets.splash, color: Colors.white))
            : MediaQuery(
                child: state is SignedOutState ? SignIn() : const Profile(),
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1)));
  }
}
