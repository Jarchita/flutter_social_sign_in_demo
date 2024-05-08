part of 'login_bloc.dart';

abstract class LoginEvent extends BaseEvent {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class SocialLogin extends LoginEvent {
  const SocialLogin(this.type);

  final String type;
  @override
  List<Object> get props => [type];
}

class Logout extends LoginEvent {
  const Logout();
  @override
  List<Object> get props => [];
}
