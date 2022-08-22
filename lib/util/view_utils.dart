/// 一些样式相关的变化
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/page/profile_page.dart';
import 'package:bili/page/video_detail_page.dart';
import 'package:bili/provider/theme_provider.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/format_util.dart';
import 'package:bili/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:provider/provider.dart';

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
void changeStatusBarColor({
  Color statusColor = Colors.white,
  StatusBarTheme statusBarTheme = StatusBarTheme.LIGHT,
  BuildContext? context,
}) async {
  if (context != null) {
    var themeProvider = context.watch<ThemeProvider>();
    if (themeProvider.isDark()) {
      statusBarTheme = StatusBarTheme.LIGHT;
      statusColor = HiColor.dark_bg;
    }
  }
  var page = HiNavigator.getInstance().getCurrent()?.page;
  if (page is ProfilePage) {
    statusColor = Colors.transparent;
  } else if (page is VideoDetailPage) {
    statusBarTheme = StatusBarTheme.LIGHT;
    statusColor = Colors.black;
  }

  /// 状态栏样式
  await StatusBarControl.setColor(statusColor, animated: false);
  // await StatusBarControl.setColor(Colors.orange, animated: false);
  await StatusBarControl.setStyle(statusBarTheme == StatusBarTheme.DARK
      ? StatusBarStyle.DARK_CONTENT
      : StatusBarStyle.LIGHT_CONTENT);
}

/// 带文字的小图标
// List<Widget>
List<Widget> smallIconAndText(IconData icondata, var text) {
  var _textStyle = TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countFormat(text);
  }
  return [
    Icon(
      icondata,
      color: Colors.grey,
      size: 12,
    ),
    Padding(padding: EdgeInsets.only(left: 5)),
    Text(
      "${text}",
      style: _textStyle,
    )
  ];
}

// 上面icon 下面text
smallIconButton(IconData icondata, String text, Function()? ontap) {
  Color _textColor = Colors.grey;
  Color _iconColor = Colors.grey;
  return Container(
      width: 44,
      height: 44,
      child: InkWell(
        onTap: ontap,
        child: Column(
          children: [
            Icon(
              icondata,
              size: 20,
              color: _iconColor,
            ),
            Text(text,
                style: TextStyle(
                  fontSize: 15,
                  color: _textColor,
                ))
          ],
        ),
      ));
}

/// 底部阴影
BoxDecoration? bottomBoxShadow(BuildContext context) {
  var themeProvider = context.watch<ThemeProvider>();
  if (themeProvider.isDark()) {
    return null;
  }
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey[100]!,
        offset: Offset(0, 5),
        blurRadius: 5.0, //阴影模糊程度
        spreadRadius: 1, //阴影扩散程度
      )
    ],
  );
}
