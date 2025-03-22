import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/config/routes/routes.dart';
import 'package:moodmonster/dumyData/contentDumyData.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/helpers/constants/app_typography.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/providers/novel_provider.dart';
import 'package:moodmonster/providers/webtoon_provider.dart';

class ContentScreen extends ConsumerWidget {
  final MyContentType contentType;

  ContentScreen({super.key, required this.contentType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentState =
        (contentType == MyContentType.Webtoon)
            ? ref.watch(WebtoonProvider) //웹툰이면 웹툰프로바이더 가져오고
            : ref.watch(NovelProvider); // 소설이면 소설 프로바이더 가져온다
    return contentState.when(
      data: (contents) {
        //콘텐츠들 중 clickCount가 가장 큰 놈을 mainContent로 지정
        final mainContent =
            contents.isNotEmpty
                ? contents.reduce(
                  (a, b) => a.clickCount >= b.clickCount ? a : b,
                )
                : null;

        return _buildContentScreen(context, contents, mainContent);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) {
        print("소설 데이터 로드 실패: $error");
        return Center(child: Text('에러 발생: $error'));
      },
    );
  }

  Widget _buildContentScreen(
    BuildContext context,
    List<Content> contentList,
    Content? mainContent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
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
          SizedBox(height: 3.h),

          // 대표 콘텐츠 이미지
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                if (mainContent != null) {
                  AppRouter.pushNamed(
                    Routes.episodeListScreen,
                    args: mainContent,
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    mainContent != null && mainContent.thumbnailUrl.isNotEmpty
                        ? Image.network(
                          mainContent.thumbnailUrl,
                          width: double.infinity,
                          height: 280.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/imgs/default_img.jpg",
                              width: double.infinity,
                              height: 280.h,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                        : Image.asset(
                          "assets/imgs/default_img.jpg",
                          width: double.infinity,
                          height: 280.h,
                          fit: BoxFit.cover,
                        ),

                    // 제목과 설명
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              mainContent.desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
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

          SizedBox(height: 10.h),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "총 ${contentList.length} 작품",
              style: TextStyle(fontSize: 13, color: AppColors.descTextColor),
            ),
          ),
          SizedBox(height: 8.h),

          ContentMainGridList(contentList: contentList),

          SizedBox(height: 16.h),
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
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: contentList.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 한 줄에 3개씩 배치
        crossAxisSpacing: 12, // 가로 간격
        mainAxisSpacing: 14, // 세로 간격
        childAspectRatio: 0.8, // 아이템의 가로세로 비율
      ),
      itemBuilder: (context, index) {
        final content = contentList[index];
        return ContentCard(content: content);
      },
    );
  }
}

//콘텐츠 모양(직사각형) 하나하나
class ContentCard extends ConsumerWidget {
  final Content content;
  const ContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            spreadRadius: 0,
            blurRadius: 8.w,
            offset: Offset(2.w, 6.h),
          ),
        ],
      ),
      child: GestureDetector(
        //클릭감지
        onTap: () async {
          //콘텐츠가 소설이면
          if (content.contentType == MyContentType.Novel) {
            await ref
                .read(NovelProvider.notifier)
                .clickCountPlusOne(code: content.code); // 클릭수 증가 함수 호출
          } else {
            //콘텐츠가 웹툰이면
            await ref
                .read(WebtoonProvider.notifier)
                .clickCountPlusOne(code: content.code); // 클릭수 증가 함수 호출
          }
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
              Image.network(
                content.thumbnailUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                //오류 발생 시 기본 이미지 보이도록
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/imgs/default_img.jpg",
                    width: double.infinity,
                    height: 280.h,
                    fit: BoxFit.cover,
                  );
                },
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
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
