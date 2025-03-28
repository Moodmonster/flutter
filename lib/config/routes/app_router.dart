import 'package:flutter/material.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/pages/episode_list_screen.page_view.dart';

import './routes.dart';

@immutable
class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    //정적 라우팅
    final routeName = settings.name;
    final routeBuilder =
        Routes.routeExist(routeName)
            ? Routes.getRoute(routeName)
            : Routes.getRoute(Routes.notFoundScreenRoute);

    return MaterialPageRoute<dynamic>(
      builder: (_) => routeBuilder(),
      settings: RouteSettings(name: routeName, arguments: settings.arguments),
    );
  }

  static Future<dynamic> pushNamed(String routeName, {dynamic args}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }

  static Future<dynamic> push(Widget page) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<void> pop([dynamic result]) async {
    navigatorKey.currentState!.pop(result);
  }

  static Future<dynamic> popAndPushNamed(String routeName, {dynamic args}) {
    return navigatorKey.currentState!.popAndPushNamed(
      routeName,
      arguments: args,
    );
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  static void popUntilRoot() {
    navigatorKey.currentState!.popUntil(
      ModalRoute.withName(Routes.homeScreenRoute),
    );
  }
}
