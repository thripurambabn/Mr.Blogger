import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final BlogsService _blogsService;
  final ProfileService _profileService;

  ProfileBloc(
      {@required ProfileService profileService,
      @required BlogsService blogsService})
      : assert(profileService != null),
        _blogsService = blogsService,
        _profileService = profileService;

  @override
  ProfileState get initialState => ProfileLoading();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadingProfileDetails) {
      yield* _mapLoadedProfileState();
    } else if (event is LoadedProfileDeatils) {
      yield* _mapLoadedProfileState();
    }
  }

  Stream<ProfileState> _mapLoadedProfileState() async* {
    yield ProfileLoading();
    try {
      print('inside try');
      UserService _userService = new UserService();
      // print('in bloc ${userdata.email}');
      List<Blogs> profileblogslist = await _profileService.getblogs();
      print('shareprefernce');
      await _userService.read();
      await _userService.save();
      final test = await _userService.save();
      print('user name in login bloc ${test.displayName}');
      yield ProfileLoaded(profileblogslist, test.displayName, test.email);
    } catch (e) {
      yield ProfileNotLoaded();
    }
  }

  Stream<ProfileState> _mapLoadProfileToState() async* {
    print('load blogs in blogs_bloc.dart');
  }
}
