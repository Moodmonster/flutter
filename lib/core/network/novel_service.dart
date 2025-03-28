import 'dart:convert';
import 'dart:io';

import 'package:moodmonster/core/network/api_service.dart';
import 'package:moodmonster/models/content.model.dart';

class NovelService {
  const NovelService._();
  //모든 소설 데이터 가져오기
  static Future<List<Content>> fetchNovels() async {
    print("fetch Novels");
    final response = await ApiService.getRequest("/contents/novel/all");
    if (response.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(response.body);
      print(dataList.map((dataJson) => Content.fromJson(dataJson)).toList());
      return dataList.map((dataJson) => Content.fromJson(dataJson)).toList();
    } else {
      throw Exception("소설 get failed");
    }
  }

  //소설 추가
  // static Future<void> createNovel(
  //   File thumbnailFile,
  //   Content newContent,
  // ) async {
  //   final response = await ApiService.postRequestWithFile(
  //     "/contents/novel/create",
  //     thumbnailFile,
  //     newContent.toJson(),
  //   );
  //   if (response.statusCode == 200) {
  //     return;
  //   } else {
  //     throw Exception("소설 create failed");
  //   }
  // }
  static Future<void> createNovel({
    required String title,
    required String desc,
    required String author,
    required String userId,
    required String prompt,
  }) async {
    final response = await ApiService.postRequest("/contents/novel/create", {
      'title': title,
      'desc': desc,
      'author': author,
      'userId': userId,
      'prompt': prompt,
    });
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("소설 create failed");
    }
  }

  //소설 삭제
  static Future<void> deleteNovel({required String code}) async {
    print("delete novel실행");
    final response = await ApiService.postRequest("/contents/novel/delete", {
      'code': code,
    });
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("소설 delete failed");
    }
  }

  //클릭 수 1 증가
  static Future<void> clickCountPlusOne({required String code}) async {
    print("click count plus one 실행");
    final response = await ApiService.postRequest("/contents/updateCount", {
      'code': code,
      'contentType': "Novel",
    });
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("click count plus one 실패");
    }
  }
}
