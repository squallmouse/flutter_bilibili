import 'package:bili/core/hi_refersh_page.dart';
import 'package:bili/http/dao/ranking_dao.dart';
import 'package:bili/model/home_model.dart';
import 'package:bili/model/ranking_model.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/widget/video_list_card.dart';
import 'package:flutter/material.dart';

class RefershPage extends StatefulWidget {
  Map? dict;
  RefershPage({Key? key, this.dict}) : super(key: key);

  @override
  State<RefershPage> createState() => _RefershPageState();
}

class _RefershPageState
    extends HiRefershPage<RankingModel, VideoModel, RefershPage> {
  @override
  Widget buildPageChild() {
    // return Text("data");
    return ListView.builder(
      itemCount: dataArr.length,
      controller: scController,
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
    String type = widget.dict!["type"];
    if (loadMore) {
      pageIndex += 1;
    } else {
      pageIndex = 1;
    }
    myLog("pageindex ==>> ${pageIndex} ", StackTrace.current);
    RankingModel rkMo =
        await RankingDao.fetch(type: type, pageIndex: pageIndex);
    List<VideoModel> tempArr = rkMo.list ?? [];
    myLog("tempArr ==> ${tempArr[0]}", StackTrace.current);
    setState(() {
      myLog("setState", StackTrace.current);
      if (loadMore) {
        dataArr.addAll(tempArr);
      } else {
        dataArr = tempArr;
      }
      isLoading = false;
    });
  }
}
