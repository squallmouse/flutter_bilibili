import 'package:bili/model/home_model.dart';
import 'package:flutter/material.dart';

///
class HomeTabPage extends StatefulWidget {
  final String name;
  final List<BannerModel>? bannerList;
  HomeTabPage({Key? key, required this.name, this.bannerList})
      : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          widget.name,
        ),
      ),
    );
  }
}
