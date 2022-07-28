import 'package:bili/util/view_utils.dart';
import 'package:flutter/material.dart';

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
      this.statusBarTheme = StatusBarTheme.LIGHT})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor();

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

  //

}
