import 'package:bili/core/hi_state.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

/// M : dao 返回的模型类型
/// L : dataArr 的类型
/// pageChild : 页面
abstract class HiRefershPage<M, L, pageChild extends StatefulWidget>
    extends HiState<pageChild> with AutomaticKeepAliveClientMixin {
  ///  存放获取的数据
  List<L> dataArr = [];

  ///  是否正在加载数据
  bool isLoading = false;

  /// 哪一页
  int pageIndex = 1;

  /// 控制器
  var scController = ScrollController();

  //*  ------------------------------ */
  //*  method
  @override
  void dispose() {
    scController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //控制器添加监听
    scController.addListener(() {
      // 控制器的最大距离 - 滑动的距离
      var dis =
          scController.position.maxScrollExtent - scController.position.pixels;
      myLog("dis ==> ${dis} ", StackTrace.current);
      //当距离底部不足300时加载更多
      if (dis < 300 && !isLoading) {
        print("--------loading----------");
        myLog("dis ==> ${dis} ", StackTrace.current);
        loadData(loadMore: true);
      }
    });

    /// 加载数据
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      color: primary,
      onRefresh: loadData,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: buildPageChild(),
      ),
    );
  }

  /// 保持生命
  @override
  bool get wantKeepAlive => true;

  /// 构建页面 Widget
  Widget buildPageChild();

  /// 获取数据
  Future<void> loadData({bool loadMore = false});
}
