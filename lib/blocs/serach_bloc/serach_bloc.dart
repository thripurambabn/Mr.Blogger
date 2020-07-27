import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/serach_bloc/search_event.dart';
import 'package:mr_blogger/blocs/serach_bloc/search_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/blog_service.dart';

class SearchBlogsBloc extends Bloc<SearchBlogsEvent, SearchBlogsState> {
  @override
  SearchBlogsState get initialState => SearchBlogsLoading();

  @override
  Stream<SearchBlogsState> mapEventToState(SearchBlogsEvent event) async* {
    if (event is SearchBlog) {
      yield* _mapSerachBlogToState(event);
    }
  }

  Stream<SearchBlogsState> _mapSerachBlogToState(SearchBlog event) async* {
    try {
      var _blogsService = BlogsService();
      print('in search bloc ${event.searchkey}');
      final List<Blogs> blog = await _blogsService.searchBlogs(event.searchkey);
      yield SearchBlogsLoaded(blogs: blog, hasReachedMax: true);
    } catch (e) {
      print(e);
    }
  }
}
