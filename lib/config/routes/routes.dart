import 'package:flutter/material.dart';

import '../../feature/auth/login_screen_view.dart';
import '../../feature/error/page_not_found_view.dart';
import '../../feature/home/home_screen_view.dart';

@immutable
class Routes{
  const Routes._();

  static const String initialRoute = '/';
  static const String notFoundScreenRoute = '/page-found-screen';

  static const String loginScreenRoute = '/auth/login';
  static const String homeScreenRoute = '/home';

  static final Map<String, Widget Function()> _routesMap = {
    loginScreenRoute: () => const LoginScreen(),
    notFoundScreenRoute: () => const PageNotFoundScreen(),
    homeScreenRoute: () => const HomeScreen(),
  };

  static Widget Function() getRoute(String? routeName) {
    return routeExist(routeName)
        ? _routesMap[routeName]!
        : _routesMap[Routes.notFoundScreenRoute]!;
  }

  static bool routeExist(String? routeName){
    return _routesMap.containsKey(routeName);
  }
}