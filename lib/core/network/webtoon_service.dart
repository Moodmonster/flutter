import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:moodmonster/core/network/api_service.dart';
import 'package:moodmonster/models/content.model.dart';

class WebtoonService {
  //모든 웹툰 데이터 가져오기
  static Future<List<Content>> fetchWebtoons() async {
    print("fetch Webtoons");
    final response = await ApiService.getRequest("/contents/webtoon/all");
    if (response.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(response.body);
      print(
        "webtoon data: ${dataList.map((dataJson) => Content.fromJson(dataJson)).toList()}",
      );
      return dataList.map((dataJson) => Content.fromJson(dataJson)).toList();
    } else {
      throw Exception("웹툰 get failed");
    }
  }

  // 모바일에서 웹툰 추가(이미지 처리방식이 달리 모바일, 웹 분리)
  static Future<void> createWebtoonInMobile({
    required String title,
    required String desc,
    required String author,
    required String userId,
    required File fileData,
  }) async {
    final response = await ApiService.postRequestWithFile(
      endpoint: "/contents/webtoon/create",
      fields: {
        'title': title,
        'desc': desc,
        'author': author,
        'userId': userId,
      },
      fileData: fileData,
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("웹툰 create failed");
    }
  }

  // 웹에서 웹툰 추가
  static Future<void> createWebtoonInWeb({
    required String title,
    required String desc,
    required String author,
    required String userId,
    required Uint8List fileDataInWeb,
    required String fileDataNameInWeb,
  }) async {
    final response = await ApiService.postRequestWithFile(
      endpoint: "/contents/webtoon/create",
      fields: {
        'title': title,
        'desc': desc,
        'author': author,
        'userId': userId,
      },
      fileDataInWeb: fileDataInWeb,
      fileDataNameInWeb: fileDataNameInWeb,
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("웹툰 create failed");
    }
  }

  //웹툰 삭제
  static Future<void> deleteWebtoon({required String code}) async {
    print("delete Webtoon실행");
    final response = await ApiService.postRequest("/contents/webtoon/delete", {
      'code': code,
    });
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("웹툰 delete failed");
    }
  }

  //클릭 수 1 증가
  static Future<void> clickCountPlusOne({required String code}) async {
    print("click count plus one 실행");
    final response = await ApiService.postRequest("/contents/updateCount", {
      'code': code,
      'contentType': "Webtoon",
    });
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("click count plus one 실패");
    }
  }
}
