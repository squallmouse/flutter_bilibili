import 'package:bili/barrage/barrage_input.dart';
import 'package:bili/barrage/hi_barrage.dart';
import 'package:bili/barrage/hi_socket.dart';
import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/dao/favorite_dao.dart';
import 'package:bili/http/dao/like_dao.dart';
import 'package:bili/http/dao/video_detail_dao.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/model/video_detail_model.dart';
import 'package:bili/page/favorites_refersh_page.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/format_util.dart';
import 'package:bili/util/hi_constants.dart';
import 'package:bili/util/image_cached.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/toast.dart';
import 'package:bili/widget/appbar.dart';
import 'package:bili/widget/expandable_content.dart';
import 'package:bili/widget/hi_tab.dart';
import 'package:bili/widget/video_card.dart';
import 'package:bili/widget/video_list_card.dart';
import 'package:bili/widget/video_toolbar.dart';
import 'package:bili/widget/video_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_overlay/flutter_overlay.dart';

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
  late List<VideoModel> videoList = [];

  /// 弹幕 key
  var _barrageKey = GlobalKey<HiBarrageState>();

  /// 输入框显示
  bool _inoutShowing = false;

  /// video_detail 视频 详情页的数据
  VideoDetailModel? videoDetailModel;
  late TabController _tabController;
  final List<String> tabbarTitles = ["简介", "评论"];

  /// HiSocket
  // late HiSocket _hiSocket;

  //*  ------------------------------ */
  //*  methods
  @override
  void initState() {
    super.initState();
    videoModel = widget.argumentsMap["mode"];
    _tabController = TabController(length: tabbarTitles.length, vsync: this);
    // 获取数据
    _loadData();
  }

  void _loadData() async {
    try {
      videoDetailModel = await VideoDetailDao.get(vid: videoModel.vid ?? "");
      setState(() {
        videoModel = videoDetailModel!.videoInfo!;
        videoList = videoDetailModel!.videoList!;
      });
    } on NeedAuth catch (e) {
      myLog("${e}", StackTrace.current);
    } on HiNetError catch (e) {
      myLog(e, StackTrace.current);
    }
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
      barrageUI: HiBarrage(
        key: _barrageKey,
        vid: videoModel.vid!,
        // headers: HiConstants.headers(),
        autoPlay: true,
      ),
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
              child: InkWell(
                onTap: () {
                  _buildOverlay();
                },
                child: Icon(
                  Icons.live_tv_rounded,
                  color: Colors.grey,
                ),
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
            isLike: videoDetailModel?.isLike ?? false,
            onTap: _onTap,
            onFavorite: _onFavorite,
          ),
          // 一条横线
          Divider(
            height: 1,
          ),
          if (videoList.length > 0) ..._buildVideoList(),
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

  /// 点赞
  void _onTap() {
    try {
      LikeDao.like(
              vid: videoModel.vid!, isLike: videoDetailModel?.isLike ?? false)
          .then((response) {
        videoDetailModel!.isLike = !(videoDetailModel!.isLike!);
        if (videoDetailModel!.isLike!) {
          videoModel.like = videoModel.like! + 1;
        } else {
          videoModel.like = videoModel.like! - 1;
        }
        setState(() {
          videoModel = videoModel;
        });
        showToast(response["msg"]);
      });
    } on NeedAuth catch (e) {
      myLog(e, StackTrace.current);
    } on HiNetError catch (e) {
      myLog(e, StackTrace.current);
    }
  }

  /// 收藏
  void _onFavorite() {
    try {
      FavoriteDao.favorite(
              vid: videoModel.vid!,
              isFavorite: videoDetailModel?.isFavorite ?? false)
          .then((response) {
        videoDetailModel!.isFavorite = !(videoDetailModel!.isFavorite!);
        if (videoDetailModel!.isFavorite!) {
          videoModel.favorite = videoModel.favorite! + 1;
        } else {
          videoModel.favorite = videoModel.favorite! - 1;
        }
        setState(() {
          videoModel = videoModel;
        });
        showToast(response["msg"]);
      });
    } on NeedAuth catch (e) {
      myLog(e, StackTrace.current);
    } on HiNetError catch (e) {
      myLog(e, StackTrace.current);
    }
  }

  /// 详情页下面的 videolist
  _buildVideoList() {
    return videoList.map((VideoModel mo) {
      return VideoDetailCard(videoModel: mo);
    }).toList();
  }

  void _buildOverlay() {
    setState(() {
      _inoutShowing = true;
    });
    HiOverlay.show(context, child: BarrageInput(
      onTabClose: () {
        setState(() {
          _inoutShowing = false;
        });
      },
    )).then((value) {
      print("---->> input : ${value}");
      _barrageKey.currentState?.send(value);
    });
  }
}
