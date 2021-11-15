import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formdator/formdator.dart';
import 'package:road_to_the_throne/bloc/cubits/auth/auth_cubit.dart';
import 'package:road_to_the_throne/constants/colors.dart';
import 'package:road_to_the_throne/screens/auth_screens/sign_up.dart';
import 'package:road_to_the_throne/widgets/app_btn.dart';
import 'package:road_to_the_throne/widgets/app_outlined_btn.dart';
import 'package:road_to_the_throne/widgets/app_textfield.dart';
import 'package:road_to_the_throne/widgets/auth_header.dart';
import 'package:road_to_the_throne/widgets/loading.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const AuthHeader(),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: AppColors.primaryColor)),
                    const SizedBox(height: 32),
                    AppTextField(
                      controller: emailController,
                      label: 'Email',
                      validator: ReqEmail.len(
                        50,
                        blank: 'Please enter the email',
                        mal: 'Malformed email',
                        long: 'Email length cannot exceed 50 characters',
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: passwordController,
                      label: 'Password',
                      validator: Rules<String>([
                        const Req(blank: 'Password is too short'),
                        Len.min(6, short: 'Password is too short'),
                        Len.max(50, long: 'Password is too long'),
                      ]),
                    ),
                    const SizedBox(height: 64),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return state is AuthLoadingState
                            ? const Loading()
                            : AppElevatedButton(false, 'Sign In', () {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthCubit>(context).signIn(
                                      emailController.text,
                                      passwordController.text,
                                      context);
                                }
                              }, .7);
                      },
                    ),
                    const SizedBox(height: 16),
                    AppOutlinedButton(
                        false,
                        'Sign Up',
                        () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (c) => SignUp())),
                        .7)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
