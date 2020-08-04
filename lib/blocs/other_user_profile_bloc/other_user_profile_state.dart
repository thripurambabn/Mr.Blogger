import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/user.dart';

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
  final List users;
  const OtherUserProfileLoaded(this.users);
  @override
  List<Object> get props => [users];
  @override
  String toString() => 'Profile';
}

//Profile Not  state
class OtherUserProfileNotLoaded extends OtherUserProfileState {
  @override
  String toString() => 'profilenotloaded';
}
