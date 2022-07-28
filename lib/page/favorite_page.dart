import 'package:bili/page/favorites_refersh_page.dart';
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
        title: Text("收藏"),
      ),
      body: FavoritesRefershPage(),
    );
  }
}
