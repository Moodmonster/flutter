//http 라이브러리를 활용해 API 요청을 처리하는 공통 API 클래스
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  const ApiService._();
  //백엔드 주소
  static const String baseUrl = "http://20.196.66.215:5000";

  //get요청
  static Future<http.Response> getRequest(String endPoint) async {
    final url = Uri.parse('$baseUrl$endPoint');
    final response = await http.get(url);
    return response;
  }

  //post요청
  static Future<http.Response> postRequest(
    String endpoint,
    Map<String, dynamic> body, //요청 body
  ) async {
    print("body: ${body}");
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body), //body요청 json으로 변환후 요청
    );
    return response;
  }

  // 이미지 업로드 지원하는 POST 요청
  // 앱에서 올리는 이미지 = File형식
  // 웹에서 올리는 이미지 = Unit8List

  static Future<http.StreamedResponse> postRequestWithFile({
    required String endpoint,
    File? fileData, // 업로드할 파일(앱용)
    Uint8List? fileDataInWeb, //업로드 할 파일(웹용)
    String? fileDataNameInWeb, //업로드 할 파일의 File Name(웹용)
    required Map<String, dynamic> fields, // 파일 데이터 외 다른 데이터들(code, title등)
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    var request = http.MultipartRequest('POST', url);
    // 요청 보내려면 fields타입을 Map<String,String>으로 변환해야 한다
    Map<String, String> stringFields = fields.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    //파일 데이터 외 다른 데이터(fields) 추가
    request.fields.addAll(stringFields);

    try {
      // 이미지 데이터 첨부
      // 모바일/웹 이미지 중 하나만 처리
      if (fileData != null) {
        //모바일 이미지 데이터 들어왔으면
        request.files.add(
          await http.MultipartFile.fromPath('file', fileData.path),
        );
      } else if (fileDataInWeb != null && fileDataNameInWeb != null) {
        //웹 이미지 데이터 들어왔으면
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            fileDataInWeb,
            filename: fileDataNameInWeb,
          ),
        );
      } else {
        throw Exception("이미지 파일이 없습니다.");
      }
    } catch (err) {
      throw Exception("에피소드 추가 실패: $err");
    }
    print(request.fields);
    print(request.files);

    return await request.send();
  }

  static Future<http.StreamedResponse> postRequestWithMultipleFiles({
    required String endpoint,
    required Map<String, dynamic> fields,
    File? thumbnailFile, // ✅ 모바일용 썸네일
    List<File>? episodeFiles, // ✅ 모바일용 에피소드 이미지
    Uint8List? thumbnailFileInWeb, // ✅ 웹용 썸네일
    List<Uint8List>? episodeFilesInWeb, // ✅ 웹용 에피소드 이미지
    String? thumbnailFileNameInWeb, // ✅ 웹용 썸네일 파일명
    List<String>? episodeFileNamesInWeb, // ✅ 웹용 에피소드 파일명
  }) async {
    var uri = Uri.parse(baseUrl + endpoint);
    var request = http.MultipartRequest("POST", uri);

    // 일반 필드 추가
    fields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // ✅ 모바일 처리

    if (!kIsWeb) {
      if (thumbnailFile != null) {
        final thumbPart = http.MultipartFile.fromBytes(
          'thumbnailImage',
          await thumbnailFile.readAsBytes(),
          filename: thumbnailFile.path.split('/').last,
        );
        request.files.add(thumbPart);
      }

      if (episodeFiles != null) {
        for (var file in episodeFiles) {
          final filePart = http.MultipartFile.fromBytes(
            'images',
            await file.readAsBytes(),
            filename: file.path.split('/').last,
          );
          request.files.add(filePart);
        }
      }
    } else {
      // ✅ 웹 처리
      if (thumbnailFileInWeb != null && thumbnailFileNameInWeb != null) {
        final thumbPart = http.MultipartFile.fromBytes(
          'thumbnailImage',
          thumbnailFileInWeb,
          filename: thumbnailFileNameInWeb,
        );
        request.files.add(thumbPart);
      }

      if (episodeFilesInWeb != null && episodeFileNamesInWeb != null) {
        for (int i = 0; i < episodeFilesInWeb.length; i++) {
          final filePart = http.MultipartFile.fromBytes(
            'images',
            episodeFilesInWeb[i],
            filename: episodeFileNamesInWeb[i],
          );
          request.files.add(filePart);
        }
      }
    }

    return await request.send();
  }

  // static Future<http.StreamedResponse> postRequestWithMultipleFiles({
  //   required String endpoint,
  //   required Map<String, dynamic> fields,
  //   List<File>? files, // 📱 모바일용
  //   List<Uint8List>? filesInWeb, // 💻 웹용
  //   List<String>? fileNamesInWeb, // 💻 웹용 파일 이름
  // }) async {
  //   var uri = Uri.parse(baseUrl + endpoint);
  //   var request = http.MultipartRequest("POST", uri);

  //   // 필드 설정
  //   fields.forEach((key, value) {
  //     request.fields[key] = value.toString();
  //   });

  //   // ✅ 모바일: File 리스트 처리
  //   if (files != null) {
  //     for (var file in files) {
  //       final multipartFile = http.MultipartFile.fromBytes(
  //         'images', // 서버에서 받는 이름이 'files' or 'files[]'
  //         await file.readAsBytes(),
  //         filename: file.path.split('/').last,
  //       );
  //       request.files.add(multipartFile);
  //       final multipartFile2 = http.MultipartFile.fromBytes(
  //         'images', // 서버에서 받는 이름이 'files' or 'files[]'
  //         await file.readAsBytes(),
  //         filename: file.path.split('/').last,
  //       );
  //       request.files.add(multipartFile2);
  //       final multipartFile3 = http.MultipartFile.fromBytes(
  //         'thumbnailImage', // 서버에서 받는 이름이 'files' or 'files[]'
  //         await file.readAsBytes(),
  //         filename: file.path.split('/').last,
  //       );
  //       request.files.add(multipartFile3);
  //     }
  //   }
  //   // ✅ 웹: Uint8List + filename 처리
  //   else if (filesInWeb != null && fileNamesInWeb != null) {
  //     if (filesInWeb.length != fileNamesInWeb.length) {
  //       throw Exception("웹 파일과 이름 리스트의 길이가 일치하지 않습니다.");
  //     }

  //     for (int i = 0; i < filesInWeb.length; i++) {
  //       final multipartFile = http.MultipartFile.fromBytes(
  //         'images',
  //         filesInWeb[i],
  //         filename: fileNamesInWeb[i],
  //       );
  //       request.files.add(multipartFile);
  //       final multipartFile1 = http.MultipartFile.fromBytes(
  //         'images',
  //         filesInWeb[i],
  //         filename: fileNamesInWeb[i],
  //       );
  //       request.files.add(multipartFile1);
  //       final multipartFile2 = http.MultipartFile.fromBytes(
  //         'thumbnailImage',
  //         filesInWeb[i],
  //         filename: fileNamesInWeb[i],
  //       );
  //       request.files.add(multipartFile2);
  //     }
  //   }

  //   // 전송
  //   return await request.send();
  // }
}
