import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_colors.dart';
import '../../app_router.dart';
import '../../blocs/base/base_bloc.dart';
import '../../blocs/login/login_bloc.dart';
import '../../mixins/utility_mixin.dart';
import '../widgets/loader_view.dart';


/// Purpose : login screen of the app
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with  UtilityMixin {
  late LoginBloc _bloc;
  final _sidePadding = 25.0;


  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<LoginBloc>(context);
    return BlocListener<LoginBloc, BaseState>(
      listener: (context, state) {
        if (state is SuccessState) {
          //do redirection
          // showSnackBar(context, "Success!");
          clearStackAndAddNamedRoute(context, RouteConstants.homeRoute);
        }

        if (state is FailedState) {
          showSnackBar(context,  "Something went wrong.");
        }
      },
      child: GestureDetector(
        onTap: () => hideKeyboard(context),
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                 color: Colors.grey.withOpacity(0.1)
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _logo(),
                      _buildLoginView(),
                    ],
                  ),
                ),
              ),
              const LoaderView<LoginBloc>(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() => Container(
      padding: const EdgeInsets.only(
        top: 100,
        bottom: 45,
      ),
     );

  Widget _buildLoginView() => Padding(
        padding: EdgeInsets.symmetric(horizontal: _sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _vSpacer(30),
            _socialLoginView(),
            _vSpacer(10),
          ],
        ),
      );


  Widget _socialLoginView() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (Platform.isIOS)
                  _buildSocialBtn('ic_apple.svg', _onAppleLogin),
                _buildSocialBtn("ic_facebook.svg", _onFbLogin),
                _buildSocialBtn("ic_google.svg", _onGoogleLogin),
              ],
            ),
          ],
        ),
      );

  Widget _buildSocialBtn(String asset, VoidCallback onTap) {
    final btnWidth = MediaQuery.of(context).size.width / 5;
    final btnHeight = btnWidth - 25;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: btnHeight,
        width: btnWidth,
        margin: const EdgeInsets.symmetric(horizontal: 7.5),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              // Shadows.cardShadow,
            ],
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
            child: SvgPicture.asset(
          asset,
          height: btnHeight / 2.6,
        )),
      ),
    );
  }


  SizedBox _vSpacer(double height) => SizedBox(
        height: height,
      );




  void _onFbLogin() {
    _bloc.add(const SocialLogin(AuthProvider.fb));
  }

  void _onGoogleLogin() {
    _bloc.add(const SocialLogin(AuthProvider.google));
  }

  void _onAppleLogin() {
    _bloc.add(const SocialLogin(AuthProvider.apple));
  }
}
