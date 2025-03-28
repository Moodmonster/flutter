// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_episode.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContentEpisode _$ContentEpisodeFromJson(Map<String, dynamic> json) =>
    _ContentEpisode(
      code: json['episodeCode'] as String? ?? "",
      contentCode: json['contentCode'] as String,
      epTitle: json['epTitle'] as String,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String? ?? "",
      ttsUrl: json['ttsUrl'] as String? ?? "",
    );

Map<String, dynamic> _$ContentEpisodeToJson(_ContentEpisode instance) =>
    <String, dynamic>{
      'episodeCode': instance.code,
      'contentCode': instance.contentCode,
      'epTitle': instance.epTitle,
      'uploadDate': instance.uploadDate.toIso8601String(),
      'thumbnailUrl': instance.thumbnailUrl,
      'ttsUrl': instance.ttsUrl,
    };
