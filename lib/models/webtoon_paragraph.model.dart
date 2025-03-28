import 'package:freezed_annotation/freezed_annotation.dart';

part 'webtoon_paragraph.model.freezed.dart';
part 'webtoon_paragraph.model.g.dart';

@freezed
abstract class WebtoonParagraph with _$WebtoonParagraph {
  factory WebtoonParagraph({
    required int displayOrder,
    required String image_url,
    required String music_url,
  }) = _WebtoonParagraph;

  factory WebtoonParagraph.fromJson(Map<String, dynamic> json) =>
      _$WebtoonParagraphFromJson(json);
}
