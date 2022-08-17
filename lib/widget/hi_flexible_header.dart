import 'dart:ffi';

import 'package:bili/util/image_cached.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

/// 可动态改变位置的Header组件
class HiFlexibleHeader extends StatefulWidget {
  final String face; // 头像
  final String name; // 名字
  final ScrollController scrollController; // 控制器
  /// 构造器
  HiFlexibleHeader({
    Key? key,
    required this.face,
    required this.name,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<HiFlexibleHeader> createState() => _HiFlexibleHeaderState();
}

class _HiFlexibleHeaderState extends State<HiFlexibleHeader> {
  static const double MAX_BOTTOM = 40;
  static const double MIN_BOTTOM = 10;

  /// 滚动范围
  static const double MAX_OFFSET = 80;
  double _dyBottom = MAX_BOTTOM;

  /// init
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      double offset = widget.scrollController.offset;
      myLog("offset ==> ${offset}", StackTrace.current);

      /// 算出padding变化系数0~1
      var dyOffset = (MAX_OFFSET - offset) / MAX_OFFSET;

      // 根据dyOffset算出具体的变化的padding值
      var dy = dyOffset * (MAX_BOTTOM - MIN_BOTTOM);
      // 临界值保护
      if (dy > (MAX_BOTTOM - MIN_BOTTOM)) {
        dy = MAX_BOTTOM - MIN_BOTTOM;
      } else if (dy < 0) {
        dy = 0;
      }
      setState(() {
        // 算出实际的padding.
        _dyBottom = MIN_BOTTOM + dy;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: _dyBottom, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: ImageCachedUtils(
              widget.face,
              iwidth: 46,
              iheight: 46,
            ),
          ),
          SizedBox(width: 12),
          Text(
            widget.name,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
