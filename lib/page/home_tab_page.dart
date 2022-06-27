import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/dao/home_dao.dart';
import 'package:bili/model/home_model.dart';
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

  _test(int index) {
    var temp = index % 3;
    switch (temp) {
      case 0:
        return Colors.green;
        break;
      case 1:
        return Colors.yellow;
        break;
      case 2:
        return Colors.red;
        break;
      default:
    }
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
          return VideoCard(videoMo: _loadDataVideoList[index]);
          //_GridViewCreate(_loadDataVideoList[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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

  /// 保持生命
  @override
  bool get wantKeepAlive => true;
}
