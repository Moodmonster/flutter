import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodmonster/app_bootstrapper.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/helpers/constants/app_themes.dart';
import 'package:seo_renderer/seo_renderer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppBootstrapper.init(runApp: runApp);
}

class MoodMonster extends StatelessWidget {
  const MoodMonster({super.key});

  @override
  Widget build(BuildContext context) {
    return RobotDetector(
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Mood Monster',
                theme: AppTheme.light(),
                darkTheme: AppTheme.light(),
                onGenerateRoute: AppRouter.generateRoute,
                navigatorKey: AppRouter.navigatorKey,
                navigatorObservers: [seoRouteObserver],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ko', 'KR'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
