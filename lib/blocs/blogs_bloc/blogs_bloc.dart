import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
import 'package:mr_blogger/service/blog_service.dart';

class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  BlogsService _blogsService;
  // StreamSubscription _todosSubscription;

  BlogsBloc({@required BlogsService blogsService});
  // : assert(blogsService != null),
  //   _blogsService = blogsService;

  @override
  BlogsState get initialState => BlogsLoading();

  @override
  Stream<BlogsState> mapEventToState(BlogsEvent event) async* {
    if (event is LoadBlogs) {
      yield* _mapLoadBlogsToState();
    } else if (event is LoadedBlog) {
      yield* _mapLoadedBlogsState();
    } else if (event is AddBlog) {
      yield* _mapAddBlogState(event);
    } else if (event is UploadImage) {
      yield* _mapUploadImageToState(event);
    }
    //else if (event is SaveToDatabase) {
    //   yield* _mapSaveToDatabaseState(event);
    // }
  }

  Stream<BlogsState> _mapLoadedBlogsState() async* {
    // print('inside loaded blogs');
    // var blogslist = await _blogsService.getblogs();
    //print('inside after loaded blogs  ${blogslist[0].image}');

    await _blogsService.getblogs();
  }

  Stream<BlogsState> _mapLoadBlogsToState() async* {
    print('load blogs in blogs_bloc.dart');
  }

  Stream<BlogsState> _mapAddBlogState(AddBlog event) async* {
    await _blogsService.getblogs();
  }

  Stream<BlogsState> _mapUploadImageToState(UploadImage event) async* {
    print('inside blog upload image ${event.image} ${event.title} ');
    //  final File image;
    //  final String url, title, description, category;
    try {
      await _blogsService.uploadImage(
        url: event.url,
        sampleImage: event.image,
        mytitlevalue: event.title,
        myvalue: event.description,
        category: event.category,
      );
    } catch (e) {
      print('${e.toString()}');
    }
  }
}

// Stream<BlogsState> _mapSaveToDatabaseState(SaveToDatabaseEvent event) async* {
//   print('inisde saving to database bloc ${event.imageurl}');
//   // await _blogsService.saveToDatabase(imageurl)
// }
//}
