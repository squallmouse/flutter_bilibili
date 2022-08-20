import 'package:bili/model/barrage_model.dart';
import 'package:flutter/material.dart';

class BarrageViewUtil {
  static barrageView(BarrageModel model) {
    switch (model.type) {
      case 1:
        return _barrageType1(model);
      default:
    }
    return Text(
      model.content,
      style: TextStyle(color: Colors.white),
    );
  }

  /// 类型1的样式
  static _barrageType1(BarrageModel model) {
    return Center(
      child: Container(
        child: Text(
          model.content,
          style: TextStyle(color: Colors.deepOrange),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
