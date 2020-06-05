import 'package:get_it/get_it.dart';
import 'package:mr_blogger/blocs/navigation_bloc/navigation_bloc.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}
