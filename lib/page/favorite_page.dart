import 'package:bili/navigator/hi_navigator.dart';
import 'package:bili/page/favorites_refersh_page.dart';
import 'package:bili/page/video_detail_page.dart';
import 'package:flutter/material.dart';

///收藏
class FavoritePage extends StatefulWidget {
  FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            "收藏",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: FavoritesRefershPage(),
    );
  }
}
