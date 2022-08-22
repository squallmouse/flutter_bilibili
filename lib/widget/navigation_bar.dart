import 'package:bili/provider/theme_provider.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum StatusBarTheme { LIGHT, DARK, SYSTEM }

class NavigationBarMy extends StatefulWidget {
  final StatusBarTheme statusBarTheme;
  final double contentHieght;
  final Widget child;
  final Color statusColor;
  NavigationBarMy(
      {Key? key,
      this.contentHieght = 46.0,
      required this.child,
      this.statusColor = Colors.white,
      this.statusBarTheme = StatusBarTheme.LIGHT})
      : super(key: key);
  // NavigationBarMy({Key? key}) : super(key: key);

  @override
  State<NavigationBarMy> createState() => _NavigationBarMyState();
}

class _NavigationBarMyState extends State<NavigationBarMy> {
  var _statusStyle;
  var _color;

  /// 沉浸式状态栏
  void _statusBarInit() {
    changeStatusBarColor(statusColor: _color, statusBarTheme: _statusStyle);
  }

  @override
  Widget build(BuildContext context) {
    // changeStatusBarColor(); // 11-3 注释
    var themeProvider = context.watch<ThemeProvider>();
    if (themeProvider.isDark()) {
      _color = HiColor.dark_bg;
      _statusStyle = StatusBarTheme.LIGHT;
    } else {
      _color = widget.statusColor;
      _statusStyle = widget.statusBarTheme;
    }
    myLog("来到了navigatorbarmy", StackTrace.current);
    _statusBarInit();

    ///状态栏 的高度
    double top = MediaQuery.of(context).padding.top;

    return Container(
      height: top + widget.contentHieght,
      width: MediaQuery.of(context).size.width,
      child: widget.child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: _color),
    );
  }
}
