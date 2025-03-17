import 'package:flutter/material.dart';
import 'package:moodmonster/common/mood_colors.dart';
import 'package:moodmonster/common/mood_fonts.dart';
import 'package:moodmonster/config/routes/routes.dart';
import 'package:moodmonster/dumyData/contentDumyData.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/utils/getCurrentDay.dart';

class WebToonScreen extends StatefulWidget {
  WebToonScreen({super.key});

  @override
  State<WebToonScreen> createState() => _WebToonScreenState();
}

class _WebToonScreenState extends State<WebToonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _daySelectTabController;
  //콘텐츠 더미데이터 가져온다
  final webtoonContents = ContentDumyData;
  Days? selectedDay = getCurrentDay(); //우선 현재 요일로 초기화
  @override
  void initState() {
    super.initState();
    _daySelectTabController = TabController(
      vsync: this,
      length: 8,
      initialIndex:
          selectedDay?.index ?? 0, //getCurrentDay에 문제 있으면 일단 월요일 선택되도록
    );
    // Tab 변경 시 selectedDay 업데이트
    _daySelectTabController.addListener(() {
      if (!_daySelectTabController.indexIsChanging) return;
      setState(() {
        //요일 선택 탭에서 선택된 내용이 월~일 요일이라면
        if (_daySelectTabController.index < 7) {
          selectedDay = Days.values[_daySelectTabController.index];
        } // 선택된 탭의 요일 업데이트
        //요일 선택 탭에서 선택된 내용이 월~일 요일이라면
        else {
          selectedDay = null;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //맨 위에 크게 보여줄 웹툰 하나 고른다
    final webtoon = webtoonContents.isNotEmpty ? webtoonContents[0] : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "🔥HOT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: MoodColors.mainTextColor,
              ),
            ),
          ),
          //맨 위 대표 웹툰 정보 표시
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.episodeListScreen, // /episodes 경로로 이동
                  arguments: webtoon, // 컨텐츠 정보 전달해준다
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    webtoon != null
                        ? Image.asset(
                          webtoon.thumbnailUrl,
                          width: double.infinity,
                          height: 280,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          width: double.infinity,
                          height: 280,
                          color: Colors.grey,
                        ),

                    // 제목과 설명 추가
                    if (webtoon != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              webtoon.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              webtoon.desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 350,
            height: 30,
            margin: EdgeInsets.only(bottom: 5),
            child: TabBar(
              controller: _daySelectTabController,
              tabs: [
                Tab(text: "Mon"),
                Tab(text: "Tue"),
                Tab(text: "Wed"),
                Tab(text: "Thu"),
                Tab(text: "Fri"),
                Tab(text: "Sat"),
                Tab(text: "Sun"),
                Tab(text: "Com"), //완결
              ],
              labelStyle: MoodFonts.mediumTextWhite,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.label,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
              //indicator: BoxDecoration(),
              indicatorColor: MoodColors.mainTextColor,
              dividerColor: Colors.transparent,
              labelColor: MoodColors.mainTextColor,
            ),
          ),
          ContentMainGridList(selectedDay: selectedDay),
        ],
      ),
    );
  }
}

class ContentMainGridList extends StatelessWidget {
  final Days? selectedDay;
  //선택한 요일에 해당하는 콘텐츠 데이터만 저장
  late List<Content> contentsFilteredByDay;
  ContentMainGridList({super.key, required this.selectedDay}) {
    //선택 요일이 있을경우 = 완결웹툰 아닌 특정 요일 웹툰 표시하는 경우 일 때
    if (selectedDay != null)
      contentsFilteredByDay =
          ContentDumyData.where(
            (data) => data.releaseDay == selectedDay,
          ).toList(); //생성자에서 webtoonContentsFilteredByDay초기화
    else {
      //완결작들 보여줘야 하면
      contentsFilteredByDay =
          ContentDumyData.where((data) => data.isCompleted).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    //return Container(color: Colors.red, height: 200);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: contentsFilteredByDay.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 한 줄에 3개씩 배치
        crossAxisSpacing: 8, // 가로 간격
        mainAxisSpacing: 12, // 세로 간격
        childAspectRatio: 0.8, // 아이템의 가로세로 비율
      ),
      itemBuilder: (context, index) {
        final content = contentsFilteredByDay[index];
        return ContentCard(content: content);
      },
    );
  }
}

class ContentCard extends StatelessWidget {
  final Content content;
  const ContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //클릭감지
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.episodeListScreen, // /episodes 경로로 이동
          arguments: content, // 컨텐츠 정보 전달해준다
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // 웹툰 이미지
            Image.asset(
              content.thumbnailUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // 반투명 검은색 배경
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 웹툰 제목
                  Text(
                    content.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 작가명
                  Text(
                    content.author,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
