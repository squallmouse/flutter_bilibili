import 'package:bili/model/home_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/util/format_util.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class VideoCard extends StatelessWidget {
  final VideoModel videoMo;
  const VideoCard({Key? key, required this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HiNavigator.getInstance()
            .onJumpTo(RouteStatus.detail, args: {"mode": videoMo});
      },
      child: Container(
        // color: Colors.green,
        // height: 200,
        child: Card(
          // color: Colors.red,
          margin: EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _itemImage(context),
                _infoView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 图片
  _itemImage(context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ///
        FadeInImage.memoryNetwork(
          fit: BoxFit.cover,
          placeholder: kTransparentImage,
          image: videoMo.cover ?? "",
          width: size.width / 2 - 10,
          height: 110,
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            // color: Colors.black87,
            decoration: BoxDecoration(
              //渐变
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
            // height: 20,
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.ondemand_video, videoMo.view),
                  _iconText(Icons.favorite_border, videoMo.favorite),
                  _iconText(null, videoMo.duration)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 图片下面的图和字
  _iconText(IconData? iconData, int? count) {
    String str = "";
    if (iconData == null) {
      str = durationToStr(count!);
    } else {
      str = countFormat(count!);
    }
    return Row(
      children: [
        if (iconData != null)
          Icon(
            iconData,
            color: Colors.white,
            size: 12,
          ),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child: Text(
            str,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ],
    );
  }

  /// info -- title
  _infoView() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            videoMo.title ?? "没有videoMo.title",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: Colors.black87),
          ),
          _owner()
        ],
      ),
    ));
  }

  /// 作者...
  _owner() {
    var owner = videoMo.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///左边的头像 和 作者
        Row(
          children: [
            //头像
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                owner?.face ?? " ",
                height: 16,
                width: 16,
              ),
            ),
            // 作者
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                owner?.name ?? "noName",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ),
          ],
        ),
        //右边的 三个点
        Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        )
      ],
    );
  }

  ///
}
