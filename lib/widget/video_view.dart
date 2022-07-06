import 'package:bili/util/color.dart';
import 'package:bili/util/hi_video_controller.dart';
import 'package:bili/util/image_cached.dart';
import 'package:bili/util/view_utils.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

/// 播放器组件
class VideoView extends StatefulWidget {
  final String url; // 视频播放的url
  final String cover; //视频封面
  final bool autoPlay; //自动播放
  final bool looping; // 循环播放
  final double aspectRatio; // 缩放比例
  final Widget overlayUI;
  // late final MYMaterialControls;
  VideoView(
      {Key? key,
      required this.url,
      required this.cover,
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,
      required this.overlayUI})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

//*  ------------------------------ */
//*  method
  Widget _placeHolder() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: ImageCachedUtils(widget.cover),
    );
  }

  /// 进度条颜色
  get _progressColors => ChewieProgressColors(
      playedColor: primary,
      handleColor: Colors.white,
      backgroundColor: Colors.grey,
      bufferedColor: primary[50]!);

  /// 初始化init
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      aspectRatio: widget.aspectRatio,
      placeholder: _placeHolder(),
      materialProgressColors: _progressColors,
      customControls: MyMaterialControls(
        overlayUI: widget.overlayUI, // 顶部渐变
        bottomGradient: blackLinearGradient(), //底部渐变
      ),
    );
    _chewieController.addListener(_fullScreenListen);
  }

  @override
  void dispose() {
    _chewieController.removeListener(_fullScreenListen);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _playerHeight = (_screenWidth / widget.aspectRatio).ceilToDouble();

    return Container(
      height: _playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  ///  添加是否全屏的监听
  void _fullScreenListen() {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width > screenSize.height) {
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}
