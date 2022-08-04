import 'package:bili/http/request/base_request.dart';

class ProfileRequest extends BaseRequest {
  @override
  // TODO: implement httpMethod
  HttpMethod get httpMethod => HttpMethod.GET;

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "uapi/fa/profile";
  }
}
