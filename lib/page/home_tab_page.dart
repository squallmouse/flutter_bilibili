import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/dao/home_dao.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/toast.dart';
import 'package:bili/widget/hi_banner.dart';
import 'package:bili/widget/video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nested/flutter_nested.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

///
class HomeTabPage extends StatefulWidget {
  /// 哪边种类型
  final String categoryName;

  /// 轮播图
  final List<BannerModel>? bannerList;

  HomeTabPage({
    Key? key,
    required this.categoryName,
    this.bannerList,
  }) : super(key: key);
  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  ///  存放获取的数据
  List<VideoModel> _loadDataVideoList = [];

  ///  是否正在加载数据
  bool _isLoading = true;

  /// 哪一页
  int _pageIndex = 1;

  /// 控制器
  var _controller = ScrollController();
  //*  ------------------------------ */
  //*  method
  @override
  void initState() {
    super.initState();
    //控制器添加监听
    _controller.addListener(() {
      // 控制器的最大距离 - 滑动的距离
      var dis =
          _controller.position.maxScrollExtent - _controller.position.pixels;

      //当距离底部不足300时加载更多
      if (dis < 300 && !_isLoading) {
        print("--------loading----------");
        myLog("dis ==> ${dis} ", StackTrace.current);
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      color: primary,
      onRefresh: _loadData,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: _buildPage(),
      ),
    );
  }

  /// 构建页面
  Widget _buildPage() {
    return HiNestedScrollView(
        controller: _controller,
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        headers: [
          if (widget.bannerList != null) _banner(widget.bannerList),
          SizedBox(height: 10),
        ],
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.9),
        itemCount: _loadDataVideoList.length,
        itemBuilder: (BuildContext context, int index) {
          return VideoCard(videoMo: _loadDataVideoList[index]);
          //_GridViewCreate(_loadDataVideoList[index]);
        });
  }

  /// banner 轮播图
  Widget _banner(List<BannerModel>? bannerList) {
    return HiBanner(
      bannerList: widget.bannerList!,
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      // bannerHeight: 260,
    );
  }

  /// 获取数据
  Future<void> _loadData({bool loadMore = false}) async {
    // loadMore = true : 加载更多 ; false: 刷新
    _pageIndex = (loadMore == false ? 1 : _pageIndex + 1);
    _isLoading = true;

    try {
      await HomeDao.get(
              categoryName: widget.categoryName, pageIndex: _pageIndex)
          .then(
        (homeMo) {
          List<VideoModel> tempList = [...?homeMo.videoList];
          if (loadMore == false) {
            _loadDataVideoList = [];
          }
          setState(() {
            _loadDataVideoList = [
              ..._loadDataVideoList,
              ...tempList,
            ];
            _isLoading = false;
          });
        },
      );
    } on NeedAuth catch (e) {
      myLog("NeedAuth --> $e", StackTrace.current);
      _isLoading = false;
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      myLog("HiNetError --> $e", StackTrace.current);
      _isLoading = false;
      showWarnToast(e.message);
    }
  }

  /// 保持生命
  @override
  bool get wantKeepAlive => true;
}
