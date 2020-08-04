import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/other_user_profile_details_bloc/other_user_profile_details_event.dart';
import 'package:mr_blogger/blocs/other_user_profile_details_bloc/other_user_profile_details_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';

class OtherUserProfileDetailsBloc
    extends Bloc<OtherUserProfileDetailsEvent, OtherUserProfileDetailsState> {
  final BlogsService _blogsService;
  final ProfileService _profileService;
//constructore for profile Bloc
  OtherUserProfileDetailsBloc(
      {@required ProfileService profileService,
      @required BlogsService blogsService})
      : assert(profileService != null),
        _blogsService = blogsService,
        _profileService = profileService;

  @override
  OtherUserProfileDetailsState get initialState =>
      OtherUserProfileDetailsLoading();

//mapping profile events to profile state
  @override
  Stream<OtherUserProfileDetailsState> mapEventToState(
      OtherUserProfileDetailsEvent event) async* {
    if (event is LoadedOtherUserProfileDeatils) {
      yield* _mapLoadedProfileToState(event);
    }
  }

//mapping Loading Profile Details event with states
  Stream<OtherUserProfileDetailsState> _mapLoadedProfileToState(
      LoadedOtherUserProfileDeatils event) async* {
    yield OtherUserProfileDetailsLoading();
    try {
      var test = await _profileService.getProfileDetails(event.uid);

      List<Blogs> profileblogslist = await _profileService.getblogs(event.uid);
      print('profile Other user details bloc ${test.displayName}');
      yield OtherUserProfileDetailsLoaded(profileblogslist, test.displayName,
          test.email, test.uid, test.imageUrl, test.following, test.followers);
    } catch (e) {
      print(e);
    }
  }
}
