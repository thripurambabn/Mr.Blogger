import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {}

class LoginSuccessEvent extends LoginEvent {
  String email, password;
  LoginSuccessEvent({@required this.email, this.password});
  @override
  // TODO: implement props
  List<Object> get props => null;
}
