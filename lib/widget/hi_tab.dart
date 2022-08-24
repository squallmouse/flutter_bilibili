import 'package:bili/provider/theme_provider.dart';
import 'package:bili/util/color.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:provider/provider.dart';

class MyTabBarNav extends StatelessWidget {
  final TabController tabController;
  final List<String> tabbarTitlesList;
  final Color? unselectedColor;
  final MaterialColor labelColor;

  /// tabbar 上的 各个小标题组件
  final List<Widget>? childs;
  // final List<Widget> childs;
  final Function(int) onTapFn;
  // Function(int) onTapFn(page);
  const MyTabBarNav({
    Key? key,
    required this.tabController,
    required this.tabbarTitlesList,
    this.unselectedColor = Colors.black,
    this.labelColor = primary,
    // required this.childs,
    required this.onTapFn,
    this.childs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var _unselectedLabelColor =
        themeProvider.isDark() ? Colors.white70 : this.unselectedColor;
    return TabBar(
      tabs: this.childs ?? _createTabs(),
      labelColor: this.labelColor,
      onTap: this.onTapFn,
      isScrollable: true,
      controller: this.tabController,
      unselectedLabelColor: _unselectedLabelColor,
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.round, // Set your line endings.
        borderSide: BorderSide(
          color: primary,
          width: 3,
        ),
        insets: EdgeInsets.fromLTRB(15, 0, 15, 0),
      ),
    );
  }

  /// tabbar 上面的 tab标题
  List<Widget> _createTabs() {
    return this.tabbarTitlesList.map((tabTitle) {
      return Tab(
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Text(
            tabTitle,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }).toList();
  }
}
