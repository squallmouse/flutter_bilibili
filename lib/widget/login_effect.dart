import 'package:flutter/material.dart';

class LoginEffect extends StatefulWidget {
  final bool protect;
  const LoginEffect({Key? key, required this.protect}) : super(key: key);

  @override
  State<LoginEffect> createState() => _LoginEffectState();
}

class _LoginEffectState extends State<LoginEffect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _setImage(true),
          Image(
            width: 90,
            height: 90,
            image: AssetImage('images/logo.png'),
          ),
          _setImage(false),
        ],
      ),
    );
  }

  _setImage(bool left) {
    var headLeft = widget.protect
        ? "images/head_left_protect.png"
        : "images/head_left.png";

    var headRight = widget.protect
        ? "images/head_right_protect.png"
        : "images/head_right.png";

    return Image.asset(
      left ? headLeft : headRight,
      width: 90,
      height: 90,
    );
  }
}
