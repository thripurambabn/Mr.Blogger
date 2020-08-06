import 'package:equatable/equatable.dart';

abstract class BookMarkEvent extends Equatable {
  const BookMarkEvent();
  @override
  List<Object> get props => [];
}

//Loading Profile Details event
class BookMarkedBlogLoadingEvent extends BookMarkEvent {
  @override
  String toString() => 'loadprofile ';
}

class BookMarkedBlogs extends BookMarkEvent {
  const BookMarkedBlogs();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'BookMarkedBlogs';
}
