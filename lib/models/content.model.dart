enum Days { mon, tue, wed, thu, fri, sat, sun }

class Content {
  final int code;
  final String title;
  final String desc;
  final String author;
  final Days releaseDay;
  final double stars;
  final bool isAdultsOnly; //청소년관람불가 여부
  final bool isCompleted; //완결여부
  final String thumbnailUrl;

  Content(
    this.code,
    this.title,

    this.desc,
    this.author,
    this.releaseDay,
    this.stars,
    this.isAdultsOnly,
    this.isCompleted,
    this.thumbnailUrl,
  );
}
