import 'dart:convert';

import 'package:bili/http/core/hi_error.dart';
import 'package:bili/http/core/hi_net_adapter.dart';
import 'package:bili/http/request/base_request.dart';
import 'package:dio/dio.dart';

class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse> send(BaseRequest request) async {
    var response;
    var options = Options(headers: request.header);
    var error;

    //
    try {
      if (request.httpMethod == HttpMethod.GET) {
        //GET
        response = (await Dio().get(request.url(), options: options));
      } else if (request.httpMethod == HttpMethod.POST) {
        //POST
        response = await Dio()
            .post(request.url(), options: options, data: request.params);
      } else if (request.httpMethod == HttpMethod.DELETE) {
        //DELETE
        response = (await Dio()
            .delete(request.url(), options: options, data: request.params));
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }

    if (error != null) {
      //抛出HiNetError
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: _buildRes(response, request));
    }

    return _buildRes(response, request);
  }

  // 创建 HiNetResponse 实例作为返回结果
  _buildRes(Response response, BaseRequest request) {
    return HiNetResponse(
      data: response.data,
      statusCode: response.statusCode ?? -1,
      request: request,
      extra: response,
      statusMessage: response.statusMessage,
    );
  }
}

/// json Map 互相转换
// void test() {
//   const jsonString =
//       "{ \"name\": \"flutter\", \"url\": \"https://coding.imooc.com/class/487.html\" }";
//   //json 转map
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//   print('name:${jsonMap['name']}');
//   print('url:${jsonMap['url']}');
//   //map 转json
//   String json = jsonEncode(jsonMap);
//   print('json:$json');
// }
