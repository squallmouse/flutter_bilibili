import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/core/hi_net_adapter.dart';
import 'package:bili/http/core/mock_adapter.dart';
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
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e);
    } catch (e) {
      //其它异常
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog("response : 为空     |$error");
    }
    var result = response?.data;
    printLog("result --> $result");
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
        break;
      case 401:
        throw NeedLogin();
        break;
      case 403:
        throw NeedAuth(result.toString());
      default:
        throw HiNetError(status!, result.toString());
        break;
    }
  }

  // send 请求
  Future<HiNetResponse> send<T>(BaseRequest request) async {
    MockAdapter adapter = MockAdapter();
    return adapter.send(request);
  }

  // 打印
  void printLog(log) {
    print("hi_net -->  ${log.toString()}");
  }
}
