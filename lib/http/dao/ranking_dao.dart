import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/ranking_request.dart';
import 'package:bili/model/ranking_model.dart';
import 'package:bili/util/my_log.dart';

class RankingDao {
  static Future fetch(
      {required String type, int pageIndex = 1, int pageSize = 10}) async {
    var request = RankingRequest();
    request.add("sort", type);
    request.add("pageIndex", pageIndex);
    request.add("pageSize", pageSize);
    var response = await HiNet.getInstance().fire(request);
    myLog("RankingDao ===>>> ${response["data"]}", StackTrace.current);
    RankingModel model = RankingModel.fromJson(response["data"]);
    return model;
  }
}
