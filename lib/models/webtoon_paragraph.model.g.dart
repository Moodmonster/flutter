// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webtoon_paragraph.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebtoonParagraph _$WebtoonParagraphFromJson(Map<String, dynamic> json) =>
    _WebtoonParagraph(
      displayOrder: (json['displayOrder'] as num).toInt(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      music_url: json['music_url'] as String,
    );

Map<String, dynamic> _$WebtoonParagraphToJson(_WebtoonParagraph instance) =>
    <String, dynamic>{
      'displayOrder': instance.displayOrder,
      'images': instance.images,
      'music_url': instance.music_url,
    };
