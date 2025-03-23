import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/models/content_episode.model.dart';
import 'package:moodmonster/models/novel_paragraph.model.dart';
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
  bool _initialized = false;

  //처음 1회 에피소드내 단락 데이터 가져오기
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    episodeInfo = args?['episode'] as ContentEpisode?;
    final prompt = args?['prompt'] as String? ?? '';
    print("episodeInfo${episodeInfo}");
    print("prompt:${prompt}");
    if (episodeInfo != null) {
      ref
          .read(NovelParagraphProvider.notifier)
          .loadParagraphs(code: episodeInfo!.code, prompt: prompt);
    }

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final paragraphsAsync = ref.watch(NovelParagraphProvider);
    // if (episodeInfo == null) {
    //   return DataNullScreen();
    // }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 55.h,
            color: AppColors.background,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    child: Text(
                      episodeInfo?.epTitle ?? "예시",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        AppRouter.pop();
                      },
                      icon: Icon(Icons.music_off),
                    ),
                    SizedBox(width: 7.w),
                    IconButton(
                      onPressed: () {
                        AppRouter.pop();
                      },
                      icon: Icon(Icons.record_voice_over),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: paragraphsAsync.when(
              data: (paragraphs) => _buildParagraphsScreenUI(paragraphs),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('오류 발생: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildParagraphsScreenUI(List<NovelParagraph> paragraphs) {
  return ListView.builder(
    padding: const EdgeInsets.all(20),
    itemCount: paragraphs.length,
    itemBuilder: (context, index) {
      final item = paragraphs[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🎵 ${item.music_url}"), //
          const SizedBox(height: 8),
          Text(item.text),
          const Divider(),
        ],
      );
    },
  );
}
