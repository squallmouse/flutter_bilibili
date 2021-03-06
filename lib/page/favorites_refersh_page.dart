import 'package:bili/core/hi_refersh_page.dart';
import 'package:bili/http/dao/favorites_page_dao.dart';
import 'package:bili/model/favorite_model.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/page/favorite_page.dart';
import 'package:bili/page/video_detail_page.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/widget/video_list_card.dart';
import 'package:flutter/material.dart';

class FavoritesRefershPage extends StatefulWidget {
  FavoritesRefershPage({Key? key}) : super(key: key);

  @override
  State<FavoritesRefershPage> createState() => _FavoritesRefershPageState();
}

class _FavoritesRefershPageState
    extends HiRefershPage<FavoriteModel, VideoModel, FavoritesRefershPage> {
  late RouteChangeListener listener;
  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      if (pre?.page is VideoDetailPage && current.page is FavoritePage) {
        loadData();
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    super.dispose();
  }

  @override
  Widget buildPageChild() {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      controller: scController,
      itemCount: dataArr.length,
      itemBuilder: (context, index) {
        VideoModel mo = dataArr[index];
        return VideoDetailCard(videoModel: mo);
      },
    );
  }

  @override
  Future<void> loadData({bool loadMore = false}) async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    if (loadMore) {
      pageIndex += 1;
    } else {
      pageIndex = 1;
    }
    var mo = await FavoPageDao.fetch(pageIndex: pageIndex);
    List<VideoModel> tempList = mo.list ?? [];
    setState(() {
      myLog("setState", StackTrace.current);
      if (loadMore) {
        dataArr.addAll(tempList);
      } else {
        dataArr = tempList;
      }
      isLoading = false;
    });
  }
}
