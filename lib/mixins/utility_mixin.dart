import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/// Purpose : mixin for all common utility methods
mixin UtilityMixin {
  static String tag = "UtilityMixin";

  /// Purpose : clear back stack of the screen and place on the top
  void clearStackAndAddScreen(BuildContext context, Widget screen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen), (route) => false);
  }

  void clearStackAndAddNamedRoute(BuildContext context, String route) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }


  /// Purpose : function to hide keyboard
  void hideKeyboard(BuildContext context) =>
      FocusScope.of(context).requestFocus(FocusNode());

  ///Purpose : navigate to next screen and not manage stack
  void navigationPushReplacement(BuildContext context, Widget routeName) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => routeName,
      ),
    );
  }

  ///Purpose : navigate to next screen and manage back press
  Future<dynamic> navigationPush(BuildContext context, Widget screen) async =>
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => screen,
        ),
      );


  /// Purpose : method to display snack bar of common types
  void showSnackBar(BuildContext context, String message,
      { int? duration}) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,),
      margin: const EdgeInsets.all(15),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      duration: Duration(seconds: duration ?? 4),
      backgroundColor: Colors.blueGrey,
    ));
  }









}
