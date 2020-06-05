import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/home_screen.dart';

abstract class BlogsState extends Equatable {
  const BlogsState();

  @override
  List<Object> get props => [];
}

class BlogsLoading extends BlogsState {
  @override
  String toString() {
    return 'Blogs loading';
  }
}

class BlogsEmpty extends BlogsState {}

class BlogsLoaded extends BlogsState {
  final List<Blogs> blogs;

  const BlogsLoaded([this.blogs]);

  @override
  List<Object> get props {
    var list = [blogs];
    return list;
  }

  @override
  String toString() => 'blogsLoaded { blogs: $blogs }';
}

class BlogsNotLoaded extends BlogsState {
  @override
  String toString() => 'blogsNotLoaded';
}

// class SaveToDatabase extends BlogsState {}

class UploadImageSuccess extends BlogsState {
  @override
  String toString() => 'uploadimagesuccess';
}
