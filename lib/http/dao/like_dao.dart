import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/cancel_like_request.dart';
import 'package:bili/http/request/like_request.dart';

class LikeDao {
  static Future like({required String vid, required bool isLike}) {
    var request = isLike ? CancelLikeRequest() : LikeRequest();
    request.pathParams = vid;
    var response = HiNet.getInstance().fire(request);
    return response;
  }
}
