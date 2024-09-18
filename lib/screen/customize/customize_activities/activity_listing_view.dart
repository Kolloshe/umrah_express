import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../model/customize_models/activity_model/activites_list_model.dart';
import 'activity_details_view.dart';

class ActivityListingView extends StatefulWidget {
  const ActivityListingView(
      {super.key, required this.activityDay, this.failedPrebook, this.activityData});
  final bool? failedPrebook;
  final num activityDay;
  final Map? activityData;

  @override
  State<ActivityListingView> createState() => _ActivityListingViewState();
}

class _ActivityListingViewState extends State<ActivityListingView> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.availableActivity ?? "Available activity",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        elevation: 0.3,
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        bottom: (widget.failedPrebook ?? false)
            ? PreferredSize(
                preferredSize: Size.fromHeight(5.h),
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(_staticVar.defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 50.w,
                              child: Text(
                                widget.activityData?['activityName'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(AppLocalizations.of(context)?.failedToPrebook ?? "")
                          ],
                        )),
                        GestureDetector(
                          onTap: () async {
                            await context.read<CustomizeController>().removeSingleActivity(
                                activityId: widget.activityData?['id'],
                                activityDate: widget.activityData?["activityDate"]);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppLocalizations.of(context)?.remove ?? "Remove",
                            style: TextStyle(color: _staticVar.primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: Consumer<CustomizeController>(builder: (context, data, child) {
        return SafeArea(
            child: Padding(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          child: ListView(
            children: [
              for (var activity in (data.activitiesListModel?.data ?? <AvailableActivity>[]))
                _buildActivityCard(activity),
            ],
          ),
        ));
      }),
    );
  }

  Widget _buildActivityCard(AvailableActivity activity) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
      decoration: BoxDecoration(
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            url: activity.image ?? '',
            width: 35.w,
            height: 20.h,
            boxFit: BoxFit.cover,
          ),
          SizedBox(
            width: 60.w,
            height: 20.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name ?? '',
                  style: TextStyle(
                      fontSize: _staticVar.subTitleFontSize.sp,
                      fontWeight: _staticVar.titleFontWeight),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Text(
                  activity.content ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ActivityDetailsView(
                                availableActivity: activity,
                              )));
                    },
                    child: Text(
                      AppLocalizations.of(context)?.viewDetails ?? "View details",
                      style: TextStyle(
                          color: _staticVar.primaryColor, fontSize: _staticVar.subTitleFontSize.sp),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                    width: 65.w,
                    child: CustomBTN(
                        onTap: () async {
                          final result = await context.read<CustomizeController>().updateActivity(
                              activityId: activity.activityId ?? '',
                              activityDay: widget.activityDay);

                          if (result) {
                            Navigator.of(context).pop();
                          }
                        },
                        title: AppLocalizations.of(context)?.select ?? 'Select'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
