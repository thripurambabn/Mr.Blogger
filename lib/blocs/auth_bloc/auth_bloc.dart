import 'package:bloc/bloc.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_event.dart';
import 'package:mr_blogger/blocs/auth_bloc/auth_state.dart';
import 'package:mr_blogger/service/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserService userService;
  AuthBloc() {
    this.userService = UserService();
  }
  @override
  // TODO: implement initialState
  AuthState get initialState => throw ApploadingState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    // TODO: implement mapEventToState
    if (event is ApploadingEvent) {
      try {
        var isSignedIn = await userService.isSignedIn();
        if (isSignedIn) {
          var user = await userService.getCuurentUser();
          yield AppLoadedState(user: user);
        } else {
          yield AppErrorstate();
        }
      } catch (e) {
        yield AppErrorstate();
      }
    }
  }
}
