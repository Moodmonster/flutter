import 'package:flutter/material.dart';
import 'package:moodmonster/pages/episode_list_screen.page_view.dart';
import 'package:moodmonster/pages/main_screen.page_view.dart';
import 'package:moodmonster/pages/novel_paragraphs_show_screen.dart';

import '../../feature/auth/login_screen_view.dart';
import '../../feature/error/page_not_found_view.dart';
import '../../feature/home/home_screen_view.dart';
import '../../feature/home/home_screen_view.dart';

@immutable
class Routes {
  const Routes._();

  static const String initialRoute = '/';
  static const String notFoundScreenRoute = '/page-found-screen';

  static const String loginScreenRoute = '/auth/login';
  static const String homeScreenRoute = '/home';
  static const String episodeListScreen = '/episodes';
  static const String novelParagraphsShowScreen = '/episodes/paragraphs';

  static final Map<String, Widget Function()> _routesMap = {
    //initialRoute: () => const MoodMonsterMainScreen(),
    initialRoute: () => const HomeScreen(),
    loginScreenRoute: () => const LoginScreen(),
    notFoundScreenRoute: () => const PageNotFoundScreen(),
    homeScreenRoute: () => const HomeScreen(),
    episodeListScreen: () => const EpisodeListScreen(),
    novelParagraphsShowScreen: () => const NovelParagraphsShowScreen(),
  };

  static Widget Function() getRoute(String? routeName) {
    return routeExist(routeName)
        ? _routesMap[routeName]!
        : _routesMap[Routes.notFoundScreenRoute]!;
  }

  static bool routeExist(String? routeName) {
    return _routesMap.containsKey(routeName);
  }
}
