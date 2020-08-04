import 'package:equatable/equatable.dart';

abstract class OtherUserProfileDetailsEvent extends Equatable {
  const OtherUserProfileDetailsEvent();
  @override
  List<Object> get props => [];
}

//Loading Profile Details event
class LoadingOtherUserProfileDetails extends OtherUserProfileDetailsEvent {
  @override
  String toString() => 'loadprofile ';
}

//Loaded Profile Deatils event
class LoadedOtherUserProfileDeatils extends OtherUserProfileDetailsEvent {
  final String uid;
  const LoadedOtherUserProfileDeatils(this.uid);
  @override
  List<Object> get props => [uid];
  @override
  String toString() => 'Loadedprofile';
}
