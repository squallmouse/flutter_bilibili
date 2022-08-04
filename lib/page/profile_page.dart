import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/dao/profile_dao.dart';
import 'package:bili/model/profile_model.dart';
import 'package:bili/util/image_cached.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

///我的
class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileModel? profileModel;
  late ScrollController scrollController;
  //*  ------------------------------ */
  //*
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      var offset = scrollController.offset;
      myLog("offset == > ${offset}", StackTrace.current);
    });
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
            expandedHeight: 160,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: _buildHead(),
          )
        ];
      },
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Text(" ==> ${index}");
          },
          itemCount: 20,
        ),
      ),
    );
  }

  /// 个人页的头
  Widget _buildHead() {
    if (profileModel == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      color: Colors.pink,
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          SizedBox(width: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: ImageCachedUtils(
              profileModel?.face ?? "",
              iwidth: 46,
              iheight: 46,
            ),
          ),
          SizedBox(width: 8),
          Text(
            profileModel?.name ?? "yh_noname",
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
