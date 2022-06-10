import 'dart:convert';

import 'package:bili/http/requst/base_request.dart';

/// 网络请求抽象类
abstract class HiNetAdapter {
  Future<HiNetResponse> send(BaseRequest request);
}

/// 统一网络层返回格式
class HiNetResponse<T> {
  final T data;
  final BaseRequest? request;
  final int statusCode;
  final dynamic extra; //额外数据

  HiNetResponse(
      {required this.data, required this.statusCode, this.request, this.extra});

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
