import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/login_bloc/login_bloc.dart';
import 'package:mr_blogger/blocs/login_bloc/login_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';
import 'package:mr_blogger/view/reg_screen.dart';

class LoginPage extends StatelessWidget {
  UserService userService;

  LoginPage({@required this.userService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(userService: userService),
      child: LoginScreen(userService: userService),
    );
  }
}

class LoginScreen extends StatelessWidget {
  TextEditingController emailCntrlr = TextEditingController();
  TextEditingController passCntrlr = TextEditingController();
  LoginBloc loginBloc;
  UserService userService;
  double _sigmaX = 3.0; // from 0-10
  double _sigmaY = 3.0; // from 0-10
  double _opacity = 0.1;
  LoginScreen({@required this.userService});

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                child: Container(
                  color: Colors.black.withOpacity(_opacity),
                  height: 800.0,
                  width: 800.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: BlocListener<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginLoadedState) {
                              navigateToHomeScreen(context, state.user);
                            }
                          },
                          child: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state is LoginInitialState) {
                                return buildInitialUi();
                              } else if (state is LoginLoadingState) {
                                return buildLoadingUi();
                              } else if (state is LoginErrorState) {
                                return buildFailureUi(state.message);
                              } else if (state is LoginLoadedState) {
                                print(
                                    '${emailCntrlr.text} and ${passCntrlr.text}');
                                emailCntrlr.text = "";
                                passCntrlr.text = "";
                                return Container();
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: TextField(
                          controller: emailCntrlr,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue[100]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              icon: new Icon(Icons.person),
                              border: InputBorder.none,
                              hintText: 'Enter your name'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: TextField(
                          controller: passCntrlr,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              icon: new Icon(Icons.lock),
                              border: InputBorder.none,
                              hintText: 'Enter your password'),
                        ),
                      ),
                      Container(
                        child: SizedBox(
                          width: 300,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            color: Colors.brown[900],
                            child: Text("Login"),
                            textColor: Colors.white,
                            onPressed: () {
                              print(
                                  'email ${emailCntrlr.text},password ${passCntrlr.text}');
                              loginBloc.add(
                                LoginSuccessEvent(
                                  email: emailCntrlr.text,
                                  password: passCntrlr.text,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                          child: Text("New User?SignUp here",
                              style: TextStyle(
                                  // backgroundColor: Colors.brown,
                                  decoration: TextDecoration.underline,
                                  fontSize: 20.0,
                                  color: Colors.brown[900])),
                          onTap: () {
                            navigateToSignUpScreen(context);
                          })
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget buildInitialUi() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
      child: Text(
        "Login",
        style: TextStyle(
            fontSize: 40.0,
            color: Colors.brown[900],
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildLoadingUi() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildFailureUi(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Fail $message",
            style: TextStyle(color: Colors.red),
          ),
        ),
        buildInitialUi(),
      ],
    );
  }

  void navigateToHomeScreen(BuildContext context, FirebaseUser user) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
  }

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RegScreen();
    }));
  }
}
