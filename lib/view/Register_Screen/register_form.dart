import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_bloc.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_event.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/Login_Screen/login_Screen.dart';

class RegisterForm extends StatefulWidget {
  final UserService _userService;

  RegisterForm({Key key, @required UserService userService})
      : assert(userService != null),
        _userService = userService,
        super(key: key);

  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passobscureText = true;
  bool _confrmobscureText = true;
  UserService get _userService => widget._userService;

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _usernameController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
    _usernameController.addListener(_onUserNameChanged);
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
          // BlocProvider.of<AuthenticationBloc>(context)
          //     .add(AuthenticationStarted());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return LoginScreen(userService: _userService);
            }),
          );
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
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "You are stranger only once",
                      style: TextStyle(
                        fontFamily: 'Paficico',
                        fontSize: 28.0,
                        color: Colors.purple[700],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.purple[800],
                      ),
                      labelText: 'Username',
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (_) {
                      return !state.isUsernameValid
                          ? 'Must be more than 8 characters'
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Colors.purple[800],
                      ),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: _passwordController,
                      obscureText: _passobscureText,
                      autocorrect: false,
                      autovalidate: true,
                      decoration: new InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.purple[800],
                        ),
                        hintText: 'enter your password',
                        labelText: 'password',
                        suffixIcon: new GestureDetector(
                          onTap: () {
                            setState(() {
                              _passobscureText = !_passobscureText;
                            });
                          },
                          child: new Icon(_passobscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return !state.isPasswordValid
                            ? 'Invalid Password'
                            : null;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _confrmobscureText,
                      autocorrect: false,
                      autovalidate: true,
                      decoration: new InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.purple[800],
                        ),
                        hintText: 'confirm your password',
                        labelText: 'confirm password',
                        suffixIcon: new GestureDetector(
                          onTap: () {
                            setState(() {
                              _confrmobscureText = !_confrmobscureText;
                            });
                          },
                          child: new Icon(_confrmobscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return !state.isConfirmPasswordValid ||
                                _confirmPasswordController.text !=
                                    _passwordController.text
                            ? 'doesnt match'
                            : null;
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Note: Password should contain Minimum eight characters, at least one letter and one number.',
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 80,
                    child: RaisedButton(
                      color: Colors.purple[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text('SignUp',
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.0)),
                      onPressed: isRegisterButtonEnabled(state)
                          ? _onFormSubmitted
                          : null,
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
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

//calls RegisterEmailChanged event
  void _onEmailChanged() {
    _registerBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

//calls RegisterPasswordChanged event
  void _onPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onConfirmPasswordChanged() {
    _registerBloc.add(
      RegisterConfirmPasswordChanged(
          confirmPassword: _confirmPasswordController.text),
    );
  }

//calls RegisterusernameChanged event
  void _onUserNameChanged() {
    _registerBloc.add(
      RegisterusernameChanged(username: _usernameController.text),
    );
  }

//calls RegisterSubmitted event
  void _onFormSubmitted() {
    _registerBloc.add(
      RegisterSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
      ),
    );
  }
}
