import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formdator/formdator.dart';
import 'package:road_to_the_throne/bloc/cubits/auth/auth_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/image_picker/image_picker_cubit.dart';
import 'package:road_to_the_throne/constants/colors.dart';
import 'package:road_to_the_throne/screens/auth_screens/sign_in.dart';
import 'package:road_to_the_throne/widgets/app_btn.dart';
import 'package:road_to_the_throne/widgets/app_outlined_btn.dart';
import 'package:road_to_the_throne/widgets/app_textfield.dart';
import 'package:road_to_the_throne/widgets/image_picker.dart';
import 'package:road_to_the_throne/widgets/loading.dart';

class SignUp extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  SignUp({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text('Sign Up',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: AppColors.primaryColor)),
                const SizedBox(height: 32),
                const ImagePicker(),
                AppTextField(
                  controller: nameController,
                  label: 'Name',
                  validator: (n) =>
                      n!.isEmpty ? 'Please enter your name' : null,
                ),
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
                const SizedBox(height: 80),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return state is AuthLoadingState
                        ? const Loading()
                        : AppElevatedButton(false, 'Sign Up', () {
                            if (formKey.currentState!.validate() &&
                                context
                                    .read<ImagePickerCubit>()
                                    .state
                                    .image
                                    .path
                                    .isNotEmpty) {
                              BlocProvider.of<AuthCubit>(context).signUp(
                                  emailController.text,
                                  passwordController.text,
                                  nameController.text,
                                  BlocProvider.of<ImagePickerCubit>(context)
                                      .state
                                      .image,
                                  context);
                            }
                          }, .7);
                  },
                ),
                AppOutlinedButton(
                    false,
                    'Sign In',
                    () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (c) => SignIn())),
                    .7),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
