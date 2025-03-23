import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodmonster/core/network/webtoon_service.dart';
import 'package:moodmonster/models/content.model.dart';

final WebtoonProvider =
    StateNotifierProvider<WebtoonNotifier, AsyncValue<List<Content>>>((ref) {
      return WebtoonNotifier();
    });

class WebtoonNotifier extends StateNotifier<AsyncValue<List<Content>>> {
  WebtoonNotifier() : super(const AsyncValue.loading()) {
    loadWebtoons();
  }

  //웹툰 데이터 가져온다
  Future<void> loadWebtoons() async {
    try {
      // 기존 상태 로딩으로 변경
      state = const AsyncValue.loading();
      final novels = await WebtoonService.fetchWebtoons();
      state = AsyncValue.data(novels);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  //웹툰 데이터 추가(모바일에서)
  Future<void> addWebtoonInMobile({
    required String title,
    required String desc,
    required String author,
    required String userId,
    required File fileData,
  }) async {
    try {
      // 기존 상태 로딩으로 변경
      //state = const AsyncValue.loading();

      // API 요청으로 웹툰 추가
      await WebtoonService.createWebtoonInMobile(
        author: author,
        desc: desc,
        title: title,
        userId: userId,
        fileData: fileData,
      );

      // 웹툰 목록 다시 불러오기
      await loadWebtoons();
    } catch (e) {
      throw Exception("웹툰 create failed:${e}");
    }
  }

  //웹툰 데이터 추가(웹에서)
  Future<void> addWebtoonInWeb({
    required String title,
    required String desc,
    required String author,
    required String userId,
    required Uint8List fileDataInWeb,
    required String fileDataNameInWeb,
  }) async {
    try {
      // 기존 상태 로딩으로 변경
      //state = const AsyncValue.loading();

      // API 요청으로 웹툰 추가
      await WebtoonService.createWebtoonInWeb(
        author: author,
        desc: desc,
        title: title,
        userId: userId,
        fileDataInWeb: fileDataInWeb,
        fileDataNameInWeb: fileDataNameInWeb,
      );

      // 웹툰 목록 다시 불러오기
      await loadWebtoons();
    } catch (e) {
      throw Exception("웹툰 create failed:${e}");
    }
  }

  //웹툰 데이터 제거
  Future<void> removeWebtoon({required String code}) async {
    try {
      // 기존 상태 로딩으로 변경
      //state = const AsyncValue.loading();

      // API 요청으로 웹툰 추가
      await WebtoonService.deleteWebtoon(code: code);

      // 웹툰 목록 다시 불러오기
      await loadWebtoons();
    } catch (e) {
      throw Exception("웹툰 데이터 제거 오류:${e}");
    }
  }

  //클릭수 증가
  Future<void> clickCountPlusOne({required String code}) async {
    try {
      // API 요청으로 소설 추가
      await WebtoonService.clickCountPlusOne(code: code);
    } catch (e) {
      print("클릭수 증가 오류: ${e}");
      throw Exception("클릭수 증가 오류 :${e}");
    }
  }
}
