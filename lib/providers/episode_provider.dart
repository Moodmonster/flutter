import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/models/content_episode.model.dart';
import 'package:moodmonster/core/network/episode_service.dart'; // 네트워크 통신을 위한 서비스 클래스 필요

final EpisodeProvider =
    StateNotifierProvider<EpisodeNotifier, AsyncValue<List<ContentEpisode>>>((
      ref,
    ) {
      return EpisodeNotifier();
    });

class EpisodeNotifier extends StateNotifier<AsyncValue<List<ContentEpisode>>> {
  EpisodeNotifier() : super(const AsyncValue.loading());

  // 특정 콘텐츠의 에피소드들 불러오기
  Future<void> loadEpisodesByContentCode({
    required MyContentType contentType,
    required String contentCode,
  }) async {
    try {
      state = const AsyncValue.loading();
      final episodes = await EpisodeService.fetchEpisodesByContentCode(
        contentType,
        contentCode,
      );
      state = AsyncValue.data(episodes);
    } catch (e, stackTrace) {
      print(e);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // 에피소드 추가(모바일에서)
  Future<void> addEpisodeInMobile({
    required MyContentType contentType,
    required String contentCode,
    required String epTitle,
    required DateTime uploadDate,
    required File episodeFile,
  }) async {
    try {
      await EpisodeService.createEpisodeInMobile(
        contentCode: contentCode,
        contentType: contentType,
        epTitle: epTitle,
        episodeFile: episodeFile,
        uploadDate: uploadDate,
      );
      // 에피소드 목록 새로 로드
      await loadEpisodesByContentCode(
        contentType: contentType,
        contentCode: contentCode,
      );
    } catch (e) {
      throw Exception("에피소드 추가 실패: $e");
    }
  }

  // 에피소드 추가(웹에서)
  Future<void> addEpisodeInWeb({
    required MyContentType contentType,
    required String contentCode,
    required String epTitle,
    required DateTime uploadDate,
    required Uint8List episodeFileInWeb,
    required String episodeFileNameInWeb,
  }) async {
    try {
      await EpisodeService.createEpisodeInWeb(
        contentCode: contentCode,
        contentType: contentType,
        epTitle: epTitle,
        episodeFileInWeb: episodeFileInWeb,
        episodeFileNameInWeb: episodeFileNameInWeb,
        uploadDate: uploadDate,
      );
      // 에피소드 목록 새로 로드
      await loadEpisodesByContentCode(
        contentType: contentType,
        contentCode: contentCode,
      );
    } catch (e) {
      throw Exception("에피소드 추가 실패: $e");
    }
  }

  // 에피소드 삭제
  Future<void> removeEpisode({
    required MyContentType contentType,
    required String episodeCode,
    required String contentCode,
  }) async {
    try {
      await EpisodeService.deleteEpisode(
        contentType: contentType,
        contentCode: contentCode,
        episodeCode: episodeCode,
      );
      await loadEpisodesByContentCode(
        contentType: contentType,
        contentCode: contentCode,
      );
    } catch (e) {
      throw Exception("에피소드 삭제 실패: $e");
    }
  }
}
