import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/login_bloc/login_bloc.dart';

import 'package:mr_blogger/blocs/reg_bloc/reg_bloc.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_event.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';
import 'package:mr_blogger/view/login_screen.dart';

class RegPage extends StatelessWidget {
  UserService userService;

  RegPage({@required this.userService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(userService: userService),
      child: RegScreen(userService: userService),
    );
  }
}

class RegScreen extends StatelessWidget {
  TextEditingController emailCntrlr = TextEditingController();
  TextEditingController passCntrlr = TextEditingController();
  TextEditingController cnfrmpassCntrlr = TextEditingController();
  UserService userService;
  RegScreen({@required this.userService});
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
          child: Column(children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "SignUp",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Paficico'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
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
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 50.0),
                      child: Text(
                        "You are stranger only once",
                        style: TextStyle(
                          fontFamily: 'Paficico',
                          fontSize: 30.0,
                          color: Colors.purple[700],
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15.0),
                      child: TextField(
                        controller: passCntrlr,
                        decoration: InputDecoration(
                          icon: new Icon(
                            Icons.lock_open,
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
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15.0),
                      child: TextField(
                        controller: cnfrmpassCntrlr,
                        decoration: InputDecoration(
                          icon: new Icon(
                            Icons.lock,
                            color: Colors.purple,
                            size: 30,
                          ),
                          hintText: 'confirm your password',
                          hintStyle: TextStyle(
                            color: Colors.purple[100],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(15.0),
                      child: TextField(
                        controller: emailCntrlr,
                        decoration: InputDecoration(
                          icon: new Icon(
                            Icons.email,
                            color: Colors.purple,
                            size: 30,
                          ),
                          hintText: 'enter your email',
                          hintStyle: TextStyle(
                            color: Colors.purple[100],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
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
                            "SignUp",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            // print(
                            //     'email ${emailCntrlr.text},password ${passCntrlr.text}');
                            // loginBloc.add(
                            //   LoginSuccessEvent(
                            //     email: emailCntrlr.text,
                            //     password: passCntrlr.text,
                            //   ),
                            // );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
