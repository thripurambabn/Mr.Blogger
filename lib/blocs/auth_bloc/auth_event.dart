// import 'package:equatable/equatable.dart';

// abstract class AuthEvent extends Equatable {}

// class ApploadingEvent extends AuthEvent {
//   @override
//   List<Object> get props => null;
// }

import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {}

class AuthenticationLoggedOut extends AuthenticationEvent {}
