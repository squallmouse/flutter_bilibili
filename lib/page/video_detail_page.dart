import 'dart:io';

import 'package:bili/model/home_model.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/view_utils.dart';
import 'package:bili/widget/appbar.dart';
import 'package:bili/widget/navigation_bar.dart';
import 'package:bili/widget/video_view.dart';

import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  final Map argumentsMap;
  VideoDetailPage({Key? key, required this.argumentsMap}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late VideoModel videoModel;
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
          _videoPlayer(),
          Text("视频详情页, vid:${videoModel.id}"),
          Text("视频标题 : ${videoModel.title}"),
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
}
