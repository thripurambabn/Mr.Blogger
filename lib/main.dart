import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';

import 'package:mr_blogger/view/login_screen.dart';

import 'package:mr_blogger/view/splash_scren.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserService userService = UserService();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userService: userService,
      )..add(AuthenticationStarted()),
      child: App(userService: userService),
    ),
  );
}

class App extends StatelessWidget {
  final UserService _userService;

  App({Key key, @required UserService userService})
      : assert(userService != null),
        _userService = userService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen(
              userService: _userService,
            );
          }
          if (state is AuthenticationSuccess) {
            return Homepage();
          }
          return SplashPage();
        },
      ),
    );
  }
}
