import 'package:bili/model/home_model.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/format_util.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/toast.dart';
import 'package:flutter/material.dart';

class VideoToolbar extends StatefulWidget {
  bool? isLike;
  bool? isFavorite;
  final VideoModel videoMo;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  VideoToolbar(
      {Key? key,
      required this.videoMo,
      required this.isLike,
      required this.isFavorite,
      required this.onTap,
      required this.onFavorite})
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
              ontap: widget.onTap,
              tintColor: widget.isLike),
          // 不喜欢
          _buildIconText(
            iconData: Icons.thumb_down_alt_rounded,
            underText: "不喜欢",
            ontap: () {
              showToast("不喜欢");
            },
          ),
          //coin
          _buildIconText(
            iconData: Icons.monetization_on,
            underText: countFormat(widget.videoMo.coin ?? 0),
            ontap: () {
              showToast("硬币");
            },
          ),
          //favorite
          _buildIconText(
              iconData: Icons.grade_rounded,
              underText: countFormat(widget.videoMo.favorite ?? 0),
              ontap: widget.onFavorite,
              tintColor: widget.isFavorite),
          //分享
          _buildIconText(
            iconData: Icons.share_rounded,
            underText: countFormat(widget.videoMo.share ?? 0),
            ontap: _onShare,
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

  /// 分享
  void _onShare() {
    showToast("分享!!~~");
  }
}
