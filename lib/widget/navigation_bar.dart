import 'package:flutter/material.dart';
import 'package:status_bar_control/status_bar_control.dart';

enum StatusBarTheme { LIGHT, DARK, SYSTEM }

class NavigationBarMy extends StatelessWidget {
  final StatusBarTheme statusBarTheme;
  final double contentHieght;
  final Widget child;
  final Color statusColor;
  const NavigationBarMy(
      {Key? key,
      this.contentHieght = 46.0,
      required this.child,
      this.statusColor = Colors.white,
      this.statusBarTheme = StatusBarTheme.DARK})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _statusBarInit();

    ///状态栏 的高度
    double top = MediaQuery.of(context).padding.top;
    return Container(
      height: top + contentHieght,
      width: MediaQuery.of(context).size.width,
      child: child,
      padding: EdgeInsets.only(top: top),
      color: statusColor,
    );
  }

  void _statusBarInit() async {
    await StatusBarControl.setColor(statusColor, animated: false);
    // await StatusBarControl.setColor(Colors.orange, animated: false);
    await StatusBarControl.setStyle(statusBarTheme != StatusBarTheme.DARK
        ? StatusBarStyle.DARK_CONTENT
        : StatusBarStyle.LIGHT_CONTENT);
  }
}
