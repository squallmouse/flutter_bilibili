import 'dart:io';

import 'package:bili/model/home_model.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/view_utils.dart';
import 'package:bili/widget/appbar.dart';
import 'package:bili/widget/hi_tab.dart';
import 'package:bili/widget/navigation_bar.dart';
import 'package:bili/widget/video_view.dart';

import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  final Map argumentsMap;
  VideoDetailPage({Key? key, required this.argumentsMap}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late VideoModel videoModel;
  late TabController _tabController;
  final List<String> tabbarTitles = ["简介", "评论"];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabbarTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ///build
  @override
  Widget build(BuildContext context) {
    videoModel = widget.argumentsMap["mode"];
    myLog("message = ${videoModel}", StackTrace.current);
    // changeStatusBarColor(statusBarTheme: StatusBarTheme.DARK);
    //状态栏高度
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: top,
            // child: Container(color: Colors.black87),
          ),

          /// 视频
          _videoPlayer(),

          ///
          _detailTabbarNav(),

          // Flexible(child: child)
        ],
      ),
    );
  }

  /// 视频播放器
  _videoPlayer() {
    return VideoView(
      url: videoModel.url ?? "",
      cover: videoModel.cover ?? "",
      overlayUI: videoAppBar(),
    );
  }

  /// tabbar 的标题
  _detailTabbarNav() {
    var _tabbar = MyTabBarNav(
      tabbarTitlesList: tabbarTitles,
      onTapFn: (page) => print("page --> ${page}"),
      tabController: _tabController,
    );
    return Material(
      elevation: 5.0,
      shadowColor: Colors.black54,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabbar,
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
