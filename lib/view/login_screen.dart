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

  LoginScreen({@required this.userService});

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: [
                          Colors.purple[400],
                          Colors.purple[300],
                          Colors.purple[900]
                        ],
                        end: FractionalOffset.topCenter),
                    color: Colors.purpleAccent),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Column(
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
                                    SizedBox(
                                      height: 30,
                                    );
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
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(15.0),
                            child: TextField(
                              controller: emailCntrlr,
                              decoration: InputDecoration(
                                icon: new Icon(
                                  Icons.person,
                                  color: Colors.purple,
                                  size: 30,
                                ),
                                hintText: 'Enter your name',
                                hintStyle: TextStyle(
                                  color: Colors.purple[100],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            padding: EdgeInsets.all(15.0),
                            child: TextField(
                              controller: emailCntrlr,
                              decoration: InputDecoration(
                                // filled: true,
                                icon: new Icon(
                                  Icons.lock,
                                  color: Colors.purple,
                                  size: 30,
                                ),
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                  color: Colors.purple[100],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 290,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text('Forgot password?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.purple[700])),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 50,
                              width: 300,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // /side: BorderSide(color: Colors.white)
                                ),
                                color: Colors.purple[800],
                                child: Text(
                                  "Login",
                                  style: TextStyle(fontSize: 20.0),
                                ),
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
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 50,
                              width: 300,
                              child: RaisedButton.icon(
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                label: Text(
                                  'Login with Gmail',
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                ),
                                textColor: Colors.white,
                                color: Colors.purple[800],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                              child: Text("New User?SignUp here",
                                  style: TextStyle(
                                      // backgroundColor: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontSize: 22.0,
                                      color: Colors.purple[400])),
                              onTap: () {
                                navigateToSignUpScreen(context);
                              })
                        ],
                      ),
                    ))
                  ],
                ))
            //),
            ));
  }

  Widget buildInitialUi() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 50.0),
      child: Text(
        "Welocme back",
        style: TextStyle(
            fontSize: 40.0,
            color: Colors.purple[700],
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
