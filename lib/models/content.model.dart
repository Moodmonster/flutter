import 'package:freezed_annotation/freezed_annotation.dart';

part 'content.model.freezed.dart';
part 'content.model.g.dart';

enum MyContentType { Webtoon, Novel }

//컨텐츠 자체에 대한 데이터/
@freezed
abstract class Content with _$Content {
  factory Content({
    required String code,
    required String title,
    required String desc,
    required String author,
    required String userId,
    required MyContentType contentType, //웹툰인지 소설인지
    required int clickCount, //클릭수
    required String thumbnailUrl,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

// class Content {
//   final String code;
//   final String title;
//   final String desc;
//   final String author;
//   final String userId;
//   final MyContentType contentType; //웹툰인지 소설인지
//   final String thumbnailUrl;
//   Content({
//     required this.code,
//     required this.title,
//     required this.desc,
//     required this.author,
//     required this.userId,
//     required this.contentType,
//     required this.thumbnailUrl,
//   });
// }
