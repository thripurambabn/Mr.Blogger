import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/login_bloc/login_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_state.dart';
import 'package:mr_blogger/service/user_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserService userService;
  LoginBloc({@required UserService userService}) {
    this.userService = UserService();
  }
  @override
  LoginState get initialState => LoginInitialState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSuccessEvent) {
      try {
        yield LoginLoadingState();
        var user = await userService.signIn(event.email, event.password);
        yield LoginLoadedState(user: user);
      } catch (e) {
        yield LoginErrorState(message: e.toString());
      }
    }
  }
}
