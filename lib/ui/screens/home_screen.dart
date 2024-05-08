import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_signin_demo/blocs/home/home_bloc.dart';

import '../../../blocs/base/base_bloc.dart';

import '../../mixins/utility_mixin.dart';

import 'base_screen.dart';

 const Color colorPrimary = Color(0xffF4833D);

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key}) : super(key: key);


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with UtilityMixin {
  late HomeBloc _bloc;

  final TextEditingController _emailController = TextEditingController();
  bool _isExternalLogin = true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return BaseScreen<HomeBloc>(
      onBlocReady: (bloc) {
        _bloc = bloc;
      },
      builder: (context, bloc, child) => BlocListener<HomeBloc, BaseState>(
        listener: (context, state) {
          if (state is HomeSuccessState) {
            _emailController.text = state.data;
          }
          if (state is FailedState) {
            showSnackBar(context,  "Something went wrong");
          }
        },
        child: GestureDetector(
          onTap: () => hideKeyboard(context),
          child: Scaffold(
            backgroundColor: Colors.blueGrey.withOpacity(0.1),
            appBar:AppBar(
              title: const SizedBox(
                height: 30,
                child: Text("Social Login",style: TextStyle(color: colorPrimary),),
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - (190)),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          const Text(
                             "Welcome!",
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _profileView(),

                        ],
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileView() => Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ///email
            Text(_emailController.text),
            _vSpacer(20),
          ],
        ),
      );


  SizedBox _vSpacer(double height) => SizedBox(
        height: height,
      );
}
