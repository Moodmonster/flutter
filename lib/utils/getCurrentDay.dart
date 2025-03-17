import 'package:moodmonster/models/content.model.dart';

Days getCurrentDay() {
  int weekday = DateTime.now().weekday;

  return Days.values[weekday - 1]; // 1부터 시작하므로 -1 필요
}
