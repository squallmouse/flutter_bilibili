import 'package:bili/page/home_page.dart';
import 'package:bili/page/login_page.dart';
import 'package:bili/page/registration_page.dart';
import 'package:bili/page/video_detail_page.dart';
import 'package:flutter/material.dart';

/// 创建页面的方法
pageWrap(Widget child) {
  return MaterialPage(
    child: child,
    key: ValueKey(child.hashCode),
  );
}

/// 获取routeStatus 在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 路由的状态
enum RouteStatus {
  login,
  registration,
  home,
  detail,
  unknow,
}

/// 获取page对应的路由状态 -->
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknow;
  }
}

class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo({
    required this.routeStatus,
    required this.page,
  });
}

/// 抽象类
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

///定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;
  RouteJumpListener({required this.onJumpTo});
}

///监听路由页面跳转
///感知当前页面是否压后台
class HiNavigator extends _RouteJumpListener {
  //*  ------------------------------ */
  //*  属性
  late RouteJumpListener _routeJumpListener;
//*  ------------------------------ */
//*  单例
  static HiNavigator? _instance;
  HiNavigator._();
  static HiNavigator getInstance() {
    if (_instance == null) {
      _instance = HiNavigator._();
    }
    return _instance!;
  }

  //*  ------------------------------ */
  //*  方法
  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJumpListener.onJumpTo(routeStatus, args: args);
  }

  // 注册 _routeJumpListener
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJumpListener = routeJumpListener;
  }
}
