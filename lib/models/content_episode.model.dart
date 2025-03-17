//웹툰 한편한편에 대한 데이터
class ContentEpisode {
  final int code;
  final int contentCode; //해당 에피소드가 속해있는 웹툰의 고유 코드
  final String epTitle;
  final double stars;
  final DateTime uploadDate; //업로드된 날짜
  final String thumbnailUrl;

  ContentEpisode({
    required this.code,
    required this.contentCode,
    required this.epTitle,
    required this.stars,
    required this.uploadDate,
    required this.thumbnailUrl,
  });
}
