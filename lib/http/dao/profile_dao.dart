import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/profile_request.dart';
import 'package:bili/model/profile_model.dart';
import 'package:bili/util/my_log.dart';

class ProfileDao {
  static Future fetch() async {
    ProfileRequest request = ProfileRequest();
    var response = await HiNet.getInstance().fire(request);
    ProfileModel profilemodel = ProfileModel.fromJson(response["data"]);
    // myLog("response ==> ${response}", StackTrace.current);
    return profilemodel;
  }
}
