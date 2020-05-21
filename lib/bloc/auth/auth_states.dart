import 'package:equatable/equatable.dart';

abstract class  AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class AuthInitialState extends AuthState {}

class AuthInputState extends AuthState {}

class AuthLoggedState extends AuthState {}

class WaitingState extends AuthState {}

class AuthErrorState extends AuthState {
  final Exception error;

  AuthErrorState(this.error);
  @override
  String toString() => 'AuthErrorState: $error';
}

