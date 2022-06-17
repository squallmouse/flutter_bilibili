import 'package:bili/model/video_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // late final ValueChanged<VideoModel> onJumpToDetail;
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text("首页"),
            MaterialButton(
              onPressed: () => HiNavigator.getInstance().onJumpTo(
                RouteStatus.detail,
                args: {"videoModel": VideoModel(111)},
              ),
              // widget.onJumpToDetail(VideoModel(111)),
              child: Text("详情"),
            ),
          ],
        ),
      ),
    );
  }
}
