import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_bloc.dart';
import 'package:mr_blogger/blocs/login_bloc/login_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';
import 'package:mr_blogger/view/reg_screen.dart';

// class LoginPage extends StatelessWidget {
//   UserService userService;

//   LoginPage({@required this.userService});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => LoginBloc(userService: userService),
//       child: LoginScreen(userService: userService),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   TextEditingController emailCntrlr = TextEditingController();
//   TextEditingController passCntrlr = TextEditingController();
//   LoginBloc loginBloc;
//   UserService userService;

//   LoginScreen({@required this.userService});

//   @override
//   Widget build(BuildContext context) {
//     loginBloc = BlocProvider.of<LoginBloc>(context);

//     return WillPopScope(
//         onWillPop: () async => false,
//         child: Scaffold(
//             body: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         colors: [
//                           Colors.purple[400],
//                           Colors.purple[300],
//                           Colors.purple[900]
//                         ],
//                         end: FractionalOffset.topCenter),
//                     color: Colors.purpleAccent),
//                 child: Column(
//                   children: <Widget>[
//                     SizedBox(
//                       height: 80,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             "Login",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 40,
//                                 fontFamily: 'Paficico'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Expanded(
//                         child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(60),
//                               topRight: Radius.circular(60))),
//                       child: Column(
//                         children: <Widget>[
//                           Container(
//                             padding: EdgeInsets.all(5.0),
//                             child: BlocListener<LoginBloc, LoginState>(
//                               listener: (context, state) {
//                                 if (state is LoginLoadedState) {
//                                   navigateToHomeScreen(context, state.user);
//                                 }
//                               },
//                               child: BlocBuilder<LoginBloc, LoginState>(
//                                 builder: (context, state) {
//                                   if (state is LoginInitialState) {
//                                     SizedBox(
//                                       height: 30,
//                                     );
//                                     return buildInitialUi();
//                                   } else if (state is LoginLoadingState) {
//                                     return buildLoadingUi();
//                                   } else if (state is LoginErrorState) {
//                                     return buildFailureUi(state.message);
//                                   } else if (state is LoginLoadedState) {
//                                     print(
//                                         '${emailCntrlr.text} and ${passCntrlr.text}');
//                                     emailCntrlr.text = "";
//                                     passCntrlr.text = "";
//                                     return Container();
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Container(
//                             height: 50,
//                             padding: EdgeInsets.all(15.0),
//                             child: TextFormField(
//                               controller: emailCntrlr,
//                               decoration: InputDecoration(
//                                 icon: new Icon(
//                                   Icons.person,
//                                   color: Colors.purple,
//                                   size: 30,
//                                 ),
//                                 hintText: 'Enter your name',
//                                 hintStyle: TextStyle(
//                                   color: Colors.purple[100],
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Please enter some text';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                             height: 50,
//                             padding: EdgeInsets.all(15.0),
//                             child: TextFormField(
//                               controller: passCntrlr,
//                               decoration: InputDecoration(
//                                 // filled: true,
//                                 icon: new Icon(
//                                   Icons.lock,
//                                   color: Colors.purple,
//                                   size: 30,
//                                 ),
//                                 hintText: 'Enter your password',
//                                 hintStyle: TextStyle(
//                                   color: Colors.purple[100],
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Please enter some text';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height: 50,
//                             width: 290,
//                             child: Container(
//                               alignment: Alignment.centerRight,
//                               child: Text('Forgot password?',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                       color: Colors.purple[700])),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Container(
//                             alignment: Alignment.center,
//                             child: SizedBox(
//                               height: 50,
//                               width: 300,
//                               child: RaisedButton(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   // /side: BorderSide(color: Colors.white)
//                                 ),
//                                 color: Colors.purple[800],
//                                 child: Text(
//                                   "Login",
//                                   style: TextStyle(
//                                     fontSize: 20.0,
//                                   ),
//                                 ),
//                                 textColor: Colors.white,
//                                 onPressed: () {
//                                   print(
//                                       'email ${emailCntrlr.text},password ${passCntrlr.text}');
//                                   loginBloc.add(
//                                     LoginSuccessEvent(
//                                       email: emailCntrlr.text,
//                                       password: passCntrlr.text,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Container(
//                             alignment: Alignment.center,
//                             child: SizedBox(
//                               height: 50,
//                               width: 300,
//                               child: RaisedButton.icon(
//                                 onPressed: () {},
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(10.0))),
//                                 label: Text(
//                                   'Login with Gmail',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 icon: Icon(
//                                   Icons.mail,
//                                   color: Colors.white,
//                                 ),
//                                 textColor: Colors.white,
//                                 color: Colors.purple[800],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           GestureDetector(
//                               child: Text("New User?SignUp here",
//                                   style: TextStyle(
//                                       // backgroundColor: Colors.brown,
//                                       fontWeight: FontWeight.bold,
//                                       decoration: TextDecoration.underline,
//                                       fontSize: 22.0,
//                                       color: Colors.purple[400])),
//                               onTap: () {
//                                 navigateToSignUpScreen(context);
//                               })
//                         ],
//                       ),
//                     ))
//                   ],
//                 ))
//             //),
//             ));
//   }

