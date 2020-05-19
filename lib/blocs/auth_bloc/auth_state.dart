// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:meta/meta.dart';

// abstract class AuthState extends Equatable {}

// class ApploadingState extends AuthState {
//   @override
//   // TODO: implement props
//   List<Object> get props => null;
// }

// class AppLoadedState extends AuthState {
//   FirebaseUser user;

//   AppLoadedState(@required this.user);

//   @override
//   // TODO: implement props
//   List<Object> get props => null;
// }

// class AppErrorState extends AuthState {
//   @override
//   // TODO: implement props
//   List<Object> get props => null;
// }

import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String displayName;

  const AuthenticationSuccess(this.displayName);

  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class AuthenticationFailure extends AuthenticationState {}
