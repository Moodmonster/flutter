import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodmonster/core/local/local_storage_base.dart';
import 'package:moodmonster/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

class AppBootstrapper {
  const AppBootstrapper._();

  static Future<void> init({
    required void Function(Widget) runApp,
  }) async {
    setPathUrlStrategy();
    await LocalStorageBase.init();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitDown
    ]);

    runApp(
      const ProviderScope(
        child: MoodMonster()
      )
    );
  }
}