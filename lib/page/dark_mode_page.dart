import 'package:bili/provider/theme_provider.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModePage extends StatefulWidget {
  DarkModePage({Key? key}) : super(key: key);

  @override
  State<DarkModePage> createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  List<String> _cellList = ["跟随系统", "黑暗模式", "明亮模式"];
  List<ThemeMode> themeModeList = [
    ThemeMode.system,
    ThemeMode.dark,
    ThemeMode.light
  ];
  var _currentThemeMode;
  //*  ------------------------------ */
  //*  methods
  @override
  void initState() {
    super.initState();
    var themeProvider = context.read<ThemeProvider>();
    var themeMode = themeProvider.getThemeMode();
    themeModeList.forEach((mode) {
      if (themeMode == mode) {
        myLog("themeMode = ${themeMode}", StackTrace.current);
        _currentThemeMode = mode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var themeProvider = context.watch<ThemeProvider>();
    // var themeMode = themeProvider.getThemeMode();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: _currentThemeMode == ThemeMode.dark
                ? themeColorWhite
                : HiColor.dark_bg),
        centerTitle: true,
        title: Text(
          "夜间模式",
        ),
      ),
      body: Column(
        children: [
          /// list内容
          Expanded(
              child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _cellList.length,
            itemBuilder: (context, index) {
              return _buildCell(index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          ))
        ],
      ),
    );
  }

  Widget _buildCell(int index) {
    var _theme = themeModeList[index];
    return InkWell(
      onTap: () {
        _switchTheme(index);
      },
      child: Container(
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_cellList[index]),
            Opacity(
                opacity: _currentThemeMode == _theme ? 1 : 0,
                child: Icon(
                  Icons.done,
                  color: primary,
                ))
          ],
        ),
      ),
    );
  }

  void _switchTheme(int index) {
    var theme = themeModeList[index];
    context.read<ThemeProvider>().setTheme(theme);
    setState(() {
      _currentThemeMode = theme;
    });
  }
}
