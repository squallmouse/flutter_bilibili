import 'package:bili/util/color.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  String title;
  bool enable;
  VoidCallback? onClick;
  LoginButton(this.title, this.enable, {Key? key, this.onClick})
      : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: MaterialButton(
        onPressed: widget.enable ? widget.onClick : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        height: 45,
        disabledColor: primary[50],
        color: primary,
        child: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
