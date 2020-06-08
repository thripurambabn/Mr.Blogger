import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//Authentication Started event
class AuthenticationStarted extends AuthenticationEvent {}

//Authentication Logged In event
class AuthenticationLoggedIn extends AuthenticationEvent {}

//Authentication Logged Out event
class AuthenticationLoggedOut extends AuthenticationEvent {}
