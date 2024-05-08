import 'package:shared_preferences/shared_preferences.dart';


import '../base/base_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends BaseBloc {
  HomeBloc() : super(HomeInitial()) {
    _onEvent();
    add(const GetHomeEvent());
  }

  static String tag = "HomeBloc";

  void _onEvent() {
    on<GetHomeEvent>((event, emit) async {

      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString("email");
      emit(HomeSuccessState(
        data: email,
      ));
    });
  }
}
