import 'package:bili/http/request/base_request.dart';

class HomeRequest extends BaseRequest {
  @override
  HttpMethod get httpMethod => HttpMethod.GET;

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "/uapi/fa/home/";
  }
}
