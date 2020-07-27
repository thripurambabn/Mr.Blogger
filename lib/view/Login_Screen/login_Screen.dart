import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/login_bloc/login_bloc.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/Login_Screen/login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserService _userService;

  LoginScreen({Key key, @required UserService userService})
      : assert(userService != null),
        _userService = userService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
              height: 759,
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
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'Paficico'),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 545,
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: BlocProvider<LoginBloc>(
                        create: (context) =>
                            LoginBloc(userService: _userService),
                        child: LoginForm(userService: _userService),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    ));
  }
}
