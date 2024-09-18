import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../model/customize_models/package_customize_model.dart';

class ActivityView extends StatelessWidget {
  ActivityView({super.key, required this.activities});

  final List<Activity> activities;

  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (var activity in activities) _buildActivity(activity)],
    );
  }

  _buildActivity(Activity activity) {
    return SizedBox(
      width: 100.w,
      height: 7.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 25.w,
            height: 7.h,
            margin: EdgeInsets.only(bottom: _staticVar.defaultPadding),
            padding: EdgeInsets.only(left: _staticVar.defaultPadding, top: 1, bottom: 1, right: 1),
            decoration: BoxDecoration(
              border: Border.all(color: _staticVar.gray),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd\nMMM').format(activity.activityDate ?? DateTime.now()),
                  style:
                      TextStyle(color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp),
                ),
                SizedBox(width: 1.w),
                CustomImage(
                  url: activity.image ?? '',
                  boxFit: BoxFit.cover,
                  width: 15.5.w,
                  height: 7.h,
                )
              ],
            ),
          ),
          SizedBox(width: 2.w),
          SizedBox(
            width: 60.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  activity.description ?? '',
                  style:
                      TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.gray),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
