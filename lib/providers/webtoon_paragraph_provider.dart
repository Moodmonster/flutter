import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodmonster/core/network/api_service.dart';
import 'package:moodmonster/core/network/webtoon_paragraphs_serviece.dart';
import 'package:moodmonster/models/webtoon_paragraph.model.dart';

final webtoonParagraphProvider = StateNotifierProvider.autoDispose<
  WebtoonParagraphNotifier,
  AsyncValue<List<WebtoonParagraph>>
>((ref) => WebtoonParagraphNotifier());

class WebtoonParagraphNotifier
    extends StateNotifier<AsyncValue<List<WebtoonParagraph>>> {
  WebtoonParagraphNotifier() : super(const AsyncValue.loading());

  Future<void> loadParagraphs({required String code}) async {
    print("loadParagraphs 실행 (webtoon)");
    state = const AsyncValue.loading();

    try {
      final paragraphs =
          await WebtoonParagraphsService.fetchWebtoonParagraphsByEpCode(
            episodeCode: code,
          );
      state = AsyncValue.data(paragraphs);
      print("webtoon paragraphs 가져오기 완료");
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
