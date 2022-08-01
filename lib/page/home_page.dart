import 'dart:io';

import 'package:bili/core/hi_state.dart';
import 'package:bili/http/dao/home_dao.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/page/home_tab_page.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/view_utils.dart';
import 'package:bili/widget/hi_tab.dart';
import 'package:bili/widget/home_navigation.dart';
import 'package:bili/widget/loading_container.dart';
import 'package:bili/widget/navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // late final ValueChanged<VideoModel> onJumpToDetail;
  final VoidCallback jumpToMyPage;
  HomePage({Key? key, required this.jumpToMyPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  late RouteChangeListener listener;
  late TabController _tabController;
  // var _tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];
  List<CategoryModel> _categoryList = [];
  late HomeModel? _homeModel;

  /// 首页没有数据加载出来前,加载动画
  bool _isLoading = true;
  //*  ------------------------------ */
  //*  method
  @override
  void dispose() {
    myLog("homePage-->dispose", StackTrace.current);
    HiNavigator.getInstance().removeListener(this.listener);
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 监听生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    myLog("监听生命周期 : ${state} ", StackTrace.current);
    switch (state) {
      case AppLifecycleState.inactive: //不活跃的,即将进入后台
        myLog("不活跃的,即将进入后台", StackTrace.current);
        break;
      case AppLifecycleState.resumed: //从后台切换到了前台
        myLog("从后台切换到了前台", StackTrace.current);
        if (Platform.isAndroid) {
          changeStatusBarColor();
        }
        break;
      case AppLifecycleState.paused: // 界面不可见,在后台
        myLog("界面不可见,在后台", StackTrace.current);
        break;
      case AppLifecycleState.detached: // app结束调用
        myLog("app结束调用", StackTrace.current);
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    /// 应用前后台切换监听
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: _categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      // myLog("homePage-->current:${current.page}", StackTrace.current);
      // myLog("homePage-->pre:${pre?.page}", StackTrace.current);
      if (widget == current.page || current.page is HomePage) {
        // myLog("打开了首页:onResume", StackTrace.current);
      } else if (widget == pre?.page || pre?.page is HomePage) {
        // myLog("首页:onPause", StackTrace.current);
      }
    });
    _loadData();
  }

  void _loadData() {
    // myLog("?????????????---> 请求前", StackTrace.current);
    HomeDao.get(categoryName: "推荐").then((homeMo) {
      myLog("?????????????---> finish : ${homeMo}", StackTrace.current);
      if (homeMo.categoryList != null) {
        setState(() {
          _homeModel = homeMo;
          _categoryList = homeMo.categoryList!;
          _isLoading = false;
        });

        _tabController =
            TabController(length: _categoryList.length, vsync: this);
        _isLoading = false;
      }
    });
    // myLog("?????????????---> 请求后", StackTrace.current);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Column(
          children: [
            NavigationBarMy(
              child: HomeNavigationWidget(
                jumpToMy: widget.jumpToMyPage,
              ),
            ),
            Container(
              color: Colors.white,
              // padding: EdgeInsets.only(top: 0),
              child: _tabBar(),
            ),
            Flexible(
                child: TabBarView(
              controller: _tabController,
              children: _categoryList.map((tab) {
                // 首页的页面
                return HomeTabPage(
                  categoryName: tab.name ?? "xyz???",
                  bannerList:
                      (tab.name == "推荐") ? _homeModel?.bannerList : null,
                );
              }).toList(),
            ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  /// 自定义的tabBar
  // TabBar _tabBar() {
  Widget _tabBar() {
    /// 标题的数组
    List<String> titleList = _categoryList.map((tab) {
      return tab.name ?? "xx-noname";
    }).toList();
    return MyTabBarNav(
      tabbarTitlesList: titleList,
      onTapFn: (page) => print("page ==> ${page}"),
      tabController: _tabController,
      // childs: tabList(),
    );
  }

  ///
}
