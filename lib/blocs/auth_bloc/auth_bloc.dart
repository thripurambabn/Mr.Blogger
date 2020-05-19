// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
// import 'package:mr_blogger/blocs/auth_bloc/auth_state.dart';
// import 'package:mr_blogger/service/user_service.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   UserService userService;

//   AuthBloc({@required UserService userService}) {
//     this.userService = userService;
//   }
//   @override
//   AuthState get initialState => ApploadingState();

//   @override
//   Stream<AuthState> mapEventToState(AuthEvent event) async* {
//     if (event is ApploadingEvent) {
//       try {
//         var isSignedIn = await userService.isSignedIn();
//         if (isSignedIn) {
//           var user = await userService.getUser();
//           print('user in authbloc${userService.getUser()}');
//           yield AppLoadedState(user);
//         } else {
//           yield AppErrorState();
//         }
//       } catch (e) {
//         yield AppErrorState();
//       }
//     }
//   }
// }

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
      final name = await _userService.getUser();
      yield AuthenticationSuccess(name);
    } else {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationSuccess(await _userService.getUser());
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationFailure();
    _userService.signOut();
  }
}
