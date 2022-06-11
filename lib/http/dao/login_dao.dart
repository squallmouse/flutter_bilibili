import 'package:bili/db/hi_cache.dart';
import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/request/base_request.dart';
import 'package:bili/http/request/login_request.dart';
import 'package:bili/http/request/registration_request.dart';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass"; // ???? 不需要
  //  登陆
  static login(String username, String password) {
    return _send(username, password);
  }

  //  注册
  static registration(
      String username, String password, String? imoocId, String? orderId) {
    return _send(username, password, imoocId: imoocId, orderId: orderId);
  }

  //  发送
  static _send(String username, String password,
      {String? imoocId, String? orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();
      request.add("imoocId", imoocId).add("orderId", orderId);
    } else {
      request = LoginRequest();
    }
    request.add("userName", username).add("password", password);

    if (request is RegistrationRequest) {
      // 不注册了 ,直接返回固定的结果
      // 所以 不要调用注册接口
    }
    // request.addHeader(BOARDING_PASS, value);
    var result = await HiNet.getInstance().fire(request);

    if (result["code"] == 0 && result["data"] != null) {
      HiCache.getInstance().setString(BOARDING_PASS, result["data"]);
    }
    // 返回结果
    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }
}
