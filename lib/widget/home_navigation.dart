import 'package:bili/util/toast.dart';
import 'package:flutter/material.dart';

class HomeNavigationWidget extends StatelessWidget {
  final VoidCallback jumpToMy;
  const HomeNavigationWidget({Key? key, required this.jumpToMy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Container(
        // color: Colors.blue,
        child: Row(
          children: [
            // 最左边item
            InkWell(
              onTap: () {
                print("jump to my page");
                jumpToMy();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(23)),
                child: Image.asset("images/avatar.png"),
              ),
            ),

            // 输入框
            Expanded(
              child: Container(
                // color: Colors.grey,
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 32,
                child: TextField(
                  // controller: TextEditingController(),
                  onSubmitted: (value) {
                    showToast("查什么查?假的哟 --> ${value}");
                  },
                  // maxLines: 1,

                  // textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      // label: Text("你想找点啥"),
                      hintText: "你想找点啥?",
                      contentPadding: EdgeInsets.only(top: 15),
                      // hintMaxLines: 1,
                      // hintStyle: TextStyle(fontSize: 22),
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
            ),
            // icon 网页
            InkWell(
              onTap: () {
                showToast("explore_outlined...");
              },
              child: Icon(
                Icons.language,
                color: Colors.grey,
                // color: Color(0x110099ee),
              ),
            ),
            // icon 邮件
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: InkWell(
                onTap: () {
                  showToast("mail_outline...");
                },
                child: Icon(
                  Icons.mail_outline,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
