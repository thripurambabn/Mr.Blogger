import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';

abstract class BlogsState extends Equatable {
  const BlogsState();
  @override
  List<Object> get props => [];
}

//loading state
class BlogsLoading extends BlogsState {
  @override
  String toString() {
    return 'Blogs loading';
  }
}

//empty state
class BlogsEmpty extends BlogsState {}

//blogs loaded state
class BlogsLoaded extends BlogsState {
  final List<Blogs> blogs;
  final bool hasReachedMax;
  final String uid;

  const BlogsLoaded({this.blogs, this.hasReachedMax, this.uid});

  @override
  List<Object> get props => [blogs, hasReachedMax, uid];

  BlogsLoaded copyWith({
    List<Blogs> blogs,
    bool hasReachedMax,
  }) {
    return BlogsLoaded(
      blogs: blogs ?? this.blogs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      uid: uid,
    );
  }

  @override
  String toString() =>
      'blogsLoaded { blogs: $blogs hasReachedMax : $hasReachedMax}';
}

//blogs not loaded state
class BlogsNotLoaded extends BlogsState {
  @override
  String toString() => 'blogsNotLoaded';
}

class UploadImageSuccess extends BlogsState {
  @override
  String toString() {
    return 'Blogs loading';
  }
}
