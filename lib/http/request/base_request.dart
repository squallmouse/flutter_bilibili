import 'package:bili/http/dao/login_dao.dart';

enum HttpMethod { GET, POST, DELETE }

const MAINURL = "api.devio.org";

// 请求的基类
abstract class BaseRequest {
  // curl -X GET "http://api.devio.org/uapi/test/test?requestPrams=11" -H "accept: */*"

  var pathParams; // 路径
  var useHttps = true; // 是否使用https
  Map<String, String> params = Map(); //参数
  // Map<String, dynamic> header = Map(); // 请求头参数

  Map<String, dynamic> header = {
    'course-flag': 'fa',
    //访问令牌，在课程公告获取
    "auth-token": "ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa",
  };

  // 获取主域名
  String get authority {
    return MAINURL;
  }

  /// 获取请求方法
  HttpMethod get httpMethod;

  /// 获取路径
  String path();

  /// 获取请求的url
  String url() {
    Uri uri;
    var pathStr = path();
    //拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}${pathParams}";
      } else {
        pathStr = "${path()}/${pathParams}";
      }
    }
    // http 和 https切换
    if (useHttps) {
      uri = Uri.https(authority, pathStr, params);
    } else {
      uri = Uri.http(authority, pathStr, params);
    }
    // 添加token到请求头
    if (needLogin()) {
      print("--> 添加了login token 到请求头 <--");
      this.addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    // 打印请求的url
    print("请求的 url = -->  ${uri.toString()}  <--");
    return uri.toString();
  }

  /// 添加参数
  BaseRequest add(String key, Object value) {
    params[key] = value.toString();
    // params[key] = value;
    return this; // 返回this.方便用.语法
  }

  /// 添加请求头参数
  BaseRequest addHeader(String key, Object value) {
    header[key] = value.toString();
    return this; // 返回this.方便用.语法
  }

  bool needLogin();
}
