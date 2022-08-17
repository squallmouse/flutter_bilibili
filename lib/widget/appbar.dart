import 'package:bili/util/view_utils.dart';
import 'package:flutter/material.dart';

appbar(String leftTitle, String rightTitle,
    {required VoidCallback rightButtonClick}) {
  return AppBar(
    centerTitle: false, //
    titleSpacing: 0,
    leading: BackButton(),
    title: Text(
      leftTitle,
      style: TextStyle(fontSize: 18),
    ),
    // 右边button
    actions: [
      InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            rightTitle,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}

/// 视频详情页appBar
videoAppBar() {
  return Container(
    padding: EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      gradient: blackLinearGradient(fromTop: true),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackButton(
          color: Colors.white,
        ),
        Row(
          children: [
            Icon(Icons.live_tv_rounded, color: Colors.white),
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.more_vert_rounded, color: Colors.white)),
          ],
        )
      ],
    ),
  );
}
