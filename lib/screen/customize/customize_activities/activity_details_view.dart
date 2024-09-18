import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/model/customize_models/activity_model/activites_list_model.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ActivityDetailsView extends StatelessWidget {
  ActivityDetailsView({super.key, this.activity, this.availableActivity});

  final Activity? activity;
  final AvailableActivity? availableActivity;

  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.activityDetails ?? 'Activity details',
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        elevation: 0.3,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          child: ListView(
            children: [
              CustomImage(
                url: (activity?.image ?? availableActivity?.image) ?? '',
                width: 100.w,
                height: 25.h,
                boxFit: BoxFit.cover,
                withRadius: true,
              ),
              SizedBox(height: 2.h),
              Text(
                (activity?.name ?? availableActivity?.name) ?? '',
                style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp,
                  fontWeight: _staticVar.titleFontWeight,
                ),
              ),
              SizedBox(height: 1.h),
              activity == null
                  ? const SizedBox()
                  : Text(DateFormat('MMM dd  y').format(activity?.activityDate ?? DateTime.now())),
              SizedBox(height: 1.h),
              Text((activity?.description ?? availableActivity?.content) ?? '')
            ],
          ),
        ),
      ),
    );
  }
}
