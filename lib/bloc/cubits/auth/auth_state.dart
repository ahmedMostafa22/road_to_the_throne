part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class SignedOutState extends AuthState {}

class SignedInState extends AuthState {}

class AuthLoadingState extends AuthState {}
