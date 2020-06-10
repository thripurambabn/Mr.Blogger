import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final BlogsService _blogsService;
  final ProfileService _profileService;
//constructore for profile Bloc
  ProfileBloc(
      {@required ProfileService profileService,
      @required BlogsService blogsService})
      : assert(profileService != null),
        _blogsService = blogsService,
        _profileService = profileService;

  @override
  ProfileState get initialState => ProfileLoading();

//mapping profile events to profile state
  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadingProfileDetails) {
      yield* _mapLoadedProfileState();
    } else if (event is LoadedProfileDeatils) {
      yield* _mapLoadedProfileState();
    } else if (event is DeleteBlog) {
      yield* _mapDeletedBlogToState(event);
    }
  }

//mapping LoadingProfileDetails event with states
  Stream<ProfileState> _mapLoadedProfileState() async* {
    yield ProfileLoading();
    // try {
    UserService _userService = new UserService();
    print('in profile bloc calling get blogs ');
    List<Blogs> profileblogslist = await _profileService.getblogs();
    print('profile get blogs in servcie ${profileblogslist}');
    // print('${_userService.save()}');
    await _userService.read();
    await _userService.save();
    final test = await _userService.save();

    yield ProfileLoaded(profileblogslist, test.displayName, test.email);
  }
  // catch (e) {
  //   yield ProfileNotLoaded();
  // }
  // }

  Stream<ProfileState> _mapDeletedBlogToState(DeleteBlog event) async* {
    try {
      print('in bloc');
      await _profileService.deleteBlog(event.key);
      print('called delete blog ${event.key}');
    } catch (e) {
      print(e);
    }
  }
  // Stream<ProfileState> _mapLoadProfileToState() async* {
  //   print('load blogs in blogs_bloc.dart');
  // }
}
