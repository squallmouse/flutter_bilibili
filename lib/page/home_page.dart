import 'package:bili/model/video_model.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // late final ValueChanged<VideoModel> onJumpToDetail;
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RouteChangeListener listener;
  //*  ------------------------------ */
  //*  method
  @override
  void dispose() {
    myLog("homePage-->dispose", StackTrace.current);
    HiNavigator.getInstance().removeListener(this.listener);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      myLog("homePage-->current:${current.page}", StackTrace.current);
      myLog("homePage-->pre:${pre?.page}", StackTrace.current);
      if (widget == current.page || current.page is HomePage) {
        myLog("打开了首页:onResume", StackTrace.current);
      } else if (widget == pre?.page || pre?.page is HomePage) {
        myLog("首页:onPause", StackTrace.current);
      }
    });
  }

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
