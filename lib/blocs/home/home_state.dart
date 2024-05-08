part of 'home_bloc.dart';

abstract class HomeState extends BaseState {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeSuccessState extends HomeState {
  const HomeSuccessState({
    this.data,
  });

  final dynamic data;

  @override
  List<Object> get props => <Object>[data];
}
