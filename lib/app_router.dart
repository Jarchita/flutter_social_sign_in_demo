import 'package:flutter/material.dart';

import 'ui/screens/login_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/splash_screen.dart';

/// Purpose : We will provide a route constants here
class RouteConstants {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
}

/// Purpose : This is maned router defined to generate route for the name.
class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) =>
      MaterialPageRoute(builder: (_) {
        switch (settings.name) {
          case RouteConstants.splashRoute:
            return const SplashScreen();
          case RouteConstants.loginRoute:
            return const LoginScreen();
          case RouteConstants.homeRoute:
            return const HomeScreen();

          default:
            return Center(child: Text('No route defined for $settings.name'));
        }
      });
}
