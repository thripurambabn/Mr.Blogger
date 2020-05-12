import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class ApploadingEvent extends AuthEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
