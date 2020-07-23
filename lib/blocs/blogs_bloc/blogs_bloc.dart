import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';

class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  BlogsService _blogsService = new BlogsService();
  ProfileService _profileService = new ProfileService();
  UserService _userService = new UserService();
  //contructor for blogs bloc
  BlogsBloc({@required BlogsService blogsService});

  @override
  BlogsState get initialState => BlogsLoading();

//mapping blogs events with blogs state
  @override
  Stream<BlogsState> mapEventToState(BlogsEvent event) async* {
    if (event is BlogsLoad && !_hasReachedMax(state)) {
      yield* _mapLoadBlogsToState();
    } else if (event is FetchBlogs) {
      yield* _mapLoadedBlogsState(event, state);
    } else if (event is AddBlog) {
      yield* _mapAddBlogState(event);
    }
    // else if (event is UploadImage) {
    //   yield* _mapUploadImageToState(event);
    //}
    else if (event is SearchBlog) {
      yield* _mapSerachBlogToState(event);
    } else if (event is UpdateBlog) {
      yield* _mapUpdateBlogToState(event);
    } else if (event is BlogLikes) {
      yield* _mapBlogLikesToState(event);
    } else if (event is BlogComments) {
      yield* _mapBlogCommentsToState(event);
    } else if (event is DeleteComments) {
      yield* _mapDeleteCommentsToState(event);
    } else if (event is EditComments) {
      yield* _mapEditCommentsToState(event);
    } else if (event is UploadBlog) {
      yield* _mapUploadBlogToState(event);
    }
  }

//mapping Fetch Blogs event with blogs state
  Stream<BlogsState> _mapLoadedBlogsState(
      FetchBlogs event, BlogsState state) async* {
    final uid = await _userService.save();
    try {
      if (state is BlogsLoading && !_hasReachedMax(state)) {
        yield BlogsLoading();

        List<Blogs> blogslist = await _blogsService.getblogs();
        print('in bloc blogsList ${blogslist}');
        yield BlogsLoaded(blogs: blogslist, hasReachedMax: false, uid: uid.uid);
      } else if (state is BlogsLoaded && !_hasReachedMax(state)) {
        List<Blogs> moreblogslist =
            await _blogsService.getMoreBlogs(state.blogs);

        final testlist = state.blogs + moreblogslist;
        if (moreblogslist.length == 0) {
          state.copyWith(hasReachedMax: true);
          yield BlogsLoaded(
              blogs: state.blogs, hasReachedMax: true, uid: uid.uid);
        } else {
          yield BlogsLoaded(
              blogs: testlist, hasReachedMax: false, uid: uid.uid);
        }
      } else if (state is BlogsLoaded) {
        yield BlogsLoaded(
            blogs: state.blogs, hasReachedMax: true, uid: uid.uid);
      }
    } catch (_) {
      yield BlogsNotLoaded();
    }
  }

//reached end of the scroller
  bool _hasReachedMax(BlogsState state) =>
      state is BlogsLoaded && state.hasReachedMax;

//mapping load Blog event with blogs state
  Stream<BlogsState> _mapLoadBlogsToState() async* {
    print('load blogs in blogs_bloc.dart');
  }

//mapping add blog event with blogs state
  Stream<BlogsState> _mapAddBlogState(AddBlog event) async* {
    final List<Blogs> blog = await _blogsService.getblogs();
    yield BlogsLoaded(blogs: blog, hasReachedMax: false);
  }

  Stream<BlogsState> _mapSerachBlogToState(SearchBlog event) async* {
    try {
      print('in search bloc ${event.searchkey}');
      final List<Blogs> blog = await _blogsService.searchBlogs(event.searchkey);
      yield BlogsLoaded(blogs: blog, hasReachedMax: true);
    } catch (e) {
      print(e);
    }
  }

//mapping update blog event with blogs state
  Stream<BlogsState> _mapUpdateBlogToState(UpdateBlog event) async* {
    try {
      print('mapping update event to state ${event.image}');
      await _profileService.updateImage(
          //  url: event.url,
          sampleImage: event.image,
          mytitlevalue: event.title,
          myvalue: event.description,
          category: event.category,
          blogtimeStamp: event.timeStamp,
          blogPrivacy: event.blogPrivacy);
      final List<Blogs> blog = await _blogsService.getblogs();
      print('calling blogs loading');
      yield BlogsLoaded(blogs: blog, hasReachedMax: false);
    } catch (e) {
      print(e);
    }
  }

  Stream<BlogsState> _mapBlogLikesToState(BlogLikes event) async* {
    try {
      var user = await _userService.save();
      print('in bloc ${event.likes}');
      await _blogsService.setLikes(event.timeStamp, user.uid, event.likes);
      // final List<Blogs> blog = await _blogsService.getblogs();
      // yield BlogsLoaded(blogs: blog, hasReachedMax: false);
    } catch (e) {
      print(e);
    }
  }

  Stream<BlogsState> _mapBlogCommentsToState(BlogComments event) async* {
    try {
      var user = await _userService.save();
      await _blogsService.setComments(
          event.timeStamp, event.comment, user.uid, event.comments);
    } catch (e) {
      print(e);
    }
  }

  Stream<BlogsState> _mapUploadBlogToState(UploadBlog event) async* {
    try {
      print('upload blog bloc ${event.category}');
      await _blogsService.saveToDatabase(event.url, event.title,
          event.description, event.category, event.blogPrivacy);
      final List<Blogs> blog = await _blogsService.getblogs();
      yield BlogsLoaded(blogs: blog, hasReachedMax: false);
    } catch (e) {
      print('${e.toString()}');
    }
  }

  Stream<BlogsState> _mapDeleteCommentsToState(DeleteComments event) async* {
    try {
      var user = await _userService.save();
      await _blogsService.deleteComments(
        event.blogsTimeStamp,
        event.commentTimeStamp,
      );
    } catch (e) {
      print(e);
    }
  }

  Stream<BlogsState> _mapEditCommentsToState(EditComments event) async* {
    try {
      //  var user = await _userService.save();
      print(
          'values in edit comment bloc timeStamp${event.blogsTimeStamp},comment${event.commentTimeStamp} ${event.comment}');

      await _blogsService.editComments(
          event.blogsTimeStamp, event.commentTimeStamp, event.comment);
    } catch (e) {
      print(e);
    }
  }
}
