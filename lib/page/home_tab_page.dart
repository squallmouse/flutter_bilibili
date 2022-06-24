import 'package:bili/model/home_model.dart';
import 'package:bili/widget/hi_banner.dart';
import 'package:flutter/material.dart';

///
class HomeTabPage extends StatefulWidget {
  /// 哪边种类型
  final String name;

  /// 轮播图
  final List<BannerModel>? bannerList;

  HomeTabPage({Key? key, required this.name, this.bannerList})
      : super(key: key);
  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Widget _test() {
    if (widget.bannerList != null) {
      // 推荐页 有banner 轮播图
      print("进入banner");
      return _banner(widget.bannerList);
      // return Text("123321");
    } else {
      // 没有banner
      print("没有banner的普通页面");
      return Center(
        child: Text("${widget.name} ...."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: _test(),
    // );
    return ListView(
      children: [_test()],
    );
  }

  Widget _banner(List<BannerModel>? bannerList) {
    return HiBanner(
      bannerList: widget.bannerList!,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      // bannerHeight: 260,
    );
  }
}
