import 'package:bili/http/request/base_request.dart';

/// 收藏页面的request
class FavoPageRequest extends BaseRequest {
  @override
  HttpMethod get httpMethod => HttpMethod.GET;

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "/uapi/fa/favorites/";
  }
}
