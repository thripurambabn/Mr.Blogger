import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_event.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_state.dart';
import 'package:mr_blogger/service/user_service.dart';

// class RegBloc extends Bloc<RegEvent, RegState> {
//   UserService userService;

//   RegBloc({@required UserService userService}) {
//     this.userService = userService;
//   }

//   @override
//   RegState get initialState => RegloadingState();

//   @override
//   Stream<RegState> mapEventToState(RegEvent event) async* {
//     try {
//       if (event is SignUpEvent) {
//         yield RegloadingState();
//         var user = await userService.createuser(event.email, event.password);
//         yield RegLoadedState(user: user);
//       }
//     } catch (e) {
//       yield RegerrorState(message: e.toString());
//     }
//   }
// }
class RegBloc extends Bloc<RegEvent, RegState> {
  UserService userService;

  RegBloc({@required UserService userService}) {
    this.userService = userService;
  }

  @override
  // TODO: implement initialState
  RegState get initialState => RegInitialState();

  @override
  Stream<RegState> mapEventToState(RegEvent event) async* {
    if (event is SignUpEvent) {
      yield RegloadingState();
      try {
        var user = await userService.createuser(event.email, event.password);
        print("BLoC : ${user.email}");
        yield RegLoadedState(user);
      } catch (e) {
        yield RegerrorState(e.toString());
      }
    }
  }
}
