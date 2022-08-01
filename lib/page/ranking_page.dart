import 'package:bili/page/ranking_refersh_page.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/widget/hi_tab.dart';
import 'package:bili/widget/navigation_bar.dart';
import 'package:flutter/material.dart';

/// 排行榜
class RankingPage extends StatefulWidget {
  RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with TickerProviderStateMixin {
  final List<String> titleList = [
    "最热",
    "最新",
    "收藏",
  ];
  final sortType = [
    "like",
    "pubdate",
    "favorite",
  ];
  late TabController _tabController;
  //*  ------------------------------ */
  //*
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: titleList.length, vsync: this);
    // _tabController.addListener(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ///
          NavigationBarMy(
            child: Center(
              child: MyTabBarNav(
                tabController: _tabController,
                tabbarTitlesList: titleList,
                onTapFn: (page) =>
                    myLog("this page => ${page}", StackTrace.current),
              ),
            ),
          ),

          /// 页面
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: sortType.map((type) {
                Map dict = {"type": type};
                return RefershPage(dict: dict);
              }).toList(),
            ),
          ),

          ///
        ],
      ),
    );
  }
}