//   Widget buildInitialUi() {
//     return Container(
//       alignment: Alignment.center,
//       padding: EdgeInsets.only(top: 50.0),
//       child: Text(
//         "Welocme back",
//         style: TextStyle(
//             fontFamily: 'Paficico',
//             fontSize: 40.0,
//             color: Colors.purple[700],
//             fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget buildLoadingUi() {
//     return Center(
//       child: CircularProgressIndicator(),
//     );
//   }

//   Widget buildFailureUi(String message) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(5.0),
//           child: Text(
//             "Fail $message",
//             style: TextStyle(color: Colors.red),
//           ),
//         ),
//         // AlertDialog(
//         //   title: Text("My title"),
//         //   content: Text(
//         //     "Fail $message",
//         //     style: TextStyle(color: Colors.red),
//         //   ),
//         //   actions: [
//         //     FlatButton(
//         //       child: Text('Ok'),
//         //       color: Colors.purpleAccent,
//         //       textColor: Colors.white,
//         //       onPressed: () {
//         //         navigateToLoginScreen(context);
//         //       },
//         //     ),
//         //   ],
//         // ),
//         buildInitialUi(),
//       ],
//     );
//   }

//   void navigateToHomeScreen(BuildContext context, FirebaseUser user) {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//       return HomeScreen();
//     }));
//   }

//   void navigateToLoginScreen(BuildContext context, FirebaseUser user) {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//       return LoginPage(
//         userService: userService,
//       );
//     }));
//   }

//   void navigateToSignUpScreen(BuildContext context) {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//       return SignUpPage(
//         userService: userService,
//       );
//     }));
//   }
// }

class LoginForm extends StatefulWidget {
  final UserService _userService;

  LoginForm({Key key, @required UserService userService})
      : assert(userService != null),
        _userService = userService,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserService get _userService => widget._userService;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset('assets/flutter_logo.png', height: 200),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidate: true,
                    autocorrect: false,
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
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text('Login'),
                          onPressed: isLoginButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                        ),
                        RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          icon: Icon(FontAwesomeIcons.google,
                              color: Colors.white),
                          onPressed: () {
                            BlocProvider.of<LoginBloc>(context).add(
                              LoginWithGooglePressed(),
                            );
                          },
                          label: Text('Sign in with Google',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.redAccent,
                        ),
                        FlatButton(
                          child: Text(
                            'Create an Account',
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return RegisterScreen(
                                    userService: _userService);
                              }),
                            );
                          },
                        ),
                      ],
                    ),
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
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final UserService _userService;

  LoginScreen({Key key, @required UserService userService})
      : assert(userService != null),
        _userService = userService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userService: _userService),
        child: LoginForm(userService: _userService),
      ),
    );
  }
}
