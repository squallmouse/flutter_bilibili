import 'package:bili/model/home_model.dart';
import 'package:bili/navigator/bottom_navigator.dart';
import 'package:bili/page/dark_mode_page.dart';
import 'package:bili/page/home_page.dart';
import 'package:bili/page/login_page.dart';
import 'package:bili/page/registration_page.dart';
import 'package:bili/page/video_detail_page.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

// 监听当前页面,和上次的页面
typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo? pre);

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
  darkMode,
  unknow,
}

/// 获取page对应的路由状态 -->
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else if (page.child is DarkModePage) {
    return RouteStatus.darkMode;
  } else {
    return RouteStatus.unknow;
  }
}

/// 路由信息 ,
/// routeStatus : 路由的状态,指向哪一个页面
/// page : 具体页面的widget
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
  List<RouteChangeListener> _listeners = [];
  RouteStatusInfo? _current;
  RouteStatusInfo? _bottomTab;
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

  RouteStatusInfo? getCurrent() {
    return _current;
  }

  //*  ------------------------------ */
  //*  方法
  ///首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(routeStatus: RouteStatus.home, page: page);
    _notify(_bottomTab!);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJumpListener.onJumpTo(routeStatus, args: args);
  }

  /// 注册 _routeJumpListener
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJumpListener = routeJumpListener;
  }

  ///添加监听
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// 移除监听
  void removeListener(RouteChangeListener listener) {
    if (_listeners.contains(listener)) {
      _listeners.remove(listener);
    }
  }

  /// 通知路由页面变化
  /// $0 : 新的页面堆栈信息
  /// $1 : 老的页面堆栈信息
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    //如果没有发生变化就直接返回
    if (currentPages == prePages) return;
    // 如果发生了变化 , 获取新的路由信息
    var current = RouteStatusInfo(
        routeStatus: getStatus(currentPages.last),
        page: currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    if (current.page is BottomNavigator && _bottomTab != null) {
      current = _bottomTab!;
    }

    myLog("hi_navigator-->current --> 这次打开的页面:${current.page}",
        StackTrace.current);
// _current 上一次打开的页面
    myLog("hi_navigator-->pre --> 上一次打开的页面:${_current?.page}",
        StackTrace.current);

    _listeners.forEach((listener) {
      // 通知_listener列表中所有的监听方法 新老页面
      listener(current, _current);
    });
    _current = current;
  }
}
