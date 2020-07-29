import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
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
    if (event is LoadedProfileDeatils) {
      yield* _mapLoadedProfileState(event);
    } else if (event is EditProfile) {
      yield* _mapEditProfileToState(event);
    }
  }

//mapping Loading Profile Details event with states
  Stream<ProfileState> _mapLoadedProfileState(
      LoadedProfileDeatils event) async* {
    yield ProfileLoading();
    try {
      var test = await _profileService.getProfileDetails(event.uid);
      print('profile_ui ${test.uid}');
      List<Blogs> profileblogslist = await _profileService.getblogs();

      yield ProfileLoaded(profileblogslist, test.displayName, test.email,
          test.uid, test.imageUrl, test.followers);
    } catch (e) {
      print(e);
    }
  }

//mapping Edit Profile To State event with states
  Stream<ProfileState> _mapEditProfileToState(EditProfile event) async* {
    try {
      await _profileService.editProfile(event.name, event.imageUrl);
      List<Blogs> profileblogslist = await _profileService.getblogs();
      UserService _userService = new UserService();
      await _userService.read();
      final test = await _userService.save();
      yield ProfileLoaded(profileblogslist, test.displayName, test.email,
          test.uid, test.imageUrl, test.followers);
    } catch (e) {
      print(e);
      yield ProfileNotLoaded();
    }
  }
}
