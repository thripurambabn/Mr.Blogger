import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_event.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/validators.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserService _userService;

  RegisterBloc({@required UserService userService})
      : assert(userService != null),
        _userService = userService;

  @override
  RegisterState get initialState => RegisterState.initial();

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! RegisterEmailChanged &&
          event is! RegisterPasswordChanged &&
          event is! RegisterusernameChanged);
    });
    final debounceStream = events.where((event) {
      return (event is RegisterEmailChanged ||
          event is RegisterPasswordChanged ||
          event is RegisterusernameChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangedToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangedToState(event.password);
    } else if (event is RegisterusernameChanged) {
      yield* _mapRegisterUsernameToState(event.username);
    } else if (event is RegisterConfirmPasswordChanged) {
      yield* _mapRegisterConfirmPasswordChangedToState(event.confirmPassword);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(
          event.email, event.password, event.username);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapRegisterPasswordChangedToState(
      String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapRegisterConfirmPasswordChangedToState(
      String password) async* {
    yield state.update(
      isConfirmPasswordValid: Validators.isValidConfirmPassword(password),
    );
  }

  Stream<RegisterState> _mapRegisterUsernameToState(String username) async* {
    yield state.update(
      isUsernameValid: Validators.isValidUsername(username),
    );
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
    String email,
    String password,
    String username,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userService.signUp(
        email: email,
        password: password,
        username: username,
      );
      await _userService.read();
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
