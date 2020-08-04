import 'package:equatable/equatable.dart';

abstract class OtherUserProfileState extends Equatable {
  const OtherUserProfileState();
  @override
  List<Object> get props => [];
}

//Profile Loading state
class OtherUserProfileLoading extends OtherUserProfileState {
  @override
  String toString() {
    return 'Profile loading';
  }
}

//Profile Loaded state
class OtherUserProfileLoaded extends OtherUserProfileState {
  final userData;
  final List users;
  const OtherUserProfileLoaded(this.users, this.userData);
  @override
  List<Object> get props => [users, userData];
  @override
  String toString() => 'Profile';
}

//Profile Not  state
class OtherUserProfileNotLoaded extends OtherUserProfileState {
  @override
  String toString() => 'profilenotloaded';
}
