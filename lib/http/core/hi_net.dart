import 'package:bili/http/requst/base_request.dart';

class HiNet {
  HiNet._();
  static HiNet? _instance;
  // 获取单例
  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance!;
  }

  //  发送请求
  Future fire(BaseRequest request) async {
    var response = await send(request);
    var result = response["data"];
    printLog(response["statueCode"]);
    return result;
  }

  // send 请求
  Future<dynamic> send<T>(BaseRequest request) async {
    printLog("url:${request.url()}");
    printLog("method:${request.httpMethod}");
    request.addHeader("token", "123");
    printLog("header:${request.header}");
    return Future.value({
      "statueCode": 200,
      "data": {"code": 0, "message": "success"},
    });
  }

  // 打印
  void printLog(log) {
    print("hi_net -->  ${log.toString()}");
  }
}
