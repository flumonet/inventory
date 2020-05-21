import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:inventory/bloc/auth/auth_events.dart';
import 'package:inventory/bloc/auth/auth_states.dart';
import 'package:inventory/services/api/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with ChangeNotifier{

  final AuthService _authService ;

  AuthBloc(this._authService) {
    _setTimeoutListening();
  }

  AuthService get authService {
    return _authService;
  }

  Stream<void> _isTimeout;
  StreamSubscription<void> isTimeoutSubscription;

  @override
  void dispose() {
    isTimeoutSubscription.cancel();
    super.dispose();
  }

  @override
  get initialState => AuthInitialState();

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {

    if (event is WaitScreenEvent) {
      yield WaitingState();
    } else if (event is AuthAutoLoginEvent) {
      yield* _autoLogin();
    } else if (event is AuthInputEvent) {
      yield AuthInputState();
    } else if (event is AuthLogoutEvent) {
      yield* _authLogout();
    }
  }


  Stream<AuthState> _autoLogin() async* {
    yield WaitingState();
    try {
      var _autoLogged = await _authService.autoLogin();
      yield _autoLogged ? AuthLoggedState() : AuthInputState();
    } catch (e) {
      yield AuthErrorState(e);
    }
  }

  Stream<AuthState> _authLogout() async* {
    yield WaitingState();
    try {
       await _authService.logout();
      yield AuthInitialState();
    } catch (e) {
      yield AuthErrorState(e);
    }
  }

  void _setTimeoutListening() {
    _isTimeout = _authService.isTimeoutStream;
    isTimeoutSubscription = _isTimeout.listen((event) {
      add(AuthInputEvent());
    });
  }
}
