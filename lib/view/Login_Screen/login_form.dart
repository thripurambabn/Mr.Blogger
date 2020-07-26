import 'dart:ui';
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
import 'package:mr_blogger/view/Register_Screen/register_screen.dart';

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
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Welcome back",
                      style: TextStyle(
                          fontFamily: 'Paficico',
                          fontSize: 40.0,
                          color: Colors.purple[700],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email,
                          color: Colors.purple[800], size: 30),
                      hintText: 'Enter your Email',
                      hintStyle: TextStyle(
                        color: Colors.purple[100],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: Colors.purple[800],
                        size: 30,
                      ),
                      hintText: 'Enter your Password',
                      hintStyle: TextStyle(
                        color: Colors.purple[100],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    obscureText: true,
                    //autovalidate: true,
                    //autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 40,
                          child: RaisedButton(
                            color: Colors.purple[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 50,
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                            color: Colors.purple[800],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                          child: Text('New User? SignUp here',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 20.0,
                                  color: Colors.purple[400])),
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

//calls LoginEmailChanged event
  void _onEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

//calls LoginPasswordChanged event
  void _onPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

//calls LoginWithCrendentialPressed event
  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
