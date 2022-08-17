import 'package:bili/model/barrage_model.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

/// 负责与后端进行 websocket 通信
class HiSocket implements ISocket {
  //*  ------------------------------ */
  //*  参数
  late Map<String, dynamic> headers;
  static const _URL = 'wss://api.devio.org/uapi/fa/barrage/';
  IOWebSocketChannel? _channel;
  ValueChanged<List<BarrageModel>>? _callBack;

  /// 心跳秒数,根据服务器时间timeOut时间来调整,这里nignx服务器的timeout为60
  int _intervalSecond = 55;

  HiSocket(this.headers);
  //*  ------------------------------ */
  //*  methods
  @override
  void close() {
    if (_channel != null) {
      _channel!.sink.close();
    }
  }

  @override
  ISocket listen(ValueChanged<List<BarrageModel>> callBack) {
    _callBack = callBack;
    return this;
  }

  @override
  ISocket open(String vid) {
    _channel = IOWebSocketChannel.connect(
      _URL + vid,
      headers: headers,
      pingInterval: Duration(seconds: _intervalSecond), // 心跳包 50s
    );

    _channel?.stream.handleError((error) {
      myLog("连接发生错误==> ${error}", StackTrace.current);
    }).listen((message) {
      _handlerMessage(message);
    });
    return this;
  }

  @override
  ISocket send(String message) {
    _channel?.sink.add(message);
    return this;
  }

  void _handlerMessage(message) {
    myLog("receiver ==>> $message", StackTrace.current);
    var result = BarrageModel.fromJsonString(message);
    if (_callBack != null) {
      _callBack!(result);
    }
  }
}

abstract class ISocket {
  /// 和服务器建立连接
  ISocket open(String vid);

  /// 发送弹幕
  ISocket send(String message);

  /// 关闭连接
  void close();

  /// 接受弹幕
  ISocket listen(ValueChanged<List<BarrageModel>> callBack);
}
