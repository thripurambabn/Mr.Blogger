import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';

abstract class SearchBlogsState extends Equatable {
  const SearchBlogsState();

  @override
  List<Object> get props => [];
}

//load more blogs state
class SearchBlogsMoreLoaded extends SearchBlogsState {
  final List<Blogs> blogs;
  final bool hasReachedMax;
  const SearchBlogsMoreLoaded({this.blogs, this.hasReachedMax});

  @override
  List<Object> get props => [blogs, hasReachedMax];

  SearchBlogsLoaded copyWith({
    List<Blogs> blogs,
    bool hasReachedMax,
  }) {
    return SearchBlogsLoaded(
      blogs: blogs ?? this.blogs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() =>
      'blogsLoaded { blogs: $blogs hasReachedMax : $hasReachedMax}';
}

//loading state
class SearchBlogsLoading extends SearchBlogsState {
  @override
  String toString() {
    return 'Blogs loading';
  }
}

//empty state
class SearchBlogsEmpty extends SearchBlogsState {}

class SearchInitialState extends SearchBlogsState {}

//blogs loaded state
class SearchBlogsLoaded extends SearchBlogsState {
  final List<Blogs> blogs;
  final bool hasReachedMax;
  final String uid;

  const SearchBlogsLoaded({this.blogs, this.hasReachedMax, this.uid});

  @override
  List<Object> get props => [blogs, hasReachedMax, uid];

  SearchBlogsLoaded copyWith({
    List<Blogs> blogs,
    bool hasReachedMax,
  }) {
    return SearchBlogsLoaded(
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
class SearchBlogsNotLoaded extends SearchBlogsState {
  @override
  String toString() => 'blogsNotLoaded';
}

class SearchUploadImageSuccess extends SearchBlogsState {
  @override
  String toString() {
    return 'Blogs loading';
  }
}
