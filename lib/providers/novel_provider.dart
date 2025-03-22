import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodmonster/core/network/novel_service.dart';
import 'package:moodmonster/models/content.model.dart';

final NovelProvider =
    StateNotifierProvider<NovelNotifier, AsyncValue<List<Content>>>((ref) {
      return NovelNotifier();
    });

class NovelNotifier extends StateNotifier<AsyncValue<List<Content>>> {
  NovelNotifier() : super(const AsyncValue.loading()) {
    loadNovels();
  }

  //소설 데이터 가져온다
  Future<void> loadNovels() async {
    try {
      // 기존 상태 로딩으로 변경
      state = const AsyncValue.loading();
      final novels = await NovelService.fetchNovels();
      state = AsyncValue.data(novels);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  //소설 데이터 추가
  Future<void> addNovel({
    required String title,
    required String desc,
    required String author,
    required String userId,
    required String prompt,
  }) async {
    try {
      // 기존 상태 로딩으로 변경
      //state = const AsyncValue.loading();

      // API 요청으로 소설 추가
      await NovelService.createNovel(
        author: author,
        desc: desc,
        title: title,
        userId: userId,
        prompt: prompt,
      );

      // 소설 목록 다시 불러오기
      await loadNovels();
    } catch (e) {
      //state = AsyncValue.error(e, stackTrace);
      throw Exception("소설 create failed :${e}");
    }
  }

  //소설 데이터 제거
  Future<void> removeNovel({required String code}) async {
    try {
      // API 요청으로 소설 추가
      await NovelService.deleteNovel(code: code);

      // 소설 목록 다시 불러오기
      await loadNovels();
    } catch (e) {
      print("소설 데이터 제거 오류: ${e}");
      throw Exception("소설 remove failed :${e}");
    }
  }

  //클릭수 증가
  Future<void> clickCountPlusOne({required String code}) async {
    try {
      // API 요청으로 소설 추가
      await NovelService.clickCountPlusOne(code: code);
    } catch (e) {
      print("클릭수 증가 오류: ${e}");
      throw Exception("클릭수 증가 오류 :${e}");
    }
  }
}
