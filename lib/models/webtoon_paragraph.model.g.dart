// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webtoon_paragraph.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebtoonParagraph _$WebtoonParagraphFromJson(Map<String, dynamic> json) =>
    _WebtoonParagraph(
      displayOrder: (json['displayOrder'] as num).toInt(),
      image_url: json['images'][0] as String,
      music_url: json['music_url'] as String,
    );

Map<String, dynamic> _$WebtoonParagraphToJson(_WebtoonParagraph instance) =>
    <String, dynamic>{
      'displayOrder': instance.displayOrder,
      'image_url': instance.image_url,
      'music_url': instance.music_url,
    };
