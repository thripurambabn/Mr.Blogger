// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
// import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
// import 'package:mr_blogger/blocs/auth_bloc/auth_state.dart';
// import 'package:mr_blogger/service/user_service.dart';
// import 'package:mr_blogger/view/home_screen.dart';
// import 'package:mr_blogger/view/initial_screen.dart';
// import 'package:mr_blogger/view/login_screen.dart';
// import 'package:mr_blogger/view/splash_scren.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   UserService userService = UserService();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: new Container(
//           // decoration: new BoxDecoration(
//           //   image: new DecorationImage(
//           //     image: AssetImage('assets/background.jpeg'),
//           //     fit: BoxFit.cover,
//           //   ),
//           // ),
//           child: BlocProvider(
//             create: (context) =>
//                 AuthBloc(userService: userService)..add(ApploadingEvent()),
//             child: Appp(
//               userService: userService,
//             ),
//           ),
//         ));
//   }
// }

// class Appp extends StatelessWidget {
//   UserService userService;

//   Appp({@required UserService userService});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         print('state $state');
//         if (state is ApploadingState) {
//           print('loading state $state');
//           return SplashPage();
//         } else if (state is AppLoadedState) {
//           print('loaded state $state');
//           return HomeScreen();
//         } else if (state is AppErrorState) {
//           print('error state $state');
//           return InitialPage(
//             userService: userService,
//           );
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
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
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen(
              userService: _userService,
            );
          }
          if (state is AuthenticationSuccess) {
            return HomeScreen(name: state.displayName);
          }
          return SplashPage();
        },
      ),
    );
  }
}
