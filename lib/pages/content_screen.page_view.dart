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
import 'package:shimmer/shimmer.dart';

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
        // 콘텐츠들을 title의 알파벳순으로 정렬 (대소문자 구분 없이)
        final sortedContents = [...contents]..sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        //콘텐츠들 중 clickCount가 가장 큰 놈을 mainContent로 지정
        final mainContent =
            contents.isNotEmpty
                ? contents.reduce(
                  (a, b) => a.clickCount >= b.clickCount ? a : b,
                )
                : null;

        return _buildContentScreen(context, sortedContents, mainContent);
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, _) {
        print("소설 데이터 로드 실패: $error");
        return Center(child: Text('An error occurred.: $error'));
      },
    );
  }

  Widget _buildContentScreen(
    BuildContext context,
    List<Content> contentList,
    Content? mainContent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/imgs/default_img.jpg",
                              width: double.infinity,
                              height: 280.h,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            );
                          },
                        )
                        : Image.asset(
                          "assets/imgs/default_img.jpg",
                          width: double.infinity,
                          height: 280.h,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
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
              "Total: ${contentList.length} works",
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

//콘텐츠들 바둑판으로 나오는 부분Z
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
        crossAxisSpacing: 15, // 가로 간격
        mainAxisSpacing: 9, // 세로 간격
        childAspectRatio: 0.6, // 아이템의 가로세로 비율
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
    return GestureDetector(
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
      child: Column(
        spacing: 8,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                //그림자
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  spreadRadius: 0,
                  blurRadius: 8.w,
                  offset: Offset(2.w, 4.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
              // 웹툰 이미지
              Image.network(
                content.thumbnailUrl,
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                //오류 발생 시 기본 이미지 보이도록
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/imgs/default_img.jpg",
                    width: double.infinity,
                    height: 280.h,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  );
                },
              ),
            ),
          ),
          // ThumbnailCardWithSkeleton(
          //   imageUrl: content.thumbnailUrl,
          //   borderRadius: 12,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 웹툰 제목
                Text(
                  content.title,
                  style: const TextStyle(
                    color: AppColors.mainTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // 작가명
                Text(
                  content.author,
                  style: const TextStyle(
                    color: AppColors.descTextColor,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//썸네일 이미지(skeleton UI적용)
class ThumbnailCardWithSkeleton extends StatefulWidget {
  final String? imageUrl;
  final double borderRadius;

  const ThumbnailCardWithSkeleton({
    Key? key,
    required this.imageUrl,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  State<ThumbnailCardWithSkeleton> createState() =>
      _ThumbnailCardWithSkeletonState();
}

class _ThumbnailCardWithSkeletonState extends State<ThumbnailCardWithSkeleton> {
  bool _isLoaded = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
          ),

          // 썸네일 이미지
          // 로딩 완료되면 보인다
          ImageWidgetWithFallback(
            imageUrl: widget.imageUrl,
            onLoad: () {
              if (!_isLoaded && mounted) {
                setState(() {
                  _isLoaded = true;
                });
              }
            },
            onError: () {
              if (!_hasError && mounted) {
                setState(() {
                  _hasError = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

//썸네일 이미지 로딩
class ImageWidgetWithFallback extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onLoad;
  final VoidCallback onError;

  const ImageWidgetWithFallback({
    Key? key,
    required this.imageUrl,
    required this.onLoad,
    required this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Image.asset(
        "assets/imgs/default_img.jpg",
        width: double.infinity,
        height: 150.h,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    }

    return Image.network(
      imageUrl!,
      width: double.infinity,
      height: 150.h,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (loadingProgress == null) {
              onLoad();
            }
          });
          return child;
        }
        return const SizedBox(); // 임시 비움
      },
      errorBuilder: (context, error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) => onError());
        return Image.asset(
          "assets/imgs/default_img.jpg",
          width: double.infinity,
          height: 150.h,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );
      },
    );
  }
}
