import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/home_screen.dart';

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

  const ProfileLoaded([this.blogs = const []]);

  @override
  List<Object> get props => [blogs];

  @override
  String toString() => 'Profile';
}
