import 'package:bili/http/dao/login_dao.dart';
import 'package:bili/util/toast.dart';
import 'package:bili/widget/appbar.dart';
import 'package:bili/widget/login_button.dart';
import 'package:bili/widget/login_effect.dart';
import 'package:bili/widget/login_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onJumpToRegistrationPage;
  LoginPage({Key? key, required this.onJumpToRegistrationPage})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false; // 密码保护动画
  bool loginEnable = false; // 登陆按钮可用
  String userName = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appbar("登陆", "注册", rightButtonClick: widget.onJumpToRegistrationPage),
      body: Container(
        child: ListView(
          children: [
            // 图片
            LoginEffect(protect: protect),
            // 用户名
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (value) {
                userName = value;
                _checkInput();
              },
            ),
            //密码
            LoginInput(
              title: "密码",
              hint: "请输入密码",
              obscureText: true,
              onChanged: (value) {
                password = value;
                _checkInput();
              },
              focusChanged: (value) {
                setState(() {
                  protect = value;
                });
              },
            ),
            // 登陆按钮
            LoginButton(
              "登陆",
              loginEnable,
              onClick: () {
                print("登陆按钮 -- click!!!");
                _send(userName, password);
              },
            ),
          ],
        ),
      ),
    );
  }

// 检查
  void _checkInput() {
    bool enable;
    if (userName.isNotEmpty && password.isNotEmpty) {
      enable = true;
    } else {
      enable = false;
    }

    setState(() {
      loginEnable = enable;
    });
  }

  // 发送请求
  void _send(String userName, String password) async {
    print("userName : $userName  -- password : ${password}");

    // //固定的测试登陆账号

    var res = await LoginDao.login("18404969231", "wkl123456");
    print("登陆 --> $res");
    if (res["code"] == 0) {
      print("-------  登陆  ------");
      print(res["msg"]);
      print("data --> ${res["data"]}");
      print("-------  end   ------");
      showToast(res["msg"]);
    }
  }
}
