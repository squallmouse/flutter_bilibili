import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/dao/profile_dao.dart';
import 'package:bili/model/profile_model.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/widget/benefit_card.dart';
import 'package:bili/widget/course_card.dart';
import 'package:bili/widget/hi_banner.dart';
import 'package:bili/widget/hi_blur.dart';
import 'package:bili/widget/hi_flexible_header.dart';
import 'package:flutter/material.dart';

///我的
class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  //
  ProfileModel? profileModel;
  late ScrollController scrollController;
  //*  ------------------------------ */
  //*
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    // scrollController.addListener(() {
    //   var offset = scrollController.offset;
    //   myLog("offset == > ${offset}", StackTrace.current);
    // });
    _loadData();
  }

  void _loadData() {
    try {
      ProfileDao.fetch().then((mo) {
        setState(() {
          profileModel = mo;
        });
      });
    } on NeedAuth catch (e) {
      myLog("NeedAuth ==> ${e.message} ", StackTrace.current);
    } on HiNetError catch (e) {
      myLog("HiNetError ==> ${e} ", StackTrace.current);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: AppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 160, // 扩展高度
            pinned: true, // 标题栏是否固定
            // 定义固定空间
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              titlePadding: EdgeInsets.only(left: 0),
              title: _buildHead(),
              background: Stack(
                children: [
                  Positioned.fill(
                      child: Image.asset(
                    "images/1.jpg",
                    fit: BoxFit.cover,
                  )),
                  Positioned.fill(
                      child: HiBlur(
                    sigma: 10,
                  )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildProfileTab(),
                  )
                ],
              ),
            ),
          )
        ];
      },
      body: ListView(
        padding: EdgeInsets.only(top: 10),
        children: profileModel == null
            ? []
            : [
                ..._buildContent(),
              ],
      ),
    );
  }

  /// 个人页的头
  Widget _buildHead() {
    if (profileModel == null) {
      return Container();
    }
    return HiFlexibleHeader(
      face: profileModel?.face ?? "",
      name: profileModel?.name ?? "",
      scrollController: scrollController,
    );
  }

  @override
  bool get wantKeepAlive => true;

  /// 头部的tab
  _buildProfileTab() {
    if (profileModel == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(color: Colors.white54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('收藏', profileModel!.favorite!),
          _buildIconText('点赞', profileModel!.like!),
          _buildIconText('浏览', profileModel!.browsing!),
          _buildIconText('金币', profileModel!.coin!),
          _buildIconText('粉丝', profileModel!.fans!),
        ],
      ),
    );
  }

  /// 上数字 下文字
  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 15, color: Colors.black87)),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  /// 页面主体内容

  _buildContent() {
    if (profileModel == null) {
      return [];
    }
    return [
      // banner
      ..._buildBanner(),
      // 课程
      _buildCourseCell(),
      // 增值服务
      _buildBenefitCell(),
    ];
  }

  /// banner 图
  _buildBanner() {
    return [
      HiBanner(
        bannerList: profileModel!.bannerList!,
        bannerHeight: 120,
        padding: EdgeInsets.only(left: 10, right: 10),
      )
    ];
  }

  /// 课程
  _buildCourseCell() {
    return CourseCard(courseList: profileModel!.courseList!);
  }

  _buildBenefitCell() {
    return BenefitCard(benefitList: profileModel!.benefitList!);
  }
}
