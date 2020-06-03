import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_event.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/models/user.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';

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
      Users userdata = await _profileService.getUserdata();
      print('in bloc ${userdata.email}');
      List<Blogs> profileblogslist = await _profileService.getblogs();
      yield ProfileLoaded(profileblogslist);
    } catch (e) {
      yield ProfileNotLoaded();
    }
  }

  Stream<ProfileState> _mapLoadProfileToState() async* {
    print('load blogs in blogs_bloc.dart');
  }
}
