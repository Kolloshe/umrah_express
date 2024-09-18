import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/prebook_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../model/customize_models/package_customize_model.dart';
import '../../auth/login.dart';
import '../../prebook/prebook_stepper.dart';
import 'activity_details_view.dart';
import 'activity_listing_view.dart';

class ActivityManager extends StatefulWidget {
  const ActivityManager({super.key});

  @override
  State<ActivityManager> createState() => _ActivityManagerState();
}

class _ActivityManagerState extends State<ActivityManager> {
  final _staticVar = StaticVar();

  Map<DateTime, Activity?> activitiesData = {};

  getActivityData() {
    activitiesData = context.read<CustomizeController>().prepareActivity();
  }

  @override
  void initState() {
    getActivityData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              AppLocalizations.of(context)?.manageYourActivities ?? 'Manage your daily activity',
              style: TextStyle(fontSize: _staticVar.titleFontSize.sp)),
          backgroundColor: _staticVar.cardcolor,
          foregroundColor: _staticVar.primaryColor,
          elevation: 0.3),
      body: SafeArea(
        child: ListView(
          children: [
            for (int i = 0; i < activitiesData.length; i++)
              _buildActivity(
                  index: i,
                  date: activitiesData.keys.toList()[i],
                  activity: activitiesData.values.toList()[i]),
          ],
        ),
      ),
      bottomSheet: context.read<PackSearchController>().searchMode.toLowerCase() == "activity"
          ? Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 100.w,
                    child: CustomBTN(
                        onTap: () {
                          if (context.read<UserController>().userModel != null) {
                            final pack = context.read<CustomizeController>().packageCustomize;
                            context.read<PrebookController>().getCustomizeData(pack!);
                            context.read<PrebookController>().preparePassengers();
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const PrebookStepper()));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginScreen(fromCustomize: true)));
                          }
                        },
                        title: AppLocalizations.of(context)?.bookNow ?? "Book now"),
                  ),
                  SizedBox(height: 3.h)
                ],
              ),
            )
          : null,
    );
  }

  _buildActivity({required DateTime date, Activity? activity, required int index}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          width: 40.w,
          decoration: BoxDecoration(
              color: _staticVar.gray,
              borderRadius:
                  BorderRadius.only(topRight: Radius.circular(_staticVar.defaultRadius * 2))),
          child: Text(
            DateFormat('dd MMM').format(date),
            style: TextStyle(
                color: _staticVar.cardcolor,
                fontSize: _staticVar.titleFontSize.sp,
                fontWeight: _staticVar.titleFontWeight),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImage(
              url: activity?.image ?? '',
              width: 40.w,
              height: 25.h,
              boxFit: BoxFit.cover,
            ),
            Container(
              height: 25.h,
              decoration:
                  BoxDecoration(color: _staticVar.cardcolor, boxShadow: [_staticVar.shadow]),
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              width: 60.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: context.read<CustomizeController>().packageCustomize?.result?.flight ==
                            null &&
                        activity != null
                    ? [
                        Text(activity.name ?? '',
                            style: TextStyle(
                              fontSize: _staticVar.titleFontSize.sp,
                              fontWeight: _staticVar.titleFontWeight,
                            )),
                        SizedBox(height: 2.h),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ActivityDetailsView(
                                        activity: activity,
                                      )));
                            },
                            child: Text(
                              AppLocalizations.of(context)?.viewDetails ?? '',
                              style: TextStyle(
                                  color: _staticVar.primaryColor,
                                  fontWeight: _staticVar.titleFontWeight,
                                  fontSize: _staticVar.subTitleFontSize.sp),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: CustomBTN(
                              onTap: () async {
                                final result = await context
                                    .read<CustomizeController>()
                                    .getActivityList(activity.day);

                                if (!mounted) return;

                                if (result) {
                                  await Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ActivityListingView(
                                            activityDay: activity.day ?? 1,
                                          )));

                                  getActivityData();
                                  setState(() {});
                                }
                              },
                              title: AppLocalizations.of(context)?.changeActivity ??
                                  "Change activity"),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: CustomBTN(
                              onTap: () async {
                                await context.read<CustomizeController>().removeSingleActivity(
                                    activityId: activity.activityId,
                                    activityDate: DateFormat('yyyy-MM-dd')
                                        .format(activity.activityDate ?? DateTime.now()));

                                getActivityData();
                                setState(() {});
                              },
                              title: AppLocalizations.of(context)?.removeActivity ??
                                  "Remove activity"),
                        ),
                      ]
                    : ((context.read<CustomizeController>().checkFirstDayForActivity() == false) &&
                            (index == 0))
                        ? [Text(AppLocalizations.of(context)?.youWonBeAbleAnyActivityDay ?? '')]
                        : ((activitiesData.length - 1 == index))
                            ? (context.read<CustomizeController>().checkActiviyLastDay())
                                ? [
                                    Text(
                                        "Your estimated departure time is on ${(context.read<CustomizeController>().packageCustomize?.result?.flight?.to?.departureTime ?? '12')}  Hrs Would you like to book any activity on that day? "),
                                    SizedBox(height: 4.h),
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomBTN(
                                          onTap: () async {
                                            final result = await context
                                                .read<CustomizeController>()
                                                .getActivityList(index);

                                            if (!mounted) return;

                                            if (result) {
                                              await Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => ActivityListingView(
                                                        activityDay: index,
                                                      )));

                                              getActivityData();
                                              setState(() {});
                                            }
                                          },
                                          title: AppLocalizations.of(context)?.addActivity ??
                                              "Add activity"),
                                    )
                                  ]
                                : [
                                    Text(
                                        "Your estimated departure time is on ${(context.read<CustomizeController>().packageCustomize?.result?.flight?.to?.departureTime ?? '12')}   Hrs You won't be able to book any activity on that day.")
                                  ]
                            : activity == null
                                ? [
                                    Text(
                                        AppLocalizations.of(context)
                                                ?.wouldYouLikeToBookAnyActivity ??
                                            '',
                                        style: TextStyle(
                                          fontSize: _staticVar.titleFontSize.sp,
                                        )),
                                    SizedBox(height: 5.h),
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomBTN(
                                          onTap: () async {
                                            final result = await context
                                                .read<CustomizeController>()
                                                .getActivityList(index);

                                            if (!mounted) return;

                                            if (result) {
                                              await Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => ActivityListingView(
                                                        activityDay: index,
                                                      )));

                                              getActivityData();
                                              setState(() {});
                                            }
                                          },
                                          title: AppLocalizations.of(context)?.addActivity ??
                                              "Add activity"),
                                    ),
                                  ]
                                : [
                                    Text(activity.name ?? '',
                                        style: TextStyle(
                                          fontSize: _staticVar.titleFontSize.sp,
                                          fontWeight: _staticVar.titleFontWeight,
                                        )),
                                    SizedBox(height: 2.h),
                                    Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => ActivityDetailsView(
                                                    activity: activity,
                                                  )));
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)?.viewDetails ?? '',
                                          style: TextStyle(
                                              color: _staticVar.primaryColor,
                                              fontWeight: _staticVar.titleFontWeight,
                                              fontSize: _staticVar.subTitleFontSize.sp),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomBTN(
                                          onTap: () async {
                                            final result = await context
                                                .read<CustomizeController>()
                                                .getActivityList(activity.day);

                                            if (!mounted) return;

                                            if (result) {
                                              await Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => ActivityListingView(
                                                        activityDay: activity.day ?? 1,
                                                      )));

                                              getActivityData();
                                              setState(() {});
                                            }
                                          },
                                          title: AppLocalizations.of(context)?.changeActivity ??
                                              "Change activity"),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomBTN(
                                          onTap: () async {
                                            await context
                                                .read<CustomizeController>()
                                                .removeSingleActivity(
                                                    activityId: activity.activityId,
                                                    activityDate: DateFormat('yyyy-MM-dd').format(
                                                        activity.activityDate ?? DateTime.now()));

                                            getActivityData();
                                            setState(() {});
                                          },
                                          title: AppLocalizations.of(context)?.removeActivity ??
                                              "Remove activity"),
                                    ),
                                  ],
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h)
      ],
    );
  }
}
