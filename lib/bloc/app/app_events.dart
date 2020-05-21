import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {

  @override
  // ignore: missing_return
  List<Object> get props {
  }
}

class FetchItemsAppEvent extends AppEvent {
  @override
  String toString() => 'FetchItemsAppEvent';
}

class ChangeAppearanceEvent extends AppEvent {
  @override
  String toString() => 'ChangeAppearanceEvent';
}


class InitAppEvent extends AppEvent {
  @override
  String toString() => 'InitAppEvent';
}

class IdleAppEvent extends AppEvent {
  @override
  String toString() => 'IdleAppEvent';
}
