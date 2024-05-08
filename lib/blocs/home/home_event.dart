part of 'home_bloc.dart';

abstract class HomeEvent extends BaseEvent {
  const HomeEvent();
}

class GetHomeEvent extends HomeEvent {
  const GetHomeEvent();

  @override
  List<Object?> get props => [];
}


