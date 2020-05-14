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
        // appBar: AppBar(
        //   // title: Text("Login"),
        //   // centerTitle: true,
        //   automaticallyImplyLeading: false,
        // ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
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
                    errorStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: "E-mail",
                    hintText: "E-mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                child: TextField(
                  controller: passCntrlr,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Password",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: RaisedButton(
                      color: Colors.cyan,
                      child: Text("Login"),
                      textColor: Colors.white,
                      onPressed: () {
                        loginBloc.add(
                          LoginSuccessEvent(
                            email: emailCntrlr.text,
                            password: passCntrlr.text,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      color: Colors.cyan,
                      child: Text("Sign Up Now"),
                      textColor: Colors.white,
                      onPressed: () {
                        navigateToSignUpScreen(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInitialUi() {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Text(
        "Mr.blogger Login ",
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.teal,
        ),
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
      //return HomePage(user: user, userService: userService);
    }));
  }

  void navigateToSignUpScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RegScreen();
      //return SignUpPageParent(userRepository: userRepository);
    }));
  }
}
