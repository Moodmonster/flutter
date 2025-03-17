import 'package:flutter/material.dart';
import 'package:moodmonster/common/mood_colors.dart';
import 'package:moodmonster/common/mood_fonts.dart';
import 'package:moodmonster/pages/novel.page_view.dart';
import 'package:moodmonster/pages/webtoon.page_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: MoodColors.background,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    child: TabBar(
                      tabs: [Tab(text: "WEBTOON"), Tab(text: "NOVEL")],
                      labelStyle: MoodFonts.titleStyleWhite,
                      padding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.label,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                      indicator: BoxDecoration(),
                      dividerColor: Colors.transparent,
                      labelColor: MoodColors.mainTextColor,
                    ),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      IconButton(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_none_rounded,
                          color: MoodColors.mainTextColor,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: MoodColors.mainTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(child: WebToonScreen()),
                  NovelScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
