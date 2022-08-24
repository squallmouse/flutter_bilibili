import 'package:bili/db/hi_cache.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/hi_constants.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;
  var _platformBrightness = SchedulerBinding.instance.window.platformBrightness;

  /// 系统Dark Mode发生变化
  void darkModeChange() {
    if (_platformBrightness !=
        SchedulerBinding.instance.window.platformBrightness) {
      _platformBrightness = SchedulerBinding.instance.window.platformBrightness;
      notifyListeners();
    }
  }

  /// 判断是不是 dark mode
  bool isDark() {
    if (_themeMode == ThemeMode.system) {
      // 获取系统的dark mode
      return SchedulerBinding.instance.window.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// 获取主题模式
  ThemeMode getThemeMode() {
    String? theme = HiCache.getInstance().get(HiConstants.theme);
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'Light':
        _themeMode = ThemeMode.light;
        break;
      default:
        _themeMode = ThemeMode.system;
        break;
    }

    // _themeMode = ThemeMode.dark;
    return _themeMode!;
  }

  /// 设置主题
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    notifyListeners();
  }

  /// 获取主题
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
      primaryColor: isDarkMode ? HiColor.dark_bg : themeColorWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? HiColor.dark_bg : themeColorWhite,
        titleTextStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black,
          fontSize: 18,
          // fontWeight: FontWeight.bold,
        ),
      ),
      // tab 指示器的颜色
      indicatorColor: isDarkMode ? primary[50] : themeColorWhite,
      // 页面背景色
      scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : themeColorWhite,
    );
    return themeData;
  }
}
