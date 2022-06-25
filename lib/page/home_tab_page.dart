import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/dao/home_dao.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/toast.dart';
import 'package:bili/widget/hi_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nested/flutter_nested.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

///
class HomeTabPage extends StatefulWidget {
  /// 哪边种类型
  final String categoryName;

  /// 轮播图
  final List<BannerModel>? bannerList;

  HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);
  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  ///  存放获取的数据
  List<VideoModel> _loadDataVideoList = [];

  ///  是否刷新
  bool _isRefresh = true;

  /// 哪一页
  int _pageIndex = 1;
  //*  ------------------------------ */
  //*  method
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget _buildPage() {
    return HiNestedScrollView(
        controller: ScrollController(),
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        headers: [
          if (widget.bannerList != null) _banner(widget.bannerList),
          SizedBox(height: 10),
        ],
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _loadDataVideoList.length,
        itemBuilder: (BuildContext context, int index) {
          return _GridViewCreate(_loadDataVideoList[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: _buildPage(),
    );
  }

  /// banner 轮播图
  Widget _banner(List<BannerModel>? bannerList) {
    return HiBanner(
      bannerList: widget.bannerList!,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      // bannerHeight: 260,
    );
  }

  /// 获取数据
  void _loadData() {
    _pageIndex = _isRefresh == true ? 1 : _pageIndex + 1;
    try {
      HomeDao.get(categoryName: widget.categoryName, pageIndex: _pageIndex)
          .then(
        (homeMo) {
          List<VideoModel> tempList = [...?homeMo.videoList];
          setState(() {
            _loadDataVideoList = [..._loadDataVideoList, ...tempList];
          });
          myLog("message = ${_loadDataVideoList}", StackTrace.current);
        },
      );
    } on NeedAuth catch (e) {
      myLog("NeedAuth --> $e", StackTrace.current);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      myLog("HiNetError --> $e", StackTrace.current);
      showWarnToast(e.message);
    }
  }

  /// 创建GridView
  Widget _GridViewCreate(VideoModel videoMO) {
    return Container(
      // padding: EdgeInsets.only(left: 8, right: 8),
      height: 160,
      child: Image.network(
        videoMO.cover ?? "",
        fit: BoxFit.cover,
      ),
    );
  }

  /// 保持生命
  @override
  bool get wantKeepAlive => true;
}
