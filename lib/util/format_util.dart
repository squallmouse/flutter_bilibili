/// 时间转换成 分钟:秒

String durationToStr(int seconds) {
  int m = (seconds / 60).truncate();
  int s = seconds - (m * 60);
  if (s < 10) {
    return "${m}:0${s}";
  } else {
    return "${m}:${s}";
  }
}

/// ...万
String countFormat(int num) {
  String viewStr = "";
  if (num > 9999) {
    viewStr = "${(num / 10000).toStringAsFixed(2)}万";
  } else {
    viewStr = num.toString();
  }
  return viewStr;
}
