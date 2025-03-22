//컨텐츠 한 목차에 대한 데이터
import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_episode.model.freezed.dart';
part 'content_episode.model.g.dart';

@freezed
abstract class ContentEpisode with _$ContentEpisode {
  factory ContentEpisode({
    required String code,
    required String contentCode, //해당 에피소드가 속해있는 웹툰의 고유 코드
    required String epTitle,
    required DateTime uploadDate, //업로드된 날짜
    required String thumbnailUrl,
  }) = _ContentEpisode;

  factory ContentEpisode.fromJson(Map<String, dynamic> json) =>
      _$ContentEpisodeFromJson(json);
}

// class ContentEpisode {
//   final String code;
//   final String contentCode; //해당 에피소드가 속해있는 콘텐츠의 고유 코드
//   final String epTitle;
//   final DateTime uploadDate; //업로드된 날짜
//   final String thumbnailUrl;
//   ContentEpisode({
//     required this.code,
//     required this.contentCode,
//     required this.epTitle,
//     required this.uploadDate,
//     required this.thumbnailUrl,
//   });
// }
