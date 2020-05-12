import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class RegEvent extends Equatable {}

class SignUpEvent extends RegEvent {
  String email, password;
  SignUpEvent({@required this.email, this.password});
  @override
  // TODO: implement props
  List<Object> get props => null;
}
