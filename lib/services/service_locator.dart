import 'package:get_it/get_it.dart';

import '../blocs/base/base_bloc.dart';
import '../blocs/login/login_bloc.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator


    // Repos
    ..registerLazySingleton(() => BaseBloc(InitialState()))
    ..registerLazySingleton(() => LoginBloc())
;
}
