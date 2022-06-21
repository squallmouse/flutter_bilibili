import 'package:bili/model/video_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/page/home_tab_page.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  // late final ValueChanged<VideoModel> onJumpToDetail;
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late RouteChangeListener listener;
  late TabController _tabController;
  var _tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];
  //*  ------------------------------ */
  //*  method
  @override
  void dispose() {
    myLog("homePage-->dispose", StackTrace.current);
    HiNavigator.getInstance().removeListener(this.listener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      myLog("homePage-->current:${current.page}", StackTrace.current);
      myLog("homePage-->pre:${pre?.page}", StackTrace.current);
      if (widget == current.page || current.page is HomePage) {
        myLog("打开了首页:onResume", StackTrace.current);
      } else if (widget == pre?.page || pre?.page is HomePage) {
        myLog("首页:onPause", StackTrace.current);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
              child: TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) {
              return HomeTabPage(name: tab);
            }).toList(),
          ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  /// 自定义的tab
  _tabBar() {
    return TabBar(
      tabs: tabList(),
      isScrollable: true,
      labelColor: Colors.black,
      controller: _tabController,
      // indicator: BoxDecoration(),
      indicator: UnderlineIndicator(
        strokeCap: StrokeCap.round, // Set your line endings.
        borderSide: BorderSide(
          color: primary,
          width: 3,
        ),
        insets: EdgeInsets.fromLTRB(15, 0, 15, 5),
      ),
    );
  }

  List<Widget> tabList() {
    return _tabs.map((tab) {
      return Tab(
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Text(
            tab,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }).toList();
  }
}
