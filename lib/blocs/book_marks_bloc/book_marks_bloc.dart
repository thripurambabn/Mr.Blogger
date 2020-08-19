import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/book_marks_bloc/book_marks_event.dart';
import 'package:mr_blogger/blocs/book_marks_bloc/book_marks_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';

class BookMarkBloc extends Bloc<BookMarkEvent, BookMarksState> {
  final BlogsService _blogsService;
  final ProfileService _profileService;
//constructore for profile Bloc
  BookMarkBloc(
      {@required ProfileService profileService,
      @required BlogsService blogsService})
      : assert(profileService != null),
        _blogsService = blogsService,
        _profileService = profileService;

  @override
  BookMarksState get initialState => BookMarkedBlogLoading();

//mapping profile events to profile state
  @override
  Stream<BookMarksState> mapEventToState(BookMarkEvent event) async* {
    if (event is BookMarkedBlogs) {
      yield* _mapBookMarkedBlogsToState(event);
    }
  }

  Stream<BookMarksState> _mapBookMarkedBlogsToState(
      BookMarkedBlogs event) async* {
    try {
      List<Blogs> bookMarkedBlogslist =
          await _profileService.getBookMarkedDetails();
      yield BookMarkedBlogLoaded(bookMarkedBlogslist);
    } catch (e) {
      print(e);
    }
  }
}
