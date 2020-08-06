import 'package:equatable/equatable.dart';
import 'package:mr_blogger/models/blogs.dart';

abstract class BookMarksState extends Equatable {
  const BookMarksState();
  @override
  List<Object> get props => [];
}

//Profile Loading state
class BookMarkedBlogLoading extends BookMarksState {
  @override
  String toString() {
    return 'Profile loading';
  }
}

class BookMarkedBlogLoaded extends BookMarksState {
  final List<Blogs> blogs;
  BookMarkedBlogLoaded(this.blogs);
  @override
  List<Object> get props => [
        blogs,
      ];
  @override
  String toString() => 'profilenotloaded';
}

//Profile Not  state
class BookMarkedBlogNotLoaded extends BookMarksState {
  @override
  String toString() => 'profilenotloaded';
}
