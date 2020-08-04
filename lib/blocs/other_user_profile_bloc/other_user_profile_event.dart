import 'package:equatable/equatable.dart';

abstract class OtherUserProfileDetailsEvent extends Equatable {
  const OtherUserProfileDetailsEvent();
  @override
  List<Object> get props => [];
}

//Loaded Profile Deatils event
class OtherUserProfileEvent extends OtherUserProfileDetailsEvent {
  final List<String> uid;
  const OtherUserProfileEvent(this.uid);
  @override
  List<Object> get props => [uid];
  @override
  String toString() => 'followersProfile';
}
