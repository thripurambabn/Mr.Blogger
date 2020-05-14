import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/login_bloc/login_bloc.dart';
import 'package:mr_blogger/blocs/login_bloc/login_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/fadeanimation.dart';
import 'package:mr_blogger/view/home_screen.dart';
import 'package:mr_blogger/view/login_screen.dart';
import 'package:mr_blogger/view/reg_screen.dart';

class InitialPage extends StatelessWidget {
  UserService userService;

  InitialPage({@required this.userService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(userService: userService),
      child: InitialScreen(),
    );
  }
}

class InitialScreen extends StatelessWidget {
  UserService userService;
  double _sigmaX = 5.0; // from 0-10
  double _sigmaY = 5.0; // from 0-10
  double _opacity = 0.1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // appBar: AppBar(
        //   // title: Text("Login"),
        //   // centerTitle: true,
        //   automaticallyImplyLeading: false,
        // ),
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
                        SizedBox(height: 100),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            "Mr.BLOGGER",
                            style: TextStyle(
                              fontSize: 50.0,
                              color: Colors.brown[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 250,
                        ),
                        Container(
                            child: SizedBox(
                          height: 50,
                          width: 300,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            color: Colors.brown[900],
                            child: Text("Login"),
                            textColor: Colors.white,
                            onPressed: () {
                              navigateTologinScreen(context);
                            },
                          ),
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            child: SizedBox(
                          height: 50,
                          width: 300,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            color: Colors.brown[900],
                            child: Text("Signup"),
                            textColor: Colors.white,
                            onPressed: () {},
                          ),
                        )),
                      ]),
                ))),
      ),
    );
  }

  void navigateTologinScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginPage(userService: userService);
    }));
  }

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RegScreen();
    }));
  }
}
