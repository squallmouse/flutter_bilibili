import 'package:bili/http/dao/video_detail_dao.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/model/video_detail_model.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/format_util.dart';
import 'package:bili/util/image_cached.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/widget/appbar.dart';
import 'package:bili/widget/expandable_content.dart';
import 'package:bili/widget/hi_tab.dart';
import 'package:bili/widget/video_toolbar.dart';
import 'package:bili/widget/video_view.dart';

import 'package:flutter/material.dart';

import '../model/owner.dart';

class VideoDetailPage extends StatefulWidget {
  final Map argumentsMap;
  VideoDetailPage({Key? key, required this.argumentsMap}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  /// 从home页面传过来的数据
  late VideoModel videoModel;

  /// video_detail_list
  late List<VideoModel> videoList;

  /// video_detail 视频 详情页的数据
  VideoDetailModel? videoDetailModel;
  late TabController _tabController;
  final List<String> tabbarTitles = ["简介", "评论"];
  @override
  void initState() {
    super.initState();
    videoModel = widget.argumentsMap["mode"];
    _tabController = TabController(length: tabbarTitles.length, vsync: this);
    _loadData();
  }

  void _loadData() async {
    //TODO   获取数据
    videoDetailModel = await VideoDetailDao.get(vid: videoModel.vid ?? "");
    myLog("_loaddata ==>>> ${videoDetailModel}", StackTrace.current);
    setState(() {
      videoModel = videoDetailModel!.videoInfo!;
      videoList = videoDetailModel!.videoList!;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ///build
  @override
  Widget build(BuildContext context) {
    // videoModel = widget.argumentsMap["mode"];
    // myLog("message = ${videoModel}", StackTrace.current);
    // changeStatusBarColor(statusBarTheme: StatusBarTheme.DARK);
    //状态栏高度
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Column(
        children: [
          /// 状态栏占位
          SizedBox(
            height: top,
            // child: Container(color: Colors.black87),
          ),

          /// 视频
          _videoPlayer(),

          /// tabbar nav
          _detailTabbarNav(),

          /// 简介 & 评论 --> 内容区域
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// 简介区域内容
                _buildIntroduction(),

                /// 评论
                Text("评论~~~~~")
              ],
            ),
          )
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

  /// 创建简介区的内容
  Widget _buildIntroduction() {
    myLog("_buildIntroduction ==> videoDetailModel", StackTrace.current);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        children: [
          _videoHeadView(),
          //详情
          ExpandableContent(
            model: videoModel,
          ),
          //
          VideoToolbar(
              videoMo: videoModel,
              isFavorite: videoDetailModel?.isFavorite ?? false,
              isLike: videoDetailModel?.isLike ?? false
              // videoDetailModel != null ? videoDetailModel.isLike : false,
              ),
          Container(
            color: Colors.red,
            height: 100,
          )
        ],
      ),
    );
  }

  /// 作者...关注
  Widget _videoHeadView() {
    Owner owner = videoModel.owner!;
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: ImageCachedUtils(owner.face ?? "",
                      iwidth: 40, iheight: 40),
                ),
                Padding(padding: EdgeInsets.only(left: 15)),
                Column(
                  children: [
                    /// 名字
                    Text(
                      owner.name ?? "noname",
                      style: TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),

                    /// 粉丝
                    Text(
                      "${countFormat(owner.fans ?? 0)}粉丝",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// 关注
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: MaterialButton(
                  onPressed: () {
                    myLog("关注按钮 -- click", StackTrace.current);
                  },
                  color: primary,
                  child: Text(
                    "+关注",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
