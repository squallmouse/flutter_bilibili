import 'package:bili/util/color.dart';
import 'package:flutter/material.dart';

/// 弹幕输入界面
class BarrageInput extends StatelessWidget {
  /// 关闭事件
  final VoidCallback onTabClose;
  const BarrageInput({Key? key, required this.onTabClose}) : super(key: key);

  /// 发送消息

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          /// 空白区域点击关闭弹框
          Expanded(
            child: GestureDetector(
              onTap: () {
                onTabClose();
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),

          /// safearea,
          /// 安全区域, 键盘弹出来的时候;  安全区域就是键盘区域之上
          SafeArea(
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(width: 15),
                  _buildInput(editingController, context),
                  _buildSendBtn(editingController, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 输入框
  _buildInput(TextEditingController editingController, BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          autofocus: true,
          controller: editingController,
          onSubmitted: (value) {
            _send(value, context);
          },
          cursorColor: primary,
          decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
              hintText: "发个友善弹幕见证当下..."),
        ),
      ),
    );
  }

  void _send(String text, BuildContext context) {
    if (text.isNotEmpty) {
      onTabClose();
      Navigator.pop(context, text);
    }
  }

  _buildSendBtn(TextEditingController editingController, BuildContext context) {
    return InkWell(
      onTap: () {
        var text = editingController.text.trim();
        _send(text, context);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.send_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }
}
