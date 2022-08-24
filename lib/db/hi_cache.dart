import 'package:shared_preferences/shared_preferences.dart';

/// 缓存管理类
class HiCache {
  SharedPreferences? prefs;
  // 私有化的构造方法
  HiCache._() {
    init();
  }
  void init() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  // 单例
  static HiCache? _instance;
  static HiCache getInstance() {
    if (_instance == null) {
      _instance = HiCache._();
    }

    return _instance!;
  }

  // 预初始化
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }

  HiCache._pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  //*  ------------------------------ */
  //*   方法

  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  // Object? get(String key) {
  //   return prefs?.get(key) ?? null;
  // }
  T? get<T>(String key) {
    var result = prefs?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }
}
