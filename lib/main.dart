import 'package:bili/db/hi_cache.dart';
import 'package:bili/http/dao/login_dao.dart';

import 'package:bili/model/home_model.dart';

import 'package:bili/navigator/bottom_navigator.dart';
import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/page/login_page.dart';
import 'package:bili/page/registration_page.dart';
import 'package:bili/page/video_detail_page.dart';
import 'package:bili/util/my_log.dart';
import 'package:bili/util/toast.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HiCache.preInit(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var widget2;
        if (snapshot.connectionState == ConnectionState.done) {
          widget2 = Router(
            routerDelegate: _routeDelegate,
          );
        } else {
          widget2 = Scaffold(body: CupertinoActivityIndicator());
        }
        return MaterialApp(
          title: "flutter demo",
          theme: ThemeData(primarySwatch: themeColorWhite),
          // primaryColor的值是一个Color类型的，为所有的Widget 提供基础颜色；
// primarySwatch的值是一个MaterialColor类型，而不是Color类型的，主要为Material 系列组件提供基础色
          debugShowCheckedModeBanner: false,
          home: widget2,
        );
      },
    );
  }
}

/// bilibili 路由delegate
class BiliRouteDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  //
  late Map pageMapArgs;
  // 初始化方法
  BiliRouteDelegate() {
// 实现路由跳转逻辑
//  注册路由跳转监听
    HiNavigator.getInstance().registerRouteJump(
      RouteJumpListener(
        onJumpTo: (RouteStatus routeStatus, {Map? args}) {
          _routeStatus = routeStatus;
          if (args != null) {
            this.pageMapArgs = args;
          }

          // if (routeStatus == RouteStatus.detail) {
          //   this.videoModel = args?['videlmo'];
          // }
          myLog("马上要执行notifyListeners", StackTrace.current);
          notifyListeners();
        },
      ),
    );
  }

  // 存放所有页面
  List<MaterialPage> pages = [];
  RouteStatus _routeStatus = RouteStatus.home; //默认为首页
  VideoModel? videoModel;

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  //*  ------------------------------ */
  //*   方法
  @override
  Widget build(BuildContext context) {
    myLog("RouterDelegate -- build 方法", StackTrace.current);
    // 构建路由栈 : page中装的是一个完整的页面
    var index = getPageIndex(pages, routeStatus);
    // 临时的pages
    var tempPages = pages;
    if (index != -1) {
      // 说明栈中已经有了该页面
      // 把本页面 和 以上的页面都 出栈
      // pop 不走这个方法,会直接出栈一个页面
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      tempPages.clear(); //清理干净
      // page = pageWrap(HomePage());
      page = pageWrap(BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(argumentsMap: this.pageMapArgs));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }
    //
    tempPages = [...tempPages, page];
    // 通知路由发生变化
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;
    //
    // 创建Navigator 作为路由的管理者
    return WillPopScope(
      //fix Android物理返回键，无法返回上一页问题@https://github.com/flutter/flutter/issues/66349
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        // 当路由被pop时, onPopPage会被调用
        onPopPage: (Route<dynamic> route, dynamic result) {
          myLog("Navigator 的 onPopPage", StackTrace.current);
          if ((route.settings as MaterialPage).child is LoginPage) {
            if (!hasLogin) {
              showWarnToast("请先登录");
              return false;
            }
          }
          //在这里控制是否可以返回
          if (!route.didPop(result)) {
            return false;
          }
          myLog("pages.removeLast()", StackTrace.current);
          var tempPages = [...pages];
          pages.removeLast();
          HiNavigator.getInstance().notify(pages, tempPages);
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    myLog("setNewRoutePath 应该是永远永不到了吧....", StackTrace.current);
  }
}

///定义路由数据 path
// class BiliRoutePath {
//   final String? location;
//   BiliRoutePath.home() : location = "/";
//   BiliRoutePath.detail() : location = "/detail";
// }

// // 创建页面
// pageWrap(Widget child) {
//   myLog("pageWrap", StackTrace.current);
//   return MaterialPage(
//     child: child,
//     key: ValueKey(child.hashCode),
//   );
// }
