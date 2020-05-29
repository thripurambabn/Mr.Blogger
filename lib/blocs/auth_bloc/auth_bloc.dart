import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_state.dart';
import 'package:mr_blogger/service/user_service.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserService _userService;

  AuthenticationBloc({@required UserService userService})
      : assert(userService != null),
        _userService = userService;

  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = await _userService.isSignedIn();
    if (isSignedIn) {
      final name = await _userService.getUser().toString();
      yield AuthenticationSuccess(name);
    } else {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    print('mapping authenticate success state in bloc');
    print('user service-----${_userService.getUser().toString()}');
    print('user in bloc------${_userService.getUserName().toString()}');
    yield AuthenticationSuccess(await _userService.getUser().toString());
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationFailure();
    print('calling signout in bloc');
    _userService.signOut();
  }
}
