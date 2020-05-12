import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/login_bloc/login_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_state.dart';
import 'package:mr_blogger/service/user_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserService userService;
  LoginBloc() {
    this.userService = UserService();
  }
  @override
  // TODO: implement initialState
  LoginState get initialState => LoginIntialState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // TODO: implement mapEventToState
    if (event is LoginSuccessEvent) {
      try {
        yield LoginLoadingState();
        var user = await userService.signIn(event.email, event.password);
        yield LoginLoadedState(user: user);
      } catch (e) {
        yield LoginErrorState(message: e.toString());
      }
    }
  }
}
