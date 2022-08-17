import 'package:bili/model/profile_model.dart';
import 'package:bili/util/image_cached.dart';
import 'package:bili/util/my_log.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final List<CourseModel> courseList;
  const CourseCard({Key? key, required this.courseList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 10, right: 5),
      child: Column(
        children: [
          /// 标题
          _buildTitle(),
          // 课程内容
          ..._buildCourse(context),
        ],
      ),
    );
  }

  /// 一行的标题
  _buildTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Text(
            "职场进阶",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(
            "带你突破技术瓶颈",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  _buildCourse(BuildContext context) {
    var courseGroup = Map();

    courseList.forEach((mo) {
      if (!courseGroup.containsKey(mo.group)) {
        courseGroup[mo.group] = [];
      }
      List list = courseGroup[mo.group];
      list.add(mo);
    });

    List<Widget> widgetList = courseGroup.entries.map((e) {
      myLog("e ==> ${e} ", StackTrace.current);
      List tempList = e.value;
      var width =
          (MediaQuery.of(context).size.width - 20 - (tempList.length - 1) * 5) /
              tempList.length;
      myLog("width ==> ${width}", StackTrace.current);
      var height = width * 8 / 16;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...tempList.map((mo) => _buildCard(mo, width, height)).toList(),
        ],
      );
    }).toList();

    return widgetList;
  }

  _buildCard(CourseModel mo, double width, double height) {
    return InkWell(
      onTap: () {
        myLog("调换到H5", StackTrace.current);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 5, 7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: ImageCachedUtils(
            mo.cover ?? "",
            iwidth: width,
            iheight: height,
          ),
        ),
      ),
    );
  }
}
