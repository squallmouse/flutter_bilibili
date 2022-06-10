import 'base_request.dart';

class TestRequest extends BaseRequest {
  @override
  HttpMethod get httpMethod => HttpMethod.GET;

  @override
  String path() {
    return "uapi/test/test";
  }

  @override
  bool needLogin() {
    return false;
  }
}
