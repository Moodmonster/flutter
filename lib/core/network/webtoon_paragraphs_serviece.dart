import 'dart:convert';
import 'package:moodmonster/core/network/api_service.dart';
import 'package:moodmonster/models/webtoon_paragraph.model.dart';

class WebtoonParagraphsService {
  const WebtoonParagraphsService._();

  // 특정 에피소드에 속한 웹툰 단락들 가져오기
  static Future<List<WebtoonParagraph>> fetchWebtoonParagraphsByEpCode({
    required String episodeCode,
  }) async {
    print("fetch webtoon paragraphs of contentCode: \$epCode");

    final response = await ApiService.postRequest(
      "/contents/webtoon/episode/paragraphs",
      {"episodeCode": episodeCode},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> dataList = json['data'];

      print("웹툰 단락 데이터");
      print(
        dataList
            .map((dataJson) => WebtoonParagraph.fromJson(dataJson))
            .toList(),
      );

      return dataList
          .map((dataJson) => WebtoonParagraph.fromJson(dataJson))
          .toList();
    } else {
      print("웹툰 단락 데이터 fetch 오류");
      throw Exception("웹툰 단락들 불러오기 실패");
    }
  }
}
