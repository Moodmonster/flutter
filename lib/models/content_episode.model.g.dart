// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_episode.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContentEpisode _$ContentEpisodeFromJson(Map<String, dynamic> json) {
  DateTime dateTime;
  String thumbnailUrl;
  //uploadDate 형식 이상하면 오늘 날짜로 나오게
  try {
    dateTime = DateTime.parse(json['uploadDate']);
  } catch (err) {
    dateTime = DateTime.now();
  }
  //json에 thumbnailUrl없으면(=소설데이터) 빈문자열로 처리
  if (json['thumbnailUrl'] == null) {
    thumbnailUrl = "";
  } else {
    thumbnailUrl = json['thumbnailUrl'] as String;
  }
  return _ContentEpisode(
    code: json['episodeCode'] as String,
    contentCode: json['contentCode'] as String,
    epTitle: json['epTitle'] as String,
    uploadDate: dateTime,
    thumbnailUrl: thumbnailUrl,
  );
}

Map<String, dynamic> _$ContentEpisodeToJson(_ContentEpisode instance) =>
    <String, dynamic>{
      'code': instance.code,
      'contentCode': instance.contentCode,
      'epTitle': instance.epTitle,
      'uploadDate': instance.uploadDate.toIso8601String(),
      'thumbnailUrl': instance.thumbnailUrl,
    };
