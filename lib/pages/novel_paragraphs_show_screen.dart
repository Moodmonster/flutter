import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/config/routes/routes.dart';
import 'package:moodmonster/feature/error/data_null_screen.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/models/content_episode.model.dart';
import 'package:moodmonster/models/novel_paragraph.model.dart';
import 'package:moodmonster/providers/audio.viewmodel.dart';
import 'package:moodmonster/providers/novel_paragraph.viewmodel.dart';
import 'package:moodmonster/providers/novel_paragraph_provider.dart';

class NovelParagraphsShowScreen extends ConsumerStatefulWidget {
  const NovelParagraphsShowScreen({super.key});

  @override
  ConsumerState<NovelParagraphsShowScreen> createState() =>
      _NovelParagraphsShowScreenState();
}

class _NovelParagraphsShowScreenState
    extends ConsumerState<NovelParagraphsShowScreen> {
  ContentEpisode? episodeInfo;
  Content? contentInfo;
  bool _initialized = false;

  //최초로 해당 에피소드의 단락 데이터들 가져오기
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    //현재 routeing방식은 path파라미터 방식말고 arguments에 보내는 방식 -> 나중에 수정해함
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // arguments에서 episodeInfo에 해당하는 데이터 뽑고
    episodeInfo = args?['episodeInfo'] as ContentEpisode?;
    // arguments에서 prompt(원하는 음악 분위기)에 해당하는 데이터 뽑고
    final prompt = args?['prompt'] as String? ?? '';
    // arguments에서 contentInfo에 해당하는 데이터 뽑는다(표지 보이려면 contentInfo도 들고 와야함)
    contentInfo = args?['contentInfo'] as Content?;

    print("episodeInfo${episodeInfo}");
    print("prompt:${prompt}");

    if (episodeInfo != null) {
      // 해당 에피소드의 단락 데이터 백엔드로부터 가져오기 실행
      ref
          .read(NovelParagraphProvider.notifier)
          .loadParagraphs(
            code:
                episodeInfo!.code == "%blank"
                    ? episodeInfo!.contentCode
                    : episodeInfo!.code,
            prompt: prompt,
          );
    }

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final novelParagraphsAsync = ref.watch(NovelParagraphProvider);
    final novelPageView = ref.watch(novelParagraphViewModelControllerProvider);
    final novelController = ref.read(
      novelParagraphViewModelControllerProvider.notifier,
    );

    //episodeInfo나 contentInfo가 없으면 데이터 없다는 내용의 화면 띄운다
    if (episodeInfo == null || contentInfo == null) {
      return DataNullScreen();
    }

    //episodeInfo,contentInfo 둘다 있으면
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        novelController.audioDispose();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              customNovelAppBar(
                title: episodeInfo?.epTitle ?? "예시",
                isMuted: novelPageView.isMuted,
                muteTap: () => novelController.handleMute(),
                mp3ScreenTap: () {
                  ref
                      .read(audioControllerProvider.notifier)
                      .initScreen(
                        title: episodeInfo?.epTitle ?? "예시",
                        coverImg: contentInfo?.thumbnailUrl ?? "",
                        ttsUrl: '',
                      );
                  AppRouter.pushNamed(Routes.novelTTS);
                },
              ),
              Expanded(
                //소설 단락들 담는 프로바이더의 상태에 따라 다른 내용 보이도록
                child: novelParagraphsAsync.when(
                  //데이터 정상적으로 있는 상태라면
                  data: (paragraphs) {
                    return _buildParagraphsScreenUI(
                      contentInfo!,
                      episodeInfo!,
                      paragraphs,
                      novelController: novelController,
                    );
                  },
                  // 로딩중이라면
                  loading: () => Center(child: CircularProgressIndicator()),
                  // 에러난 상태면
                  error: (e, _) => Center(child: Text('오류 발생: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 화면 전체 UI
Widget _buildParagraphsScreenUI(
  Content contentInfo,
  ContentEpisode episodeInfo,
  List<NovelParagraph> paragraphs, {
  required NovelParagraphViewModelController novelController,
}) {
  return InViewNotifierCustomScrollView(
    isInViewPortCondition: (deltaTop, deltaBottom, viewPortDimension) {
      return deltaTop < (0.4 * viewPortDimension) &&
          deltaBottom > (0.4 * viewPortDimension);
    },
    slivers: [
      // 표지 사진
      SliverToBoxAdapter(
        child: Hero(
          tag: contentInfo.thumbnailUrl,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.network(
              contentInfo.thumbnailUrl,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/imgs/default_img.jpg",
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                );
              },
            ),
          ),
        ),
      ),

      // 에피소드 제목 부분
      SliverPadding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 24.h),
        sliver: SliverToBoxAdapter(
          child: IntrinsicHeight(
            child: Row(
              children: [
                // 왼쪽 막대
                Container(
                  margin: EdgeInsets.only(right: 14.w),
                  width: 3.w,
                  color: AppColors.mainTextColor,
                ),
                Expanded(
                  // 제목 출력
                  child: Text(
                    episodeInfo.epTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // 단락들 리스트 (InViewNotifier 적용)
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return InViewNotifierWidget(
            id: '$index',
            builder: (context, isInView, _) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: paragraphItem(
                  isInView: isInView,
                  novelController: novelController,
                  paragraph: paragraphs[index],
                ),
              );
            },
          );
        }, childCount: paragraphs.length),
      ),

      // 추가 여백
      SliverToBoxAdapter(child: SizedBox(height: 300.h)),
    ],
  );
}

Column paragraphItem({
  required bool isInView,
  required NovelParagraphViewModelController novelController,
  required NovelParagraph paragraph,
}) {
  novelController.playAudio(paragraph.music_url);
  return Column(
    children: [
      SizedBox(height: 14.h),
      //단락 내용(txt)출력
      Text(paragraph.text, style: TextStyle(fontSize: 22, height: 1.8)),
    ],
  );
}

Container customNovelAppBar({
  required String title,
  required bool isMuted,
  required VoidCallback muteTap,
  required VoidCallback mp3ScreenTap,
}) {
  return Container(
    height: 55.h,
    color: AppColors.background,
    padding: EdgeInsets.symmetric(horizontal: 8.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //뒤로 가기 버튼
        IconButton(
          onPressed: () {
            AppRouter.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        //에피소드 제목
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(title, style: TextStyle(fontSize: 17)),
          ),
        ),
        //우측의 음소거, tts기능 버튼
        Row(
          children: [
            //배경음악 음소거 끄고 키는 버튼
            IconButton(
              onPressed: muteTap,
              icon: isMuted ? Icon(Icons.music_off) : Icon(Icons.music_note),
            ),
            SizedBox(width: 7.w),
            //TTS로 읽어주기 기능 버튼
            IconButton(
              onPressed: mp3ScreenTap,
              icon: Icon(Icons.record_voice_over),
            ),
          ],
        ),
      ],
    ),
  );
}
