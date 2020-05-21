import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/Item/item_bloc.dart';
import 'package:inventory/bloc/app/app_events.dart';
import 'package:inventory/bloc/app/app_states.dart';
import 'package:inventory/bloc/auth/auth_bloc.dart';
import 'package:inventory/bloc/auth/auth_events.dart';
import 'package:inventory/services/api/auth_service.dart';
import 'package:inventory/services/api/item_service.dart';
import 'package:inventory/services/api/location_service.dart';

class AppBloc extends Bloc<AppEvent, AppState> with ChangeNotifier {
  final AuthBloc _authBloc;
  final ItemBloc _itemBloc;

  AppBloc(this._authBloc, this._itemBloc);

  @override
  AppState get initialState => InitAppState();

  AuthBloc get authBloc => _authBloc;

  ItemBloc get itemBloc => _itemBloc;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is FetchItemsAppEvent) {
      yield FetchItemsAppState();
    } else if (event is ChangeAppearanceEvent) {
      yield ChangeAppearanceState();
    } else if (event is InitAppEvent) {
      yield InitAppState();
    } else if (event is IdleAppEvent) {
      yield IdleAppState();
    } else
      throw UnimplementedError();
  }
}
