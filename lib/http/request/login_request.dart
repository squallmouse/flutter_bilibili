import 'package:bili/http/request/base_request.dart';

class LoginRequest extends BaseRequest {
  @override
  // TODO: implement httpMethod
  HttpMethod get httpMethod => HttpMethod.POST;

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return "/uapi/user/login";
  }
}
