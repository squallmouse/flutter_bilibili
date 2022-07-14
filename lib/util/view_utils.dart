/// 一些样式相关的变化
import 'package:bili/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:status_bar_control/status_bar_control.dart';

/// 黑色的渐变线
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
    begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
    end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
    colors: [
      Colors.black54,
      Colors.black45,
      Colors.black38,
      Colors.black26,
      Colors.black12,
      Colors.transparent
    ],
  );
}

/// 改变状态栏的颜色 颜色默认是白色, 主题默认light:白色状态栏,黑字
void changeStatusBarColor(
    {Color statusColor = Colors.white,
    StatusBarTheme statusBarTheme = StatusBarTheme.LIGHT}) async {
  await StatusBarControl.setColor(statusColor, animated: false);
  // await StatusBarControl.setColor(Colors.orange, animated: false);
  await StatusBarControl.setStyle(statusBarTheme != StatusBarTheme.DARK
      ? StatusBarStyle.DARK_CONTENT
      : StatusBarStyle.LIGHT_CONTENT);
}