import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_event.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_state.dart';
import 'package:mr_blogger/service/user_service.dart';

class RegBloc extends Bloc<RegEvent, RegState> {
  UserService userService;
  RegBloc() {
    this.userService = UserService();
  }
  @override
  // TODO: implement initialState
  RegState get initialState => RegloadingState();

  @override
  Stream<RegState> mapEventToState(RegEvent event) async* {
    // TODO: implement mapEventToState
    try {
      if (event is SignUpEvent) {
        yield RegloadingState();
        var user = await userService.createuser(event.email, event.password);
        yield RegLoadedState(user: user);
      }
    } catch (e) {
      yield RegerrorState(message: e.toString());
    }
  }
}
