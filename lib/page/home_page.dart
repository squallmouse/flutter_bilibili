import 'package:bili/core/hi_state.dart';
import 'package:bili/http/dao/home_dao.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/page/home_tab_page.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/widget/home_navigation.dart';
import 'package:bili/widget/loading_container.dart';
import 'package:bili/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  // late final ValueChanged<VideoModel> onJumpToDetail;
  final VoidCallback jumpToMyPage;
  HomePage({Key? key, required this.jumpToMyPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
  TabBar _tabBar() {
    return TabBar(
      tabs: tabList(),
      onTap: (page) => print("page ==> ${page}"),
      isScrollable: true,
      unselectedLabelColor: Colors.black,
      labelColor: primary,
      controller: _tabController,
      // indicator: BoxDecoration(),
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

  /// 一个个具体的tab
  List<Widget> tabList() {
    return _categoryList.map((tab) {
      return Tab(
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Text(
            tab.name ?? "xyz???",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }).toList();
  }
}
