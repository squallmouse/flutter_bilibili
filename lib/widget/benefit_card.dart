import 'package:bili/model/profile_model.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/toast.dart';
import 'package:bili/util/url_launcher.dart';
import 'package:bili/widget/hi_blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BenefitCard extends StatelessWidget {
  final List<BenefitModel> benefitList;
  const BenefitCard({Key? key, required this.benefitList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 5),
      child: Column(
        children: [
          /// 标题
          _buildTitle(),
          // 增值服务 => 内容
          _buildBenefit(context),
        ],
      ),
    );
  }

  /// 一行的标题
  _buildTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Text(
            "增值服务",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(
            "购买后登录慕课网再次点击打开查看",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  _buildBenefit(BuildContext context) {
    // 宽度
    var width = (MediaQuery.of(context).size.width -
            20 -
            (benefitList.length - 1) * 5) /
        benefitList.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...benefitList.map((mo) => _buildCard(mo, width, 60)).toList(),
      ],
    );
  }

  _buildCard(BenefitModel mo, double width, double height) {
    return InkWell(
      onTap: () {
        myLog("调换到H5", StackTrace.current);
        if (mo.url!.startsWith("http")) {
          urlLauncher_util(mo.url);
        } else {
          Clipboard.setData(ClipboardData(text: mo.url)).then((value) {
            showToast("${mo.url} --> 已经复制到剪切板");
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 5, 7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.orange,
                  ),
                ),
                Positioned.fill(
                  child: HiBlur(
                    sigma: 10,
                  ),
                ),
                Center(
                  child: Text(
                    "${mo.name}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
