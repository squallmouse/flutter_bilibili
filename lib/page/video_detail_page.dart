import 'package:bili/model/video_model.dart';
import 'package:flutter/material.dart';

class VideoDetailPage extends StatefulWidget {
  final Map argumentsMap;
  VideoDetailPage({Key? key, required this.argumentsMap}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late final VideoModel videoModel;
  @override
  Widget build(BuildContext context) {
    videoModel = widget.argumentsMap["videoModel"];

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text("视频详情页, vid:${videoModel.vid}"),
      ),
    );
  }
}
