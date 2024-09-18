import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/screen/customize/customize_activities/activity_manager_view.dart';
import 'package:provider/provider.dart';

import '../../../common/static_var.dart';
import '../../customize/customize_activities/activity_listing_view.dart';

class ActivityResultScreen extends StatefulWidget {
  const ActivityResultScreen({super.key});

  @override
  State<ActivityResultScreen> createState() => _ActivityResultScreenState();
}

class _ActivityResultScreenState extends State<ActivityResultScreen> {
  getData() async {
    final packid =
        context.read<PackSearchController>().searchResultModel?.data?.packages?.first.id ?? "";
    await Future.delayed(Duration(seconds: 2));
    final result = await context.read<CustomizeController>().customizePackage(packid);

    if (result) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityManager()));
      final hasList = await context.read<CustomizeController>().getActivityList(context
          .read<CustomizeController>()
          .packageCustomize
          ?.result
          ?.activities
          ?.values
          .first
          .first
          .day);
      if (hasList) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ActivityListingView(
                activityDay: context
                        .read<CustomizeController>()
                        .packageCustomize
                        ?.result
                        ?.activities
                        ?.values
                        .first
                        .first
                        .day ??
                    1)));
      }
    }

    if (result) {}
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return ActivityListingView(
        activityDay: context
                .read<CustomizeController>()
                .packageCustomize
                ?.result
                ?.activities
                ?.values
                .first
                .first
                .day ??
            1);
  }
}
