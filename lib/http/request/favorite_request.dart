import 'package:bili/http/request/base_request.dart';

class FavoriteRequeat extends BaseRequest {
  /// 点赞收藏
  @override
  HttpMethod get httpMethod => HttpMethod.POST;

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "uapi/fa/favorite/";
  }
}
