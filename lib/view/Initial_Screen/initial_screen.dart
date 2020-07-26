import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/Login_Screen/login_Screen.dart';
import 'package:mr_blogger/view/Register_Screen/register_screen.dart';

class InitialScreen extends StatelessWidget {
  final UserService _userService;
  InitialScreen({
    Key key,
    @required UserService userService,
  })  : assert(userService != null),
        _userService = userService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: ExactAssetImage('assets/logo.png'),
                          minRadius: 70,
                          maxRadius: 70,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Mr.Blogger',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Paficico',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
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
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 60),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Welcome to the directory of wonderful things",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Paficico',
                                      fontSize: 30.0,
                                      color: Colors.purple[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                    child: SizedBox(
                                  height: 50,
                                  width: 300,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.white)),
                                    color: Colors.purple[900],
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.white)),
                                    color: Colors.purple[900],
                                    child: Text("Signup"),
                                    textColor: Colors.white,
                                    onPressed: () {
                                      return navigateToSignUpScreen(context);
                                    },
                                  ),
                                )),
                              ]),
                        )
                      ],
                    ),
                  ))
                ],
              ))),
    );
  }

  void navigateTologinScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginScreen(
        userService: _userService,
      );
    }));
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //         builder: (context) => LoginScreen(
    //               userService: _userService,
    //             )),
    //     (Route<dynamic> route) => false);
  }

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return new RegisterScreen(
        userService: _userService,
      );
    }));
  }
}
