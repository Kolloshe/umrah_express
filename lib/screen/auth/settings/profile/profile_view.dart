import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:glass/glass.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'change_password_view.dart';
import 'edit_profile.dart';
import 'reset_password_view.dart';
import 'user_booking_view.dart';
import 'user_saved_passenger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _staticVar.primaryColor,
        foregroundColor: _staticVar.cardcolor,
        title: Text(
          AppLocalizations.of(context)?.profile ?? "Profile",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(child: Consumer<UserController>(builder: (context, data, child) {
        return Column(
          children: [
            Container(
              width: 100.w,
              height: 20.h,
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              decoration: BoxDecoration(
                  color: _staticVar.primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(_staticVar.defaultRadius),
                      bottomRight: Radius.circular(_staticVar.defaultRadius))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CustomImage(
                      url: data.userModel?.data?.profileImage ?? '',
                      width: 25.w,
                      height: 25.w,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    data.userModel?.data?.name ?? '',
                    style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp * 1.5,
                      color: _staticVar.cardcolor,
                      fontWeight: _staticVar.titleFontWeight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Column(
                children: [
                  SimpleSettingsTile(
                    title: AppLocalizations.of(context)!.profileInformation,
                    subtitle:
                        "${data.userModel?.data?.name ?? ''}  ${data.userModel?.data?.lastName ?? ''}",
                    subtitleTextStyle: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                    titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                    child: const EditProfile(),
                  ),
                  SizedBox(height: 0.5.h),
                  SimpleSettingsTile(
                    title: AppLocalizations.of(context)?.passengers ?? 'Passengers',
                    subtitle:
                        AppLocalizations.of(context)?.passengersRecords ?? "Passengers Records",
                    subtitleTextStyle: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                    titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                    child: const UserPassengersView(),
                  ),
                  SizedBox(height: 0.5.h),
                  SimpleSettingsTile(
                    title: AppLocalizations.of(context)?.myBooking ?? 'My Booking',
                    titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                    // child: Container(),

                    onTap: () async {
                      final result = await data.getUserBookingList();

                      if (result) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const UserBookingsView()));
                      } else {
                        _staticVar.showToastMessage(
                            message: AppLocalizations.of(context)?.theyNoBooking ?? '');
                      }
                    },
                  ),
                  SizedBox(height: 0.5.h),
                  SimpleSettingsTile(
                    title: AppLocalizations.of(context)?.resetPassword ?? 'Reset password',
                    titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                    child: ResetPasswordView(),
                  ),
                  SizedBox(height: 0.5.h),
                  SimpleSettingsTile(
                    title: AppLocalizations.of(context)?.changePassword ?? 'Change password',
                    titleTextStyle: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                    child: ChangePassword(),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    AppLocalizations.of(context)?.deleteAccount ?? "Delete this Account ?",
                    style: TextStyle(
                        color: _staticVar.redColor, fontSize: _staticVar.subTitleFontSize.sp),
                  )
                ],
              ),
            ),
          ],
        );
      })),
    );
  }
}
