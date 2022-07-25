import 'package:bili/model/home_model.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/format_util.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

class VideoToolbar extends StatefulWidget {
  bool? isLike;
  bool? isFavorite;
  final VideoModel videoMo;

  VideoToolbar(
      {Key? key,
      required this.videoMo,
      required this.isLike,
      required this.isFavorite})
      : super(key: key);

  @override
  State<VideoToolbar> createState() => _VideoToolbarState();
}

class _VideoToolbarState extends State<VideoToolbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 点赞
          _buildIconText(
              iconData: Icons.thumb_up_alt_rounded,
              underText: countFormat(widget.videoMo.like ?? 0),
              ontap: () {
                myLog("like ==> ", StackTrace.current);
              },
              tintColor: widget.isLike),
          // 不喜欢
          _buildIconText(
            iconData: Icons.thumb_down_alt_rounded,
            underText: "不喜欢",
            ontap: () {
              myLog("不喜欢 ==> ", StackTrace.current);
            },
          ),
          //coin
          _buildIconText(
            iconData: Icons.monetization_on,
            underText: countFormat(widget.videoMo.coin ?? 0),
            ontap: () {
              myLog("coin ==> ", StackTrace.current);
            },
          ),
          //favorite
          _buildIconText(
              iconData: Icons.grade_rounded,
              underText: countFormat(widget.videoMo.favorite ?? 0),
              ontap: () {
                myLog("favorite ==> ", StackTrace.current);
              },
              tintColor: widget.isFavorite),
          //分享
          _buildIconText(
            iconData: Icons.share_rounded,
            underText: countFormat(widget.videoMo.share ?? 0),
            ontap: () {
              myLog("share ==> ", StackTrace.current);
            },
          ),
        ],
      ),
    );
  }

  /// 上icon 下text
  _buildIconText({
    required IconData iconData,
    required String underText,
    VoidCallback? ontap,
    bool? tintColor = false,
  }) {
    Color _textColor = Colors.grey;
    Color _iconColor = Colors.grey;
    return Container(
        width: 64,
        height: 44,
        child: Center(
          child: InkWell(
            onTap: ontap,
            child: Column(
              children: [
                Icon(
                  iconData,
                  size: 20,
                  color: tintColor! ? primary : _iconColor,
                ),
                Text(underText,
                    style: TextStyle(
                      fontSize: 15,
                      color: tintColor ? primary : _textColor,
                    ))
              ],
            ),
          ),
        ));
  }
}
