import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/cancel_favorite_request.dart';
import 'package:bili/http/request/favorite_request.dart';
import 'package:bili/util/my_log.dart';

class FavoriteDao {
  static Future favorite(
      {required String vid, required bool isFavorite}) async {
    /// 如果已经是收藏的, 那么取消收藏
    var request = isFavorite ? CancelFavoriteRequest() : FavoriteRequeat();
    request.pathParams = vid;
    var response = await HiNet.getInstance().fire(request);
    myLog("收藏 ==> ${response} ", StackTrace.current);
    return response;
  }
}
