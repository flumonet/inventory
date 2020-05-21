import 'package:equatable/equatable.dart';

abstract class  AppState extends Equatable {
  AppState([List props = const []]) : super(props);
}

class InitAppState extends AppState {}

class IdleAppState extends AppState {}

class FetchItemsAppState extends AppState {}

class ChangeAppearanceState extends AppState {}

class WaitingState extends AppState {}



class AppErrorState extends AppState {
  final Exception error;

  AppErrorState(this.error);
  @override
  String toString() => 'AppErrorState: $error';
}

