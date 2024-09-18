import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controller/search_controller.dart';
import '../booking/checkout_view.dart';
import 'prebook_failed_view.dart';
import 'prebook_stepper.dart';

class SpecialRequestToRoom extends StatefulWidget {
  const SpecialRequestToRoom({super.key, required this.updateCurrentStep});
  final ValueChanged<Steppers> updateCurrentStep;
  @override
  State<SpecialRequestToRoom> createState() => _SpecialRequestToRoomState();
}

class _SpecialRequestToRoomState extends State<SpecialRequestToRoom> {
  final _staticVar = StaticVar();
  bool requireaSmokingRoom = false;
  bool requestRoomonaLowFloor = false;
  bool honeymoonTrip = false;
  bool celebratingBirthday = false;
  bool requireaNonSmokingRoom = false;
  bool requestRoomonaHighFloor = false;
  bool requestforaBabyCot = false;
  bool celebratingAnniversary = false;

  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            widget.updateCurrentStep(Steppers.passengerInformation);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: _staticVar.primaryColor,
          ),
        ),
        SizedBox(width: 100.w, height: 1.h),
        CheackboxWithTitle(
          title: AppLocalizations.of(context)?.rSmokingRoom ?? "Require a Smoking Room",
          value: requireaSmokingRoom,
          onChange: (v) {
            requireaSmokingRoom = v;
            setState(() {});
          },
        ),
        CheackboxWithTitle(
          title: AppLocalizations.of(context)?.nSmokingRoom ?? "Require a Non Smoking Room",
          value: requireaNonSmokingRoom,
          onChange: (v) {
            requireaNonSmokingRoom = v;
            setState(() {});
          },
        ),
        CheackboxWithTitle(
          title: AppLocalizations.of(context)?.rLowFloor ?? "Require Room on a Low Floor",
          value: requestRoomonaLowFloor,
          onChange: (v) {
            requestRoomonaLowFloor = v;
            setState(() {});
          },
        ),
        CheackboxWithTitle(
          title: AppLocalizations.of(context)?.rHighFloor ?? "Require Room on a High Floor",
          value: requestRoomonaHighFloor,
          onChange: (v) {
            requestRoomonaHighFloor = v;
            setState(() {});
          },
        ),
        CheackboxWithTitle(
          title: AppLocalizations.of(context)?.honeymoonTrip ?? "Honeymoon Trip",
          value: honeymoonTrip,
          onChange: (v) {
            honeymoonTrip = v;
            setState(() {});
          },
        ),
        CheackboxWithTitle(
          title: AppLocalizations.of(context)?.rBabyCot ?? "Require for a baby Cot",
          value: requestforaBabyCot,
          onChange: (v) {
            requestforaBabyCot = v;
            setState(() {});
          },
        ),
        CheackboxWithTitle(
          title: AppLocalizations.of(context)?.celebratingBirthday ?? "Celebrating Birthday",
          value: celebratingBirthday,
          onChange: (v) {
            celebratingBirthday = v;
            setState(() {});
          },
        ),
        CheackboxWithTitle(
          title: AppLocalizations.of(context)?.celebratingAnniversary ?? "Celebrating Anniversary",
          value: celebratingAnniversary,
          onChange: (v) {
            celebratingAnniversary = v;
            setState(() {});
          },
        ),
        SizedBox(height: 1.h),
        CustomUserForm(
            maxLine: 4,
            controller: commentController,
            hintText: AppLocalizations.of(context)!.wUAddComment),
        SizedBox(height: 1.h),
        SizedBox(
            width: 100.w,
            height: 6.h,
            child: CustomBTN(
                onTap: () {
                  collectData();
                },
                title: AppLocalizations.of(context)?.next ?? "Next"))
      ],
    );
  }

  collectData() async {
    final data = {
      "specialRequest": [
        {
          "interconnecting_rooms": false,
          "smoking_room": requireaSmokingRoom,
          "non_smoking_room": requireaNonSmokingRoom,
          "room_low_floor": requestRoomonaLowFloor,
          "room_high_floor": requestRoomonaHighFloor,
          "vip_guest": false,
          "honeymoon": honeymoonTrip,
          "babycot": requestforaBabyCot,
          "birthday": celebratingBirthday,
          "anniversary": celebratingAnniversary,
          "other_request": commentController.text
        }
      ],
    };

    context.read<PrebookController>().prebookSpecialRequest = data;

    final hasQuestion = await context.read<PrebookController>().getActivityQuestions();

    if (hasQuestion) {
      widget.updateCurrentStep(Steppers.activityQuestions);
    } else {
      final result = await context.read<PrebookController>().proceedPreBooking(
          context.read<UserController>().userModel?.data?.token ?? '',
          context.read<PackSearchController>().userCollectedPoint);

      if (result["errorType"].toString().contains("PAYMENT_IN_PROGRESS")) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    'You have uncompleted Booking or Pennding payment ',
                    style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                    ),
                  ),
                  content: Text(
                    'Kindly try to book other services ',
                    style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                    ),
                  ),
                  actions: [
                    SizedBox(
                      width: 100.w,
                      child: CustomBTN(
                          onTap: () {
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pop();
                          },
                          title: "Close"),
                    )
                  ],
                ));
      } else if (result["errorType"].toString().contains("Services")) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const PrebookFailedServicesView()));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CheckoutView()));
      }
    }
  }
}

class CheackboxWithTitle extends StatelessWidget {
  const CheackboxWithTitle(
      {super.key, required this.title, required this.value, required this.onChange});
  final bool value;
  final String title;
  final ValueChanged<bool> onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style:
                TextStyle(fontSize: StaticVar().titleFontSize.sp - 1, color: StaticVar().cardcolor),
          ),
          Checkbox(
              activeColor: StaticVar().primaryColor,
              value: value,
              onChanged: (v) {
                onChange(v ?? false);
              })
        ],
      ),
    );
  }
}
