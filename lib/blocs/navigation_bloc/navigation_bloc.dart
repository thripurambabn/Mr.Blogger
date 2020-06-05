// class NavigatorBloc extends Bloc<BlocBloc, dynamic> {
//   final GlobalKey<NavigatorState> navigatorKey;
//   NavigatorBloc({this.navigatorKey});

//   @override
//   dynamic get initialState => 0;

//   @override
//   Stream<dynamic> mapEventToState(NavigatorAction event) async* {
//     if (event is NavigatorActionPop) {
//       navigatorKey.currentState.pop();
//     } else if (event is NavigateToHomeEvent) {
//       navigatorKey.currentState.pop;
//     }
//   }
// }
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  // void goBack() {
  //   return navigatorKey.currentState.pop();
  // }
}
