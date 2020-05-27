import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class RegisterusernameChanged extends RegisterEvent {
  final String username;

  const RegisterusernameChanged({@required this.username});

  @override
  List<Object> get props => [username];

  @override
  String toString() => 'PasswordChanged { password: $username }';
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String username;

  const RegisterSubmitted({
    @required this.email,
    @required this.password,
    @required this.username,
  });

  @override
  List<Object> get props => [email, password, username];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password ,username:$username}';
  }
}
