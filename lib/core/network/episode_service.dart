import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:moodmonster/core/network/api_service.dart';
import 'package:moodmonster/models/content.model.dart';
import 'package:moodmonster/models/content_episode.model.dart';

class EpisodeService {
  const EpisodeService._();
  // 특정 콘텐츠에 속한 에피소드 가져오기
  static Future<List<ContentEpisode>> fetchEpisodesByContentCode(
    MyContentType contentType,
    String contentCode,
  ) async {
    print("fetch Episodes of contentCode: $contentCode");
    //소설, 웹툰에 따라 endPoint다르다
    String endPoint =
        contentType == MyContentType.Webtoon
            ? "/contents/webtoon/episode/all"
            : "/contents/novel/episode/all";

    final response = await ApiService.postRequest(endPoint, {
      "contentCode": contentCode,
    });

    if (response.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(response.body);
      print(dataList);
      print(
        dataList.map((dataJson) => ContentEpisode.fromJson(dataJson)).toList(),
      );
      return dataList
          .map((dataJson) => ContentEpisode.fromJson(dataJson))
          .toList();
    } else {
      throw Exception("에피소드 불러오기 실패");
    }
  }

  // 모바일에서 에피소드 추가(이미지 처리방식이 달리 모바일, 웹 분리)
  // 모바일에서 에피소드 추가
  static Future<void> createEpisodeInMobile({
    required MyContentType contentType,
    required String contentCode,
    required String epTitle,
    required DateTime uploadDate,
    required File episodeFile,
  }) async {
    //소설, 웹툰에 따라 endPoint다르다
    String endPoint =
        contentType == MyContentType.Webtoon
            ? "/contents/webtoon/episode/create"
            : "/contents/novel/episode/create";
    final response = await ApiService.postRequestWithFile(
      endpoint: endPoint,
      fields: {
        'title': epTitle,
        "contentCode": contentCode,
        "uploadDate": uploadDate,
      },
      fileData: episodeFile,
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("에피소드 create failed");
    }
  }

  // 웹에서 에피소드 추가
  static Future<void> createEpisodeInWeb({
    required MyContentType contentType,
    required String contentCode,
    required String epTitle,
    required DateTime uploadDate,
    required Uint8List episodeFileInWeb,
    required String episodeFileNameInWeb,
  }) async {
    String endPoint =
        contentType == MyContentType.Webtoon
            ? "/contents/webtoon/episode/create"
            : "/contents/novel/episode/create";
    final response = await ApiService.postRequestWithFile(
      endpoint: endPoint,
      fields: {
        'title': epTitle,
        "contentCode": contentCode,
        "uploadDate": uploadDate,
      },
      fileDataInWeb: episodeFileInWeb,
      fileDataNameInWeb: episodeFileNameInWeb,
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("에피소드 create failed");
    }
  }

  //파일 여러개 처리 가능
  static Future<void> createEpisodeInMobileForFiles({
    required MyContentType contentType,
    required String contentCode,
    required String epTitle,
    required DateTime uploadDate,
    required List<File> episodeFiles,
  }) async {
    String endPoint =
        contentType == MyContentType.Webtoon
            ? "/contents/webtoon/episode/create"
            : "/contents/novel/episode/create";

    final response = await ApiService.postRequestWithMultipleFiles(
      endpoint: endPoint,
      fields: {
        'title': epTitle,
        "contentCode": contentCode,
        "uploadDate": uploadDate.toIso8601String(), // ISO 형식으로 변환
      },
      files: episodeFiles,
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("에피소드 create failed");
    }
  }

  static Future<void> createEpisodeInWebForFiles({
    required MyContentType contentType,
    required String contentCode,
    required String epTitle,
    required DateTime uploadDate,

    required List<Uint8List> episodeFilesInWeb, // 여러 개의 파일
    required List<String> episodeFileNamesInWeb, //각 파일의 파일명
  }) async {
    assert(episodeFilesInWeb.length == episodeFileNamesInWeb.length);

    String endPoint =
        contentType == MyContentType.Webtoon
            ? "/contents/webtoon/episode/create"
            : "/contents/novel/episode/create";

    final response = await ApiService.postRequestWithMultipleFiles(
      endpoint: endPoint,
      fields: {
        'title': epTitle,
        "contentCode": contentCode,
        "uploadDate": uploadDate.toIso8601String(),
      },
      filesInWeb: episodeFilesInWeb, // ← List<Uint8List>
      fileNamesInWeb: episodeFileNamesInWeb, // ← List<String>
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("에피소드 create failed");
    }
  }

  // 에피소드 삭제
  static Future<void> deleteEpisode({
    required MyContentType contentType,
    required String contentCode,
    required String episodeCode,
  }) async {
    String endPoint =
        contentType == MyContentType.Webtoon
            ? "/contents/webtoon/episode/delete"
            : "/contents/novel/episode/delete";
    final response = await ApiService.postRequest(endPoint, {
      'code': episodeCode,
      'contentCode': contentCode,
    });

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("에피소드 삭제 실패");
    }
  }
}
