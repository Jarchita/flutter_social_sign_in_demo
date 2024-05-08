import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../blocs/base/base_bloc.dart';
import '../../../services/service_locator.dart';



/// @Purpose: wrapper consumer screen class for bloc provider
class BaseScreen<T extends BaseBloc> extends StatefulWidget {
  const BaseScreen({
    required this.builder,
    required this.onBlocReady,
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext context, T bloc, Widget? child) builder;
  final Function(T) onBlocReady;

  @override
  _BaseScreenState<T> createState() => _BaseScreenState<T>();
}

class _BaseScreenState<T extends BaseBloc> extends State<BaseScreen<T>> {
  T bloc = locator<T>();

  @override
  void initState() {
    widget.onBlocReady(bloc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<T>.value(
      value: bloc, child: Consumer<T>(builder: widget.builder));
}
