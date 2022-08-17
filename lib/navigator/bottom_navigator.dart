import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/page/favorite_page.dart';
import 'package:bili/page/home_page.dart';
import 'package:bili/page/profile_page.dart';
import 'package:bili/page/ranking_page.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

///底部导航栏
class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 3;
  final PageController _pageviewController = PageController(initialPage: 3);
  late List<Widget> _pages;

  //*  ------------------------------ */
  //*  method
  @override
  Widget build(BuildContext context) {
    _pages = [
      HomePage(jumpToMyPage: () {
        _jumpTo(3);
      }),
      RankingPage(),
      FavoritePage(),
      ProfilePage()
    ];
    return Scaffold(
      body: PageView(
        //禁止滚动
        physics: NeverScrollableScrollPhysics(),
        controller: _pageviewController,
        children: _pages,
        // 不能滑动了..暂时不需要这个方法了
        // onPageChanged: (index) {
        //   myLog("onPageChanged", StackTrace.current);
        // },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: _activeColor,
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.live_tv, 3),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => _jumpTo(index),
      ),
    );
  }

  void _jumpTo(index) {
    HiNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    _pageviewController.jumpToPage(index);
    setState(() {
      _currentIndex = index;
    });
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: _defaultColor),
        activeIcon: Icon(icon, color: _activeColor),
        label: title);
  }
}
