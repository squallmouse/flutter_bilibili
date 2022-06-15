import 'package:bili/db/hi_cache.dart';
import 'package:bili/http/core/dio_adapter.dart';
import 'package:bili/http/core/hi_net.dart';
import 'package:bili/http/dao/login_dao.dart';
import 'package:bili/http/dao/notice_dao.dart';
import 'package:bili/http/request/test_request.dart';
import 'package:bili/model/video_model.dart';
import 'package:bili/page/home_page.dart';
import 'package:bili/page/login_page.dart';
import 'package:bili/page/registration_page.dart';
import 'package:bili/page/video_detail_page.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';
import 'package:bili/util/color.dart';

void main() {
  runApp(BiliApp());
}

class BiliApp extends StatefulWidget {
  BiliApp({Key? key}) : super(key: key);

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  BiliRouteInformationParser _routeInformationParser =
      BiliRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    var widget2 = Router(
      routerDelegate: _routeDelegate,
      routeInformationParser: _routeInformationParser,
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation: RouteInformation(location: "/"),
      ),
    );
    print("widget2 = ${widget2}");
    return MaterialApp(
      title: "flutter demo",
      theme: ThemeData(primaryColor: themeColorWhite),
      debugShowCheckedModeBanner: false,
      home: widget2,
    );
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  //定义一个key,可以通过navigatorkey.currentState来获取navigatorState对象
  // final GlobalKey<NavigatorState>? navigatorKey;
  // // // 初始化
  // BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  // @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // 存放所有页面
  List<MaterialPage> pages = [];
  VideoModel? videoModel;
  BiliRoutePath? path;
  //*  ------------------------------ */
  //*   方法
  @override
  Widget build(BuildContext context) {
    myLog("build 方法", StackTrace.current);
    // 构建路由栈
    pages = [
      pageWrap(HomePage(
        onJumpToDetail: (model) {
          this.videoModel = model;

          notifyListeners(); //通知数据变化
          myLog("通知数据变化", StackTrace.current);
        },
      )),
      if (this.videoModel != null)
        pageWrap(VideoDetailPage(
          videoModel: this.videoModel!,
        ))
    ];
    // 创建Navigator 作为路由的管理者
    return Navigator(
      key: navigatorKey,
      pages: pages,
      // 当路由被pop时, onPopPage会被调用
      onPopPage: (Route<dynamic> route, dynamic result) {
        //在这里控制是否可以返回
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  // @override
  // // TODO: implement navigatorKey
  // GlobalKey<NavigatorState>? get navigatorKey => throw UnimplementedError();

  @override
  Future<void> setNewRoutePath(BiliRoutePath configuration) async {
    myLog("setNewRoutePath 方法  ${configuration}", StackTrace.current);
    this.path = configuration;
  }
}

///定义路由数据 path
class BiliRoutePath {
  final String? location;
  BiliRoutePath.home() : location = "/";
  BiliRoutePath.detail() : location = "/detail";
}

/// 可缺省,主要用于 web
class BiliRouteInformationParser extends RouteInformationParser<BiliRoutePath> {
  @override
  Future<BiliRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    print("uri:${uri}");
    //判断长度 // 根据长度来返回页面
    if (uri.pathSegments.length == 0) {
      return BiliRoutePath.home();
    }
    return BiliRoutePath.detail();
  }
}

// 创建页面
pageWrap(Widget child) {
  myLog("pageWrap", StackTrace.current);
  return MaterialPage(
    child: child,
    key: ValueKey(child.hashCode),
  );
}
