// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// abstract class LoginEvent extends Equatable {}

// class LoginSuccessEvent extends LoginEvent {
//   String email, password;
//   LoginSuccessEvent({@required this.email, this.password});
//   @override
//   List<Object> get props => null;
// }

// class GmailLoginEvent extends LoginEvent{

//   @override
//   // TODO: implement props
//   List<Object> get props => throw UnimplementedError();

// }

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class LoginWithGooglePressed extends LoginEvent {}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}
