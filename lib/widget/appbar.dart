import 'dart:ui';
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
