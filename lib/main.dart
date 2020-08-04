import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_state.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/other_user_profile_bloc/other_user_profile_bloc.dart';
import 'package:mr_blogger/blocs/other_user_profile_details_bloc/other_user_profile_details_bloc.dart';
import 'package:mr_blogger/blocs/profile_bloc/profile_bloc.dart';
import 'package:mr_blogger/blocs/serach_bloc/serach_bloc.dart';
import 'package:mr_blogger/service/Profile_Service.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/Home_Screen/home_screen.dart';
import 'package:mr_blogger/view/Initial_Screen/initial_screen.dart';
import 'package:mr_blogger/view/Spalsh_Screen/splash_scren.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserService userService = UserService();
  final BlogsService blogsService = BlogsService();
  final ProfileService profileService = ProfileService();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
                  userService: userService,
                )..add(AuthenticationStarted())),
        BlocProvider<BlogsBloc>(
            create: (context) => BlogsBloc(blogsService: blogsService)),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
              profileService: profileService, blogsService: blogsService),
        ),
        BlocProvider<OtherUserProfileBloc>(
          create: (context) => OtherUserProfileBloc(
              profileService: profileService, blogsService: blogsService),
        ),
        BlocProvider<OtherUserProfileDetailsBloc>(
          create: (context) => OtherUserProfileDetailsBloc(
              profileService: profileService, blogsService: blogsService),
        ),
        BlocProvider<SearchBlogsBloc>(create: (context) => SearchBlogsBloc()),
      ],
      child: App(
        userService: userService,
        blogsService: blogsService,
      ),
    ),
  );
}

class App extends StatelessWidget {
  final UserService _userService;
  final BlogsService _blogsService;
  App(
      {Key key,
      @required UserService userService,
      @required BlogsService blogsService})
      : assert(userService != null),
        _userService = userService,
        _blogsService = blogsService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return InitialScreen(
              userService: _userService,
            );
          }
          if (state is AuthenticationSuccess) {
            return Homepage();
          }
          return SplashPage();
        },
      ),
    );
  }
}
