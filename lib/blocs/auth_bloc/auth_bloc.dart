import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_state.dart';
import 'package:mr_blogger/service/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserService userService;

  AuthBloc({@required UserService userService}) {
    this.userService = userService;
  }
  @override
  AuthState get initialState => ApploadingState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is ApploadingEvent) {
      try {
        var isSignedIn = await userService.isSignedIn();
        if (isSignedIn) {
          var user = await userService.getCuurentUser();
          print('user in authbloc${userService.getCuurentUser()}');
          yield AppLoadedState(user);
        } else {
          yield AppErrorState();
        }
      } catch (e) {
        yield AppErrorState();
      }
    }
  }
}
