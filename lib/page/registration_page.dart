import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/widget/appbar.dart';
import 'package:bili/widget/login_button.dart';
import 'package:bili/widget/login_effect.dart';
import 'package:bili/widget/login_input.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  // final VoidCallback onJumpToLogin;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String imoocId = "";
  bool loginEnable = false; // 注册按钮是否能点击
  String orderId = "";
  String password = "";
  bool protect = false; // 图片是否挡着眼睛
  String rePassword = "";
  String userName = "";

  _checkInput() {
    bool enable;

    if (userName.isNotEmpty &&
        password.isNotEmpty &&
        rePassword.isNotEmpty &&
        imoocId.isNotEmpty &&
        orderId.isNotEmpty) {
      enable = true;
    } else {
      enable = false;
    }

    setState(() {
      loginEnable = enable;
    });
  }

  // _send 发送登陆的请求 假请求 ;只要两次密码相等 就直接通过
  void _send() {
    Future.delayed(Duration(seconds: 2), () {
      print("假请求  发送");
    }).then((value) {
      print("假请求  直接成功!!!! -- 重新登陆下");
      HiNavigator.getInstance().onJumpTo(RouteStatus.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar("注册", "登陆",
          rightButtonClick: () =>
              HiNavigator.getInstance().onJumpTo(RouteStatus.login)),
      body: Container(
        child: ListView(
          children: [
            // 图片
            LoginEffect(protect: protect),
            // 用户名
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (String value) {
                userName = value;
                _checkInput();
              },
            ),
            // 密码
            LoginInput(
              title: "密码",
              hint: "请输入密码",
              obscureText: true,
              onChanged: (value) {
                password = value;
                _checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus; // 当前是焦点的时候,图片捂着眼睛
                });
              },
            ),
            // 确认密码
            LoginInput(
              title: "确认密码",
              hint: "请再次输入密码",
              obscureText: true,
              lineStretch: true,
              onChanged: (value) {
                rePassword = value;
                _checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus; // 当前是焦点的时候,图片捂着眼睛
                });
              },
            ),
            // mukeid
            LoginInput(
              title: "慕课网id",
              hint: "请输入你的慕课网用户id",
              onChanged: (value) {
                imoocId = value;
                _checkInput();
              },
            ),
            // 订单号
            LoginInput(
              title: "订单号",
              hint: "请输入你的慕课网订单号后四位",
              onChanged: (value) {
                orderId = value;
                _checkInput();
              },
            ),
            // 注册按钮
            LoginButton(
              "注册",
              loginEnable,
              onClick: () {
                // print("注册按钮点击");
                _send();
              },
            ),
          ],
        ),
      ),
    );
  }
}
