import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

//Profile Loading state
class ProfileLoading extends ProfileState {
  @override
  String toString() {
    return 'Profile loading';
  }
}

//Profile Loaded state
class ProfileLoaded extends ProfileState {
  final String displayName;
  final String email;
  final String uid;
  final String imageUrl;
  final List<String> followers;
  final List<Blogs> blogs;
  const ProfileLoaded(this.blogs, this.displayName, this.email, this.uid,
      this.imageUrl, this.followers);
  @override
  List<Object> get props => [blogs, displayName, email, uid, followers];
  @override
  String toString() => 'Profile';
}

//Profile Not  state
class ProfileNotLoaded extends ProfileState {
  @override
  String toString() => 'profilenotloaded';
}

class SuccessfullyDeletedblog extends ProfileState {
  @override
  String toString() => 'Deleted succssfully';
}
