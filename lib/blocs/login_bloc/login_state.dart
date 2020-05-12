import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class LoginState extends Equatable {}

class LoginIntialState extends LoginState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginLoadingState extends LoginState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginLoadedState extends LoginState {
  FirebaseUser user;
  LoginLoadedState({@required this.user});
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoginErrorState extends LoginState {
  String message;
  LoginErrorState({@required this.message});
  @override
  // TODO: implement props
  List<Object> get props => null;
}
