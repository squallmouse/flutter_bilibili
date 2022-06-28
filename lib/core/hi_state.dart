import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

abstract class HiState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      myLog("HiState  页面已经销毁了!!!", StackTrace.current);
    }
  }
}
