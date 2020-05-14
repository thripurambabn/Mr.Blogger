import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';
import 'package:mr_blogger/view/login_screen.dart';
import 'package:mr_blogger/view/splash_scren.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Container(
          // decoration: new BoxDecoration(
          //   image: new DecorationImage(
          //     image: AssetImage('assets/background.jpeg'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: BlocProvider(
            create: (context) =>
                AuthBloc(userService: userService)..add(ApploadingEvent()),
            child: Appp(
              userService: userService,
            ),
          ),
        ));
  }
}

class Appp extends StatelessWidget {
  UserService userService;

  Appp({@required UserService userService});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('state $state');
        if (state is ApploadingState) {
          print('loading state $state');
          return SplashPage();
        } else if (state is AppLoadedState) {
          print('loaded state $state');
          return HomeScreen();
        } else if (state is AppErrorState) {
          print('error state $state');
          return LoginPage(
            userService: userService,
          );
        }
      },
    );
  }
}
