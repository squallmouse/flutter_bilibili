// import 'dart:html';
import 'dart:ui';

final WIDTH = window.physicalSize.width;

double hc_ScreenWidth() {
  return window.physicalSize.width / window.devicePixelRatio;
}

double hc_ScreenHeight() {
  return window.physicalSize.height / window.devicePixelRatio;
}

// double hc_FitWidth(double width) {
//   return hc_ScreenWidth() / 375.0 * width;
// }

// double hc_FitHeight(double height) {
//   return hc_ScreenHeight() / 667.0 * height;
// }
