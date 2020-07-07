import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_state.dart';
import 'package:mr_blogger/service/user_service.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserService _userService;
//constructor for authentication bloc
  AuthenticationBloc({@required UserService userService})
      : assert(userService != null),
        _userService = userService;

  @override
  AuthenticationState get initialState => AuthenticationInitial();

//mapping aunthentication events with authentication states
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

//mapping Authentication Started with authentication states
  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = await _userService.isSignedIn();
    if (isSignedIn) {
      final name = _userService.getUser().toString();
      yield AuthenticationSuccess(name);
    } else {
      yield AuthenticationFailure();
    }
  }

//mapping Authentication Logged In with authentication state
  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationSuccess(_userService.getUser().toString());
  }

//mapping Authentication Failure with authentication state
  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationFailure();
    _userService.signOut();
  }
}
