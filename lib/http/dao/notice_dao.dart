import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/core/hi_net_adapter.dart';
import 'package:bili/http/request/notice_request.dart';

class NoticeDao {
  static Future<dynamic> getNotice(
      {int pageIndex = 1, int pageSize = 10}) async {
    // NoticeRequest? request;
    NoticeRequest request = NoticeRequest();
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
