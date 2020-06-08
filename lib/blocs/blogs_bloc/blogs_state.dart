import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';

abstract class BlogsState extends Equatable {
  const BlogsState();

  @override
  List<Object> get props => [];
}

//load more blogs state
class BlogsMoreLoaded extends BlogsState {
  final List<Blogs> blogs;
  final bool hasReachedMax;
  const BlogsMoreLoaded({this.blogs, this.hasReachedMax});

  @override
  List<Object> get props => [blogs, hasReachedMax];

  BlogsLoaded copyWith({
    List<Blogs> blogs,
    bool hasReachedMax,
  }) {
    return BlogsLoaded(
      blogs: blogs ?? this.blogs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'blogsLoaded { blogs: $blogs hasReachedMax : $hasReachedMax}';
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

  const BlogsLoaded({this.blogs, this.hasReachedMax});

  @override
  List<Object> get props => [blogs, hasReachedMax];

  BlogsLoaded copyWith({
    List<Blogs> blogs,
    bool hasReachedMax,
  }) {
    return BlogsLoaded(
      blogs: blogs ?? this.blogs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
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

//upload image success state
class UploadImageSuccess extends BlogsState {
  @override
  String toString() => 'uploadimagesuccess';
}
