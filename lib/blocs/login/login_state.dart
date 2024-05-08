part of 'login_bloc.dart';

abstract class LoginState extends BaseState {
  const LoginState();
}

class LoginInitial extends BaseState {
  @override
  List<Object> get props => [];
}
