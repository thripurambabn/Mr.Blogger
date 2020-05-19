// import 'dart:ui';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';

// import 'package:mr_blogger/blocs/reg_bloc/reg_bloc.dart';
// import 'package:mr_blogger/blocs/reg_bloc/reg_event.dart';
// import 'package:mr_blogger/blocs/reg_bloc/reg_state.dart';

// import 'package:mr_blogger/service/user_service.dart';
// import 'package:mr_blogger/view/home_screen.dart';
// import 'package:mr_blogger/view/login_screen.dart';

// class SignUpPage extends StatelessWidget {
//   UserService userService;

//   SignUpPage({@required this.userService});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => RegBloc(userService: userService),
//       child: RegScreen(userService: userService),
//     );
//   }
// }

// class RegScreen extends StatelessWidget {
//   TextEditingController emailCntrlr = TextEditingController();
//   TextEditingController passCntrlr = TextEditingController();
//   // TextEditingController cnfrmpassCntrlr = TextEditingController();
//   RegBloc regBloc;
//   UserService userService;
//   RegScreen({@required this.userService});
//   @override
//   Widget build(BuildContext context) {
//     regBloc = BlocProvider.of<RegBloc>(context);

//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         body: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   colors: [
//                     Colors.purple[400],
//                     Colors.purple[300],
//                     Colors.purple[900]
//                   ],
//                   end: FractionalOffset.topCenter),
//               color: Colors.purpleAccent),
//           child: Column(children: <Widget>[
//             SizedBox(
//               height: 80,
//             ),
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     "SignUp",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 40,
//                         fontFamily: 'Paficico'),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(60),
//                         topRight: Radius.circular(60))),
//                 child: SingleChildScrollView(
//                   //controller: controller,
//                   child: Column(
//                     children: <Widget>[
//                       BlocListener<RegBloc, RegState>(
//                         listener: (context, state) {
//                           if (state is RegLoadedState) {
//                             return navigateToHomePage(context, state.user);
//                           }
//                         },
//                         child: BlocBuilder<RegBloc, RegState>(
//                           builder: (context, state) {
//                             if (state is RegInitialState) {
//                               return buildInitialUi();
//                             } else if (state is RegloadingState) {
//                               return buildLoadingUi();
//                             } else if (state is RegLoadedState) {
//                               return Container();
//                             } else if (state is RegerrorState) {
//                               print('${state.message}');
//                               return buildFailureUi(state.message);
//                             }
//                           },
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.center,
//                         padding: EdgeInsets.only(top: 50.0),
//                         child: Text(
//                           "You are stranger only once",
//                           style: TextStyle(
//                             fontFamily: 'Paficico',
//                             fontSize: 30.0,
//                             color: Colors.purple[700],
//                             //fontWeight: FontWeight.bold
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Container(
//                         height: 50,
//                         padding: EdgeInsets.all(15.0),
//                         child: TextField(
//                           controller: emailCntrlr,
//                           decoration: InputDecoration(
//                             icon: new Icon(
//                               Icons.person,
//                               color: Colors.purple,
//                               size: 30,
//                             ),
//                             hintText: 'Enter your name',
//                             hintStyle: TextStyle(
//                               color: Colors.purple[100],
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Container(
//                         height: 50,
//                         padding: EdgeInsets.all(15.0),
//                         child: TextField(
//                           controller: passCntrlr,
//                           decoration: InputDecoration(
//                             icon: new Icon(
//                               Icons.lock_open,
//                               color: Colors.purple,
//                               size: 30,
//                             ),
//                             hintText: 'Enter your password',
//                             hintStyle: TextStyle(
//                               color: Colors.purple[100],
//                               fontStyle: FontStyle.italic,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       // Container(
//                       //   height: 50,
//                       //   padding: EdgeInsets.all(15.0),
//                       //   child: TextField(
//                       //     // controller: cnfrmpassCntrlr,
//                       //     decoration: InputDecoration(
//                       //       icon: new Icon(
//                       //         Icons.lock,
//                       //         color: Colors.purple,
//                       //         size: 30,
//                       //       ),
//                       //       hintText: 'confirm your password',
//                       //       hintStyle: TextStyle(
//                       //         color: Colors.purple[100],
//                       //         fontStyle: FontStyle.italic,
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                       // SizedBox(
//                       //   height: 30,
//                       // ),
//                       // Container(
//                       //   height: 50,
//                       //   padding: EdgeInsets.all(15.0),
//                       //   child: TextField(
//                       //     controller: emailCntrlr,
//                       //     decoration: InputDecoration(
//                       //       icon: new Icon(
//                       //         Icons.email,
//                       //         color: Colors.purple,
//                       //         size: 30,
//                       //       ),
//                       //       hintText: 'enter your email',
//                       //       hintStyle: TextStyle(
//                       //         color: Colors.purple[100],
//                       //         fontStyle: FontStyle.italic,
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         alignment: Alignment.center,
//                         child: SizedBox(
//                           height: 50,
//                           width: 300,
//                           child: RaisedButton(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               // /side: BorderSide(color: Colors.white)
//                             ),
//                             color: Colors.purple[800],
//                             child: Text(
//                               "SignUp",
//                               style: TextStyle(
//                                 fontSize: 20.0,
//                               ),
//                             ),
//                             textColor: Colors.white,
//                             onPressed: () {
//                               print(
//                                   'email ${emailCntrlr.text},password ${passCntrlr.text}');
//                               regBloc.add(
//                                 SignUpEvent(
//                                   email: emailCntrlr.text,
//                                   password: passCntrlr.text,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ]),
//         ),
//       ),
//     );
//   }

//   Widget buildInitialUi() {
//     return Text(
//       "You are stranger only once",
//       style: TextStyle(
//         fontFamily: 'Paficico',
//         fontSize: 30.0,
//         color: Colors.purple[700],
//         //fontWeight: FontWeight.bold
//       ),
//     );
//   }

//   Widget buildLoadingUi() {
//     return Center(
//       child: CircularProgressIndicator(),
//     );
//   }

//   void navigateToHomePage(BuildContext context, FirebaseUser user) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return HomeScreen();
//     }));
//   }

//   Widget buildFailureUi(String message) {
//     return Text(
//       message,
//       style: TextStyle(color: Colors.red),
//     );
//   }

//   void navigateToLoginPage(BuildContext context) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return LoginPage(userService: userService);
//     }));
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_bloc.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_event.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_state.dart';
import 'package:mr_blogger/service/user_service.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text('Register'),
                    onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  final UserService _userService;

  RegisterScreen({Key key, @required UserService userService})
      : assert(userService != null),
        _userService = userService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userService: _userService),
          child: RegisterForm(),
        ),
      ),
    );
  }
}
