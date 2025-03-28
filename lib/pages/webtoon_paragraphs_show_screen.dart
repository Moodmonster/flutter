import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/models/content_episode.model.dart';
import 'package:moodmonster/models/webtoon_paragraph.model.dart';
import 'package:moodmonster/providers/webtoon_paragraph.viewmodel.dart';
import 'package:moodmonster/providers/webtoon_paragraph_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      return const Center(child: Text("Invalid episode or content info"));
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        controller.audioDispose();
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
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
                  error: (e, _) => Center(child: Text("Error: $e")),
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
            child: FancyShimmerImage(
              imageUrl: contentInfo.thumbnailUrl,
              width: double.infinity,
              boxFit: BoxFit.fitWidth,
              alignment: Alignment.center,
              errorWidget: Image.asset(
                  "assets/imgs/default_img.jpg",
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                )
            ),
          ),
        ),
      ),

      SliverPadding(
        padding: EdgeInsets.only(
          left: 15.w,
          right: 15.w,
          top: 25.h,
          bottom: 35.h,
        ),
        sliver: SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              episodeInfo.epTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.mainTextColor,
              ),
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
              if (isInView && paragraphs[index].music_url.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.playAudio(paragraphs[index].music_url);
                });
              }
              return Column(
                children: [
                  for (final imageUrl in paragraphs[index].images)
                    Padding(
                      padding: EdgeInsets.only(bottom: 80.h),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        //errorWidget: Image.asset("assets/imgs/default_img.jpg")
                      ),
                    ),
                ],
              );
            },
          );
        }, childCount: paragraphs.length),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 200.h)),
      SliverPadding(
        padding: EdgeInsets.only(
          left: 15.w,
          right: 15.w,
          top: 25.h,
          bottom: 35.h,
        ),
        sliver: SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              "To be continued...",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.mainTextColor,
              ),
              softWrap: true,
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 230.h)),
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
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.mainTextColor),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              title,
              style: const TextStyle(fontSize: 17, color: AppColors.mainTextColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        IconButton(
          onPressed: muteTap,
          icon:
              isMuted
                  ? const Icon(Icons.music_off, color: AppColors.mainTextColor)
                  : const Icon(Icons.music_note, color: AppColors.mainTextColor),
        ),
      ],
    ),
  );
}
