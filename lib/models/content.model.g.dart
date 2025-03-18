// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Content _$ContentFromJson(Map<String, dynamic> json) => _Content(
  code: (json['code'] as num).toInt(),
  title: json['title'] as String,
  desc: json['desc'] as String,
  author: json['author'] as String,
  userId: json['userId'] as String,
  contentType: $enumDecode(_$ContentTypeEnumMap, json['contentType']),
  clickCount: (json['clickCount'] as num).toInt(),
  thumbnailUrl: json['thumbnailUrl'] as String,
);

Map<String, dynamic> _$ContentToJson(_Content instance) => <String, dynamic>{
  'code': instance.code,
  'title': instance.title,
  'desc': instance.desc,
  'author': instance.author,
  'userId': instance.userId,
  'contentType': _$ContentTypeEnumMap[instance.contentType]!,
  'clickCount': instance.clickCount,
  'thumbnailUrl': instance.thumbnailUrl,
};

const _$ContentTypeEnumMap = {
  ContentType.Webtoon: 'Webtoon',
  ContentType.Novel: 'Novel',
};
