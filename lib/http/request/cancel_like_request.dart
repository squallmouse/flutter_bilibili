import 'package:bili/http/request/base_request.dart';
import 'package:bili/http/request/like_request.dart';

class CancelLikeRequest extends LikeRequest {
  @override
  HttpMethod get httpMethod => HttpMethod.DELETE;
}
