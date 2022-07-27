import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/video_detail_request.dart';
import 'package:bili/model/video_detail_model.dart';

class VideoDetailDao {
  static Future<VideoDetailModel> get({required String vid}) async {
    var request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    VideoDetailModel mo = VideoDetailModel.fromJson(result["data"]);
    return mo;
  }
}
