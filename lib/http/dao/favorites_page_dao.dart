import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/favorites_request.dart';
import 'package:bili/model/favorite_model.dart';
import 'package:bili/util/my_log.dart';

class FavoPageDao {
  static Future<FavoriteModel> fetch(
      {int pageIndex = 1, int pageSize = 10}) async {
    FavoPageRequest request = FavoPageRequest();
    request.add("pageIndex", pageIndex);
    request.add("pageSize", pageSize);
    var response = await HiNet.getInstance().fire(request);
    FavoriteModel mo = FavoriteModel.fromJson(response["data"]);
    myLog("FavoPageDao ==> ${mo.toJson()}", StackTrace.current);
    return mo;
  }
}
