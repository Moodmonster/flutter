import 'package:flutter/material.dart';
import 'package:moodmonster/feature/home/home_screen_view.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: HomeScreen(),
        //하단 네비게이션바
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          unselectedItemColor: AppColors.lightBlack,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.mainTextColor,

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'home',
              backgroundColor: AppColors.background,
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
      ),
    );
  }
}
