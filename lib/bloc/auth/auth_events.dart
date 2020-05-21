import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
// ignore: missing_return
  List<Object> get props {}
}

class AuthAutoLoginEvent extends AuthEvent {
  @override
  String toString() => 'AuthAutoLoginEvent';
}

class WaitScreenEvent extends AuthEvent {
  @override
  String toString() => 'WaitScreenEvent';
}

class AuthLogoutEvent extends AuthEvent {
  @override
  String toString() => 'AuthLogoutEvent';
}

class AuthInputEvent extends AuthEvent {
  @override
  String toString() => 'AuthInputEvent';
}

