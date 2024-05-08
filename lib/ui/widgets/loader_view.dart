import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app_colors.dart';
import '../../blocs/base/base_bloc.dart';



/// Purpose : this widget will display loader view based on the received state
class LoaderView<T extends BaseBloc> extends StatelessWidget {
  const LoaderView({this.loader, Key? key}) : super(key: key);

  final Widget? loader;

  @override
  Widget build(BuildContext context) => _buildLoader();

  Widget _buildLoader() => BlocBuilder<T, BaseState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return state.isLoading
                ? (loader ?? CustomLoader.normal())
                : Container();
          }
          return Container();
        },
      );
}

// ignore: avoid_classes_with_only_static_members
/// Purpose : class for custom loading indicators used in the app
class CustomLoader {
  static Widget small() => AbsorbPointer(
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: _progressIndicator(stroke: 2),
          ),
        ),
      );

  static Widget normal() => AbsorbPointer(
        child: Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: _progressIndicator(),
          ),
        ),
      );

  static Widget big() => AbsorbPointer(
        child: Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: _progressIndicator(),
          ),
        ),
      );

  static Widget _progressIndicator({double? stroke}) => AbsorbPointer(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: stroke ?? 3,
        ),
      );

  static Widget footer() => Container()/*CustomFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        builder: (context, mode) => mode == LoadStatus.loading
            ? SizedBox(
                height: 55,
                child: Center(
                    child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: _progressIndicator(),
                  ),
                )),
              )
            : Container(),
      )*/;
}
