import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:road_to_the_throne/helpers/firebase_storage.dart';
import 'package:road_to_the_throne/helpers/flutter_toast.dart';
import 'package:road_to_the_throne/screens/profile.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(SignedOutState());

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      FlutterToastHelper.showSuccessToast('Signed in successfully');
      emit(SignedInState());
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (c) => const Profile()));
    } catch (e) {
      emit(SignedOutState());
      FlutterToastHelper.showErrorToast('Incorrect email or password');
    }
  }

  Future<void> signUp(String email, String password, String name, File image,
      BuildContext context) async {
    emit(AuthLoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String imageUrl =
          await FirebaseStorageHelper.uploadFile(image, 'players_images');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'image': imageUrl,
        'name': name,
        'email': userCredential.user!.email,
        'favTeam': 'NA'
      });
      FlutterToastHelper.showSuccessToast('Signed up successfully');
      emit(SignedInState());
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (c) => const Profile()));
    } catch (e) {
      emit(SignedOutState());
      FlutterToastHelper.showErrorToast(e.toString());
    }
  }

  Future<void> checkUserState() async {
    emit(AuthLoadingState());
    bool signedIn = _checkUserSignedIn();
    print('is Signed In  ' + signedIn.toString());
    if (signedIn) {
      emit(SignedInState());
    } else {
      emit(SignedOutState());
    }
  }

  bool _checkUserSignedIn() => !(FirebaseAuth.instance.currentUser == null);
}
