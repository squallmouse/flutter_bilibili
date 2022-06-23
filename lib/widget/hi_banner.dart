import 'package:bili/model/home_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/util/color.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class HiBanner extends StatelessWidget {
  final List<BannerModel> bannerList;
  final double bannerHeight;
  final EdgeInsets padding;

  /// 构造方法..
  const HiBanner(
      {super.key,
      required this.bannerList,
      this.bannerHeight = 160.0,
      required this.padding});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
      height: this.bannerHeight,
      child: _bannerCreate(),
    );
  }

  Swiper _bannerCreate() {
    var _right = (this.padding.horizontal / 2) + 10;
    return Swiper(
      itemCount: this.bannerList.length,
      autoplay: true,
      containerHeight: this.bannerHeight,
      // control: SwiperControl(),
      pagination: SwiperPagination(
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(right: _right, bottom: 10),
        //点点
        builder: DotSwiperPaginationBuilder(
          color: Colors.white,
          activeColor: primary,
          size: 10.0,
          activeSize: 12.0,
        ),
      ),
      //构建banner
      itemBuilder: (context, index) {
        return _imageButton(this.bannerList[index]);
      },
    );
  }

  _imageButton(BannerModel mo) {
    return InkWell(
      onTap: () => _handleClick(mo),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          child: Image.network(
            mo.cover ?? " ",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  _handleClick(BannerModel mo) {
    myLog("_handleClick --> ${mo}", StackTrace.current);
    if (mo.type == "video") {
      print("video");
      HiNavigator.getInstance()
          .onJumpTo(RouteStatus.detail, args: {"mode": mo});
    } else {
      myLog("banner的类型 : ${mo.type}", StackTrace.current);
    }
  }
}
