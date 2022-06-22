import 'dart:ffi';

import 'package:bili/http/core/hi_net.dart';

import 'package:bili/http/request/home_request.dart';
import 'package:bili/model/home_model.dart';

class HomeDao {
  static Future<HomeModel> get(
      {required String categoryName,
      int pageIndex = 1,
      int pageSize = 10}) async {
    var homeRequest = HomeRequest();
    homeRequest.pathParams = categoryName;
    homeRequest.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(homeRequest);
    HomeModel model = HomeModel.fromJson(result["data"]);
    return model;
  }
}
