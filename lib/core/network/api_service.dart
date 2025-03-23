//http 라이브러리를 활용해 API 요청을 처리하는 공통 API 클래스
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
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
    String? fileDataNameInWeb, //업로드 할 파일의 파일명(웹용)
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
}
