import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class RegState extends Equatable {}

class RegInitialState extends RegState {
  @override
  List<Object> get props => null;
}

class RegloadingState extends RegState {
  @override
  List<Object> get props => null;
}

class RegLoadedState extends RegState {
  FirebaseUser user;
  RegLoadedState(this.user);
  @override
  List<Object> get props => null;
}

class RegerrorState extends RegState {
  String message;
  RegerrorState(this.message);
  @override
  List<Object> get props => null;
}
