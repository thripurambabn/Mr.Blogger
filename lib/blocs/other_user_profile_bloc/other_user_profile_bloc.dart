import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/other_user_profile_bloc/other_user_profile_event.dart';
import 'package:mr_blogger/blocs/other_user_profile_bloc/other_user_profile_state.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';

class OtherUserProfileBloc
    extends Bloc<OtherUserProfileDetailsEvent, OtherUserProfileState> {
  final BlogsService _blogsService;
  final ProfileService _profileService;
//constructore for profile Bloc
  OtherUserProfileBloc(
      {@required ProfileService profileService,
      @required BlogsService blogsService})
      : assert(profileService != null),
        _blogsService = blogsService,
        _profileService = profileService;

  @override
  // TODO: implement initialState
  OtherUserProfileState get initialState => OtherUserProfileLoading();
//mapping profile events to profile state
  @override
  Stream<OtherUserProfileState> mapEventToState(
      OtherUserProfileDetailsEvent event) async* {
    if (event is OtherUserProfileEvent) {
      yield* _mapFollowersProfileToState(event);
    }
  }

  //mapping Loading Profile Details event with states
  Stream<OtherUserProfileState> _mapFollowersProfileToState(
      OtherUserProfileEvent event) async* {
    try {
      var test = await _profileService.getFollowersProfileDetails(event.uid);
      UserService _userService = UserService();
      var userData = await _userService.save();

      for (var user in test) {
        print('profile bloc ${user.displayName}');
      }

      yield OtherUserProfileLoaded(test, userData);
    } catch (e) {
      print(e);
    }
  }
}
