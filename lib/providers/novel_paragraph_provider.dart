import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodmonster/core/network/novel_paragraphs_service.dart';
import 'package:moodmonster/models/novel_paragraph.model.dart';

final NovelParagraphProvider = StateNotifierProvider.autoDispose<
  NovelParagraphNotifier,
  AsyncValue<List<NovelParagraph>>
>((ref) => NovelParagraphNotifier());

class NovelParagraphNotifier
    extends StateNotifier<AsyncValue<List<NovelParagraph>>> {
  NovelParagraphNotifier() : super(const AsyncValue.loading());

  Future<void> loadParagraphs({
    required String code,
    required String prompt,
  }) async {
    print("loadParagraphs 실행");
    state = const AsyncValue.loading();

    try {
      final paragraphs =
          await NovelParagraphsService.fetchNovelParagraphsByEpCode(
            epCode: code,
            prompt: prompt,
          );
      state = AsyncValue.data(paragraphs);
      print("paragraphs 가져오기 완료");
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
