import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/feature/error/data_null_screen.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/models/content_episode.model.dart';
import 'package:moodmonster/models/webtoon_paragraph.model.dart';
import 'package:moodmonster/providers/webtoon_paragraph.viewmodel.dart';
import 'package:moodmonster/providers/webtoon_paragraph_provider.dart';

class WebtoonParagraphsShowScreen extends ConsumerStatefulWidget {
  const WebtoonParagraphsShowScreen({super.key});

  @override
  ConsumerState<WebtoonParagraphsShowScreen> createState() =>
      _WebtoonParagraphsShowScreenState();
}

class _WebtoonParagraphsShowScreenState
    extends ConsumerState<WebtoonParagraphsShowScreen> {
  ContentEpisode? episodeInfo;
  Content? contentInfo;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    episodeInfo = args?['episodeInfo'] as ContentEpisode?;
    final prompt = args?['prompt'] as String? ?? '';
    contentInfo = args?['contentInfo'] as Content?;

    if (episodeInfo != null) {
      ref
          .read(webtoonParagraphProvider.notifier)
          .loadParagraphs(
            code:
                episodeInfo!.code == "%blank"
                    ? episodeInfo!.contentCode
                    : episodeInfo!.code,
          );
    }

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final paragraphsAsync = ref.watch(webtoonParagraphProvider);
    final controller = ref.read(
      webtoonParagraphViewModelControllerProvider.notifier,
    );
    final viewModel = ref.watch(webtoonParagraphViewModelControllerProvider);

    if (episodeInfo == null || contentInfo == null) {
      return const DataNullScreen();
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        controller.audioDispose();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _customWebtoonAppBar(
                title: episodeInfo?.epTitle ?? "Untitled",
                isMuted: viewModel.isMuted,
                muteTap: controller.handleMute,
              ),
              Expanded(
                child: paragraphsAsync.when(
                  data:
                      (paragraphs) => _buildWebtoonParagraphsUI(
                        contentInfo!,
                        episodeInfo!,
                        paragraphs,
                        controller,
                      ),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Error: \$e")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildWebtoonParagraphsUI(
  Content contentInfo,
  ContentEpisode episodeInfo,
  List<WebtoonParagraph> paragraphs,
  WebtoonParagraphViewModelController controller,
) {
  return InViewNotifierCustomScrollView(
    isInViewPortCondition: (deltaTop, deltaBottom, viewPortDimension) {
      return deltaTop < (0.4 * viewPortDimension) &&
          deltaBottom > (0.4 * viewPortDimension);
    },
    slivers: [
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
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 35.h),
        sliver: SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              episodeInfo.epTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              softWrap: true,
            ),
          ),
        ),
      ),

      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return InViewNotifierWidget(
            id: '$index',
            builder: (context, isInView, _) {
              return Padding(
                padding: EdgeInsets.only(bottom: 90.h),
                child: _webtoonParagraphItem(
                  isInView: isInView,
                  controller: controller,
                  paragraph: paragraphs[index],
                ),
              );
            },
          );
        }, childCount: paragraphs.length),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 300.h)),
    ],
  );
}

Column _webtoonParagraphItem({
  required bool isInView,
  required WebtoonParagraphViewModelController controller,
  required WebtoonParagraph paragraph,
}) {
  if (isInView && paragraph.music_url.isNotEmpty) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.playAudio(paragraph.music_url);
    });
  }
  return Column(
    children: [
      SizedBox(height: 8.h),
      if (paragraph.image_url.isNotEmpty) Image.network(paragraph.image_url),
    ],
  );
}

Container _customWebtoonAppBar({
  required String title,
  required bool isMuted,
  required VoidCallback muteTap,
}) {
  return Container(
    height: 55.h,
    color: AppColors.background,
    padding: EdgeInsets.symmetric(horizontal: 8.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => AppRouter.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(title, style: const TextStyle(fontSize: 17)),
          ),
        ),
        IconButton(
          onPressed: muteTap,
          icon:
              isMuted
                  ? const Icon(Icons.music_off)
                  : const Icon(Icons.music_note),
        ),
      ],
    ),
  );
}
