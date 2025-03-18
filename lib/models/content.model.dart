import 'package:freezed_annotation/freezed_annotation.dart';

part 'content.model.freezed.dart';
part 'content.model.g.dart';

enum ContentType { Webtoon, Novel }

//컨텐츠 자체에 대한 데이터/
@freezed
abstract class Content with _$Content {
  factory Content({
    required int code,
    required String title,
    required String desc,
    required String author,
    required String userId,
    required ContentType contentType, //웹툰인지 소설인지
    required int clickCount, //클릭수
    required String thumbnailUrl,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

// class Content {
//   final int code;
//   final String title;
//   final String desc;
//   final String author;
//   final String userId;
//   final ContentType contentType; //웹툰인지 소설인지
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
