import 'dart:async';
import 'dart:math';

import 'package:bili/barrage/barrage_item.dart';
import 'package:bili/barrage/barrage_view_util.dart';
import 'package:bili/barrage/hi_socket.dart';
import 'package:bili/barrage/i_barrage.dart';
import 'package:bili/model/barrage_model.dart';
import 'package:bili/util/hi_constants.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

/// 枚举 : 弹幕的状态
enum BarrageStatus { play, pause }

/// 弹幕组件
class HiBarrage extends StatefulWidget {
  final int lineCount;
  final String vid;
  final int speed;
  final double top;
  final bool autoPlay;
  final Map<String, dynamic>? headers;
  //----->
  HiBarrage({
    Key? key,
    this.lineCount = 4,
    required this.vid,
    this.speed = 800,
    this.top = 0,
    this.autoPlay = false,
    this.headers,
  }) : super(key: key);

  @override
  State<HiBarrage> createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  //*  ------------------------------ */
  //*  property
  late HiSocket _hiSocket;
  late double _height;
  late double _width;
  List<BarrageItem> _barrageItemList = []; // 弹幕Widget集合
  List<BarrageModel> _barrageModelList = []; // 弹幕模型
  int _barrageIndex = 0; // 这是第几条弹幕
  Random _random = Random();
  BarrageStatus? _barrageStatus; // 弹幕状态
  Timer? _timer;

  //*  ------------------------------ */
  //*  methods

  @override
  void initState() {
    super.initState();
    _hiSocket = HiSocket(widget.headers ?? HiConstants.headers());
    _hiSocket.open(widget.vid).listen((value) {
      // 监听服务器返回的消息
      _handlerMessage(value);
    });
  }

  @override
  void dispose() {
    _hiSocket.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = _width * 9 / 16;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          // 防止stack的child为空
          Container()
        ]..addAll(_barrageItemList),
      ),
    );
  }

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    // 清空屏幕上的弹幕
    _barrageItemList.clear();
    setState(() {});
    myLog("action:pause", StackTrace.current);
    _timer?.cancel();
  }

  @override
  void play() {
    _barrageStatus = BarrageStatus.play;
    myLog("action:play", StackTrace.current);
    if (_timer != null && (_timer?.isActive ?? false)) {
      return;
    }
    // 每间隔一段时间发送一次弹幕
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        // 将发送的弹幕从集合中剔除
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp); // 添加一条弹幕
        myLog("弹幕发送 ==> ${temp.content}", StackTrace.current);
      } else {
        myLog("所有的弹幕已经发送完毕", StackTrace.current);
        // 所有弹幕发送完毕后关闭定时器
        timer.cancel();
      }
    });
  }

  @override
  void send(String? message) {
    if (message == null) return;
    _hiSocket.send(message);
    _handlerMessage(
        [BarrageModel(content: message, vid: "-1", priority: 1, type: 1)]);
  }

  /// 处理消息, instant = true 马上发送
  void _handlerMessage(List<BarrageModel> modelList, {bool instant = true}) {
    if (instant) {
      _barrageModelList.insertAll(0, modelList);
    } else {
      _barrageModelList.addAll(modelList);
    }

    // 收到新的弹幕后播放
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }

    //收到新的弹幕后播放
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  void addBarrage(BarrageModel model) {
    double perRowHeight = 30;
    var line = _barrageIndex % widget.lineCount;
    _barrageIndex++;
    var top = perRowHeight * line + widget.top;
    // 为每条弹幕生成一个id
    String id = "${_random.nextInt(10000)}:${model.content}";
    var item = BarrageItem(
      id: id,
      top: top,
      child: BarrageViewUtil.barrageView(model),
      onComplete: _onComplete,
    );
    _barrageItemList.add(item);
    setState(() {});
  }

  void _onComplete(id) {
    myLog("弹幕发送完毕===>>> ${id}", StackTrace.current);
    //弹幕播放完毕将其从弹幕widget集合中剔除
    _barrageItemList.removeWhere((element) => element.id == id);
  }
}
