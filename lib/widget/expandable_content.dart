import 'package:bili/model/home_model.dart';
import 'package:bili/model/video_detail_model.dart';
import 'package:bili/util/view_utils.dart';
import 'package:bili/widget/video_toolbar.dart';
import 'package:flutter/material.dart';

class ExpandableContent extends StatefulWidget {
  final VideoModel model;
  // final VideoDetailModel? videoDetailModel;
  ExpandableContent({
    Key? key,
    required this.model,
    // this.videoDetailModel,
  }) : super(key: key);

  @override
  State<ExpandableContent> createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with TickerProviderStateMixin {
  ///
  bool _show = false;
  int _maxLine = 1;

  /// 动画控制器
  late AnimationController _aniController;

  /// 动画曲线
  late CurvedAnimation _curvedAnimation;

  /// 动画高度
  late Animation _heightFactory;
  late Animation _tempLine;
  //*  ------------------------------ */
  //*  init
  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    );
    _curvedAnimation =
        CurvedAnimation(parent: _aniController, curve: Curves.easeIn);
    _heightFactory = Tween(begin: 0.0, end: 1.0).animate(_curvedAnimation);
    _tempLine = Tween(begin: 1, end: 2).animate(_curvedAnimation);
    _aniController.addListener(() {
      // print("_heightFactory --> ${_heightFactory.value}");
    });
  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }

  //*  ------------------------------ */
  //*  method
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          /// 标题
          ..._titleView(),

          /// padding -- top -- 8
          Padding(padding: EdgeInsets.only(top: 4)),

          /// info
          _buildInfoView(),

          /// 视频详情
          ..._buildDesc(),

          /// 点击+++
          // ..._buildView()
        ],
      ),
    );
  }

  /// 标题 可点击
  _titleView() {
    var _textstyle = TextStyle(color: Colors.black, fontSize: 20);
    return [
      InkWell(
        onTap: _onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 标题
            Expanded(
              child: Text(
                "${widget.model.title}",
                overflow: TextOverflow.ellipsis,
                maxLines: _maxLine,
                style: _textstyle,
              ),
            ),

            /// 右边的按钮
            Padding(
              padding: EdgeInsets.only(right: 5, left: 15),
              child: Icon(
                _show
                    ? Icons.keyboard_arrow_down_sharp
                    : Icons.keyboard_arrow_up_sharp,
                color: Colors.grey,
              ),
            )
          ],
        ),
      )
    ];
  }

  /// 点击事件 激活动画
  void _onTap() {
    print("on tap");
    setState(() {
      _show = !_show;
      if (_show) {
        ///打开
        _maxLine = 10;
        _aniController.forward();
      } else {
        _maxLine = 1;
        _aniController.reverse();
      }
    });
  }

  _buildInfoView() {
    var _textStyle = TextStyle(fontSize: 12, color: Colors.grey);
    String tempStr = widget.model.createTime ?? " ";
    var dateStr = tempStr.length > 10 ? tempStr.substring(5, 10) : tempStr;

    return Row(
      children: [
        ...smallIconAndText(Icons.ondemand_video, widget.model.view),
        Padding(padding: EdgeInsets.only(left: 10)),
        ...smallIconAndText(Icons.list_alt, widget.model.reply),
        Text(
          "         ${dateStr}",
          style: _textStyle,
        )
      ],
    );
  }

  /// 视频详情
  _buildDesc() {
    var _child =
        _show ? Text("${widget.model.desc}", textAlign: TextAlign.left) : null;
    return [
      AnimatedBuilder(
        animation: _aniController,
        child: _child,
        builder: (BuildContext context, Widget? child) {
          return Align(
            heightFactor: _heightFactory.value,
            child: _child,
          );
        },
      )
    ];
  }

  // _buildView() {
  //   return [
  //     VideoToolbar(
  //         videoDetailModel: widget.videoDetailModel ?? VideoDetailModel())
  //   ];
  // }
}
