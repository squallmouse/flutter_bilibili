import 'package:bili/http/core/hi_net_adapter.dart';
import 'package:bili/http/request/base_request.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse> send(BaseRequest request) {
    return Future<HiNetResponse>.delayed(Duration(seconds: 2), () {
      return HiNetResponse(
          data: {"code": 0, "message": 'success'},
          statusCode: 200,
          request: request);
    });
  }
}
// class MockAdapter extends HiNetAdapter {
//   @override
//   Future<HiNetResponse<T>> send<T>(BaseRequest request) {
//     return Future<HiNetResponse<String>>.delayed(Duration(milliseconds: 1000),
//         () {
//       return HiNetResponse(data: "sdfa", statusCode: 403);
//     });
//   }
// }
