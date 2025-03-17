import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodmonster/app_bootstrapper.dart';
import 'package:moodmonster/common/mood_colors.dart';
import 'package:moodmonster/common/mood_fonts.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/feature/home/home_screen_view.dart';
import 'package:moodmonster/helpers/constants/app_themes.dart';
import 'package:moodmonster/pages/novel.page_view.dart';
import 'package:moodmonster/pages/webtoon.page_view.dart';
import 'package:seo_renderer/seo_renderer.dart';

class MoodMonsterMainScreen extends StatefulWidget {
  const MoodMonsterMainScreen({super.key});

  @override
  State<MoodMonsterMainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MoodMonsterMainScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoodColors.background,
      body: HomeScreen(),
      //하단 네비게이션바
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: MoodColors.hintGrey,
        backgroundColor: MoodColors.background,
        selectedItemColor: MoodColors.mainTextColor,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'home',
            backgroundColor: MoodColors.background,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage_rounded),
            label: 'storage',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'my'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
