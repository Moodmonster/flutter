import 'package:flutter/material.dart';
import 'package:moodmonster/config/routes/routes.dart';
import 'package:moodmonster/dumyData/contentDumyData.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/helpers/constants/app_typography.dart';
import 'package:moodmonster/models/content.model.dart';

class ContentScreen extends StatelessWidget {
  final MyContentType contentType;
  ContentScreen({super.key, required this.contentType});

  //콘텐츠 더미데이터 가져온다
  final contentList = ContentDumyData;

  //Days? selectedDay = getCurrentDay(); //우선 현재 요일로 초기화
  @override
  Widget build(BuildContext context) {
    //컨텐츠 타입에 맞는 데이터만 가져온다
    final contentTypeFilteredList =
        contentList
            .where((content) => content.contentType == contentType)
            .toList();
    //맨 위에 크게 보여줄 작품 하나 고른다
    final Content? mainContent =
        contentTypeFilteredList.isNotEmpty ? contentTypeFilteredList[0] : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "🔥HOT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.mainTextColor,
              ),
            ),
          ),
          //맨 위 대표 웹툰 정보 표시
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: GestureDetector(
              onTap: () {
                if (mainContent != null) {
                  Navigator.pushNamed(
                    context,
                    Routes.episodeListScreen, // /episodes 경로로 이동
                    arguments: mainContent, // 컨텐츠 정보 전달해준다
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    mainContent != null
                        ? Image.asset(
                          mainContent.thumbnailUrl,
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
                    if (mainContent != null)
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
                              mainContent.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              mainContent.desc,
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

          SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "총 ${contentTypeFilteredList.length} 작품",
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ),
          SizedBox(height: 4),
          ContentMainGridList(contentList: contentTypeFilteredList),
        ],
      ),
    );
  }
}

class ContentMainGridList extends StatelessWidget {
  //콘텐츠 데이터 리스트
  final List<Content> contentList;
  ContentMainGridList({super.key, required this.contentList}) {}

  @override
  Widget build(BuildContext context) {
    //return Container(color: Colors.red, height: 200);
    //리스트에 아무 콘텐츠도 없으면
    if (contentList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Icon(Icons.folder_off_outlined, color: AppColors.mainTextColor),
            Text(
              "No Data",
              style: AppTypography.subTitle_1.copyWith(
                color: AppColors.mainTextColor,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      itemCount: contentList.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 한 줄에 3개씩 배치
        crossAxisSpacing: 8, // 가로 간격
        mainAxisSpacing: 12, // 세로 간격
        childAspectRatio: 0.8, // 아이템의 가로세로 비율
      ),
      itemBuilder: (context, index) {
        final content = contentList[index];
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
