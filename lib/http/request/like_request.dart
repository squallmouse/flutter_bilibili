import 'package:bili/http/request/base_request.dart';

class LikeRequest extends BaseRequest {
  @override
  HttpMethod get httpMethod => HttpMethod.POST;

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "/uapi/fa/like/";
  }
}
