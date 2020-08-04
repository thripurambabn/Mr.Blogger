import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';

abstract class OtherUserProfileDetailsState extends Equatable {
  const OtherUserProfileDetailsState();
  @override
  List<Object> get props => [];
}

//Profile Loading state
class OtherUserProfileDetailsLoading extends OtherUserProfileDetailsState {
  @override
  String toString() {
    return 'Profile loading';
  }
}

//Profile Loaded state
class OtherUserProfileDetailsLoaded extends OtherUserProfileDetailsState {
  final String displayName;
  final String email;
  final String uid;
  final String imageUrl;
  final List<String> following;
  final List<String> followers;

  final List<Blogs> blogs;
  const OtherUserProfileDetailsLoaded(
    this.blogs,
    this.displayName,
    this.email,
    this.uid,
    this.imageUrl,
    this.following,
    this.followers,
  );
  @override
  List<Object> get props =>
      [blogs, displayName, email, uid, following, followers];
  @override
  String toString() => 'Profile';
}

//Profile Not  state
class OtherUserProfileDetailsNotLoaded extends OtherUserProfileDetailsState {
  @override
  String toString() => 'profilenotloaded';
}

class SuccessfullyDeletedblog extends OtherUserProfileDetailsState {
  @override
  String toString() => 'Deleted succssfully';
}
