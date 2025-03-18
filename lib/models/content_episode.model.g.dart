// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_episode.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContentEpisode _$ContentEpisodeFromJson(Map<String, dynamic> json) =>
    _ContentEpisode(
      code: (json['code'] as num).toInt(),
      contentCode: (json['contentCode'] as num).toInt(),
      epTitle: json['epTitle'] as String,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String,
    );

Map<String, dynamic> _$ContentEpisodeToJson(_ContentEpisode instance) =>
    <String, dynamic>{
      'code': instance.code,
      'contentCode': instance.contentCode,
      'epTitle': instance.epTitle,
      'uploadDate': instance.uploadDate.toIso8601String(),
      'thumbnailUrl': instance.thumbnailUrl,
    };
