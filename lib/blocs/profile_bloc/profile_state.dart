import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  String toString() {
    return 'Profile loading';
  }
}

class ProfileLoaded extends ProfileState {
  final List<Blogs> blogs;

  const ProfileLoaded(this.blogs);

  @override
  List<Object> get props => [blogs];

  @override
  String toString() => 'Profile';
}

class ProfileNotLoaded extends ProfileState {
  @override
  String toString() => 'profilenotloaded';
}
