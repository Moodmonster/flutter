import 'dart:convert';
import 'package:moodmonster/core/network/api_service.dart';
import 'package:moodmonster/models/novel_paragraph.model.dart';

class NovelParagraphsService {
  const NovelParagraphsService._();
  // 특정 에피소드에 속한 내용 단락들 가져오기
  static Future<List<NovelParagraph>> fetchNovelParagraphsByEpCode({
    required String epCode,
    required String prompt,
  }) async {
    print("fetch novel paragraphs of contentCode: $epCode");

    final response = await ApiService.postRequest(
      "/contents/novel/episode/paragraphs",
      {"episodeCode": epCode, "prompt": prompt},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> dataList = json['data'];

      print("단락 데이터");
      print(
        dataList.map((dataJson) => NovelParagraph.fromJson(dataJson)).toList(),
      );
      return dataList
          .map((dataJson) => NovelParagraph.fromJson(dataJson))
          .toList();
    } else {
      print("단락 데이터 fetch오류");
      throw Exception("내용 단락들 불러오기 실패");
    }
  }

  // // 모바일에서 에피소드 추가(이미지 처리방식이 달리 모바일, 웹 분리)
  // // 모바일에서 에피소드 추가
  // static Future<void> createEpisodeInMobile({
  //   required MyContentType contentType,
  //   required String contentCode,
  //   required String epTitle,
  //   required DateTime uploadDate,
  //   required File episodeFile,
  // }) async {
  //   //소설, 웹툰에 따라 endPoint다르다
  //   String endPoint =
  //       contentType == MyContentType.Webtoon
  //           ? "/contents/webtoon/episode/create"
  //           : "/contents/novel/episode/create";
  //   final response = await ApiService.postRequestWithFile(
  //     endpoint: endPoint,
  //     fields: {
  //       'title': epTitle,
  //       "contentCode": contentCode,
  //       "uploadDate": uploadDate,
  //     },
  //     fileData: episodeFile,
  //   );
  //   if (response.statusCode == 200) {
  //     return;
  //   } else {
  //     throw Exception("에피소드 create failed");
  //   }
  // }

  // // 웹에서 에피소드 추가
  // static Future<void> createEpisodeInWeb({
  //   required MyContentType contentType,
  //   required String contentCode,
  //   required String epTitle,
  //   required DateTime uploadDate,
  //   required Uint8List episodeFileInWeb,
  //   required String episodeFileNameInWeb,
  // }) async {
  //   String endPoint =
  //       contentType == MyContentType.Webtoon
  //           ? "/contents/webtoon/episode/create"
  //           : "/contents/novel/episode/create";
  //   final response = await ApiService.postRequestWithFile(
  //     endpoint: endPoint,
  //     fields: {
  //       'title': epTitle,
  //       "contentCode": contentCode,
  //       "uploadDate": uploadDate,
  //     },
  //     fileDataInWeb: episodeFileInWeb,
  //     fileDataNameInWeb: episodeFileNameInWeb,
  //   );
  //   if (response.statusCode == 200) {
  //     return;
  //   } else {
  //     throw Exception("에피소드 create failed");
  //   }
  // }

  // // 에피소드 삭제
  // static Future<void> deleteEpisode({
  //   required MyContentType contentType,
  //   required String contentCode,
  //   required String episodeCode,
  // }) async {
  //   String endPoint =
  //       contentType == MyContentType.Webtoon
  //           ? "/contents/webtoon/episode/delete"
  //           : "/contents/novel/episode/delete";
  //   final response = await ApiService.postRequest(endPoint, {
  //     'code': episodeCode,
  //     'contentCode': contentCode,
  //   });

  //   if (response.statusCode == 200) {
  //     return;
  //   } else {
  //     throw Exception("에피소드 삭제 실패");
  //   }
  // }
}
