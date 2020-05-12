import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthState extends Equatable {}

class ApploadingState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class AppLoadedState extends AuthState {
  FirebaseUser user;

  AppLoadedState({@required this.user});
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class AppErrorstate extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
