//컨텐츠 한 목차에 대한 데이터
import 'package:freezed_annotation/freezed_annotation.dart';

part 'novel_paragraph.model.freezed.dart';
part 'novel_paragraph.model.g.dart';

@freezed
abstract class NovelParagraph with _$NovelParagraph {
  factory NovelParagraph({required String text, required String music_url}) =
      _NovelParagraph;

  factory NovelParagraph.fromJson(Map<String, dynamic> json) =>
      _$NovelParagraphFromJson(json);
}
