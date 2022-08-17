import 'package:url_launcher/url_launcher.dart';

Future<void> urlLauncher_util(String? url) async {
  if (url == null) {
    print("||==>> url 为空");
  }
  Uri _url = Uri.parse(url!);
  launchUrl(_url);
}
