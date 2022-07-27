import 'package:bili/http/request/base_request.dart';
import 'package:bili/http/request/favorite_request.dart';

class CancelFavoriteRequest extends FavoriteRequeat {
  @override
  HttpMethod get httpMethod => HttpMethod.DELETE;
}
