import 'package:equatable/equatable.dart';

abstract class NavigatorEvent extends Equatable {
  const NavigatorEvent();
  @override
  List<Object> get props => [];
}

class NavgationActionPop extends NavigatorEvent {}

class NaviagteToHomeScreen extends NavigatorEvent {}
