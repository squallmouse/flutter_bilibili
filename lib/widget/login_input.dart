import 'package:bili/util/color.dart';
import 'package:flutter/material.dart';

class LoginInput extends StatefulWidget {
  final String title; //输入框 左边标题
  final String hint; // placehodler
  final ValueChanged<String>? onChanged; // 输入框值改变
  final ValueChanged<bool>? focusChanged; // 是否是当前输入框
  final bool lineStretch; // 输入框下面的短线
  final bool obscureText; //密码
  final TextInputType? keyboardType; // 键盘类型

  LoginInput(
      {Key? key,
      required this.title,
      required this.hint,
      required this.onChanged,
      this.focusChanged,
      this.lineStretch = false,
      this.obscureText = false,
      this.keyboardType})
      : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  //FocusNode : 来捕捉监听TextField的焦点获取与失去
  final _focusNode = FocusNode();

  //*  ------------------------------ */
  //*  func

  @override
  void initState() {
    super.initState();

    // 焦点init
    _focusNode.addListener(() {
      // 打印 信息
      debugPrint(
          "LoginInput -- ${widget.title} : focus --> ${_focusNode.hasFocus}");
      if (widget.focusChanged != null) {
        widget.focusChanged!(_focusNode.hasFocus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // 左边标题
            Container(
              margin: EdgeInsets.only(left: 15),
              width: 100,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 16),
              ),
            ),

            // 输入框
            _input(),
          ],
        ),

        // 底部的横线
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: Divider(
            height: 1,
            thickness: 0.5, // 线的粗细
          ),
        )
      ],
    );
  }

  // Colors.red[50]
  //  输入框
  _input() {
    // Expanded  默认 flex = 1, 铺满
    return Expanded(
      child: TextField(
        focusNode: _focusNode, // 是否是焦点
        onChanged: widget.onChanged,
        obscureText: widget.obscureText, //是否密码框
        keyboardType: widget.keyboardType,
        autofocus: !widget.obscureText, //????啥意思
        cursorColor: primary,
        // 文本类型
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w300,
        ),
        // 输入框的样式
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, right: 20),
          border: InputBorder.none, //无边框
          hintText: widget.hint, //placehodler
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
    );
  }
}
