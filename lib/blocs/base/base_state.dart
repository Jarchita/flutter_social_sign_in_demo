part of 'base_bloc.dart';

@immutable
abstract class BaseState extends Equatable {
  const BaseState();
  @override
  List<Object> get props => [];
}

class InitialState extends BaseState {
  @override
  List<Object> get props => [];
}

class LoadingState extends BaseState {
  const LoadingState({this.isLoading = true}) : super();
  final bool isLoading;
  @override
  List<Object> get props => [isLoading];
}

class SuccessState extends BaseState {
  const SuccessState({this.data, this.isRefresh = true});

  final dynamic data;
  final bool isRefresh;

  @override
  List<Object> get props => <Object>[data, isRefresh];
}

class FailedState extends BaseState {
  const FailedState({this.msg});

  final String? msg;

  @override
  List<Object> get props => <Object>[msg!];
}

class ConnectionFailedState extends BaseState {
  const ConnectionFailedState({this.disconnected = true});

  final bool disconnected;

  @override
  List<Object> get props => <Object>[disconnected];
}


