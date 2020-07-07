import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_blogger/blocs/login_bloc/login_event.dart';
import 'package:mr_blogger/blocs/login_bloc/login_state.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserService _userService;
//constructor for locgin bloc
  LoginBloc({
    @required UserService userService,
  })  : assert(userService != null),
        _userService = userService;

  @override
  LoginState get initialState => LoginState.initial();

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! LoginEmailChanged && event is! LoginPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is LoginEmailChanged || event is LoginPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

//mapping login state with login event
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged) {
      yield* _mapLoginEmailChangedToState(event.email);
    } else if (event is LoginPasswordChanged) {
      yield* _mapLoginPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    } else if (event is LogOutEvent) {
      yield* _mapLogoutEvent();
    }
  }

//mapping Login Email Changed event with state
  Stream<LoginState> _mapLoginEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
    // _userService.read();
  }

//mapping Login Password Changed event with state
  Stream<LoginState> _mapLoginPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
    //_userService.read();
  }

//mapping Login With Google event with state
  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userService.signInWithGoogle();
      yield LoginState.success();
      _userService.read();
    } catch (_) {
      yield LoginState.failure();
    }
  }

////mapping Login With Credentials event with state
  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
    String userName,
  }) async* {
    yield LoginState.loading();
    try {
      await _userService.signInWithCredentials(email, password);
      await _userService.read();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }

//mapping Logout event with state
  @override
  Stream<LoginState> _mapLogoutEvent() async* {
    _userService.signOut();
    yield LogOutSuccessState();
  }
}
