import 'package:bili/model/home_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/util/format_util.dart';
import 'package:bili/util/image_cached.dart';
import 'package:bili/util/view_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VideoDetailCard extends StatelessWidget {
  final VideoModel videoModel;
  //
  final double _cardHeight = 90.0;
  final _smallTextColor = Colors.grey;
  final _smallTextFontSize = 10.0;
  const VideoDetailCard({
    Key? key,
    required this.videoModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HiNavigator.getInstance()
            .onJumpTo(RouteStatus.detail, args: {"mode": videoModel});
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey)),
        ),
        padding: EdgeInsets.fromLTRB(10, 7, 10, 5),
        height: _cardHeight,
        child: Row(
          children: [
            /// 左边区域
            _leftView(),

            /// 右边区域
            _rightView()
          ],
        ),
      ),
    );
  }

  // var temp = AspectRatio();

  /// 左边图片
  Widget _leftView() {
    double _height = _cardHeight;
    double _width = _cardHeight * (16.0 / 9.0);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: Container(
        // color: Colors.red,
        height: _height,
        width: _width,
        child: Stack(
          children: [
            ImageCachedUtils(videoModel.cover!,
                iheight: _height, iwidth: _width),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                color: Colors.black26,
                padding: EdgeInsets.all(3),
                child: Text(
                  durationToStr(videoModel.duration!),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 右边区域
  _rightView() {
    return Flexible(
      child: Container(
        // color: Colors.amberAccent,
        margin: EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            _buildRightTitle(),
            // 下边部分
            _buildRightBottomView()
          ],
        ),
      ),
    );
  }

  // 右边的标题
  _buildRightTitle() {
    return Text(
      videoModel.title ?? " 无题",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12),
    );
  }

  // 右边下边部分
  _buildRightBottomView() {
    return Container(
      child: Column(
        children: [
          // 作者
          _owner(),
          SizedBox(
            height: 5,
          ),
          _bottom()
        ],
      ),
    );
  }

  // 作者
  _owner() {
    TextStyle _style =
        TextStyle(fontSize: _smallTextFontSize, color: _smallTextColor);
    var _owner = videoModel.owner!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // UP
        Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: _smallTextColor),
          ),
          child: Text(
            "UP",
            style: _style,
          ),
        ),
        // 间隔
        Padding(padding: EdgeInsets.only(left: 8)),
        // 作者
        Text(
          _owner.name ?? " ",
          style: _style,
        )
      ],
    );
  }

  _bottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 左边
        Container(
          child: Row(
            children: [
              ...smallIconAndText(Icons.ondemand_video, videoModel.view),
              SizedBox(
                width: 8,
              ),
              ...smallIconAndText(Icons.list_alt, videoModel.reply)
            ],
          ),
        ),

        ///  右边
        Icon(
          Icons.more_vert_sharp,
          color: Colors.grey,
          size: 15,
        )
      ],
    );
  }
}
