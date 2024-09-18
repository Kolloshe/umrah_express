import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../model/common_models/booking_cancellation_policy_model.dart';

class CancellBookingView extends StatefulWidget {
  const CancellBookingView({super.key, required this.cancellationPolicy, required this.bookingREF});
  final CancellationPolicyModel cancellationPolicy;
  final String bookingREF;

  @override
  State<CancellBookingView> createState() => _CancellBookingViewState();
}

class _CancellBookingViewState extends State<CancellBookingView> {
  final _staticVar = StaticVar();

  String _reasonValue = 'Trip cancelled';
  final userNoteController = TextEditingController();

  @override
  void dispose() {
    userNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _staticVar.cardcolor,
        elevation: 0.2,
        foregroundColor: _staticVar.primaryColor,
        title: Text(
          AppLocalizations.of(context)?.cancelBooking ?? "Cancel Booking",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          child: ListView(
            children: [
              SizedBox(height: 1.h),
              Text(
                widget.cancellationPolicy.data?.cancellationPolicy?.refundText ?? '',
                style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp,
                  fontWeight: _staticVar.titleFontWeight,
                ),
              ),
              SizedBox(height: 2.h),
              _buildCancelReasons(widget.cancellationPolicy.data?.cancellationReasons ?? []),
              SizedBox(height: 5.h),
              CustomUserForm(
                controller: userNoteController,
                hintText: AppLocalizations.of(context)?.otherReason ?? "Other reason",
                maxLine: 5,
              ),
              SizedBox(height: 4.h),
              SizedBox(
                width: 100.w,
                child: CustomBTN(
                  onTap: () {
                    cancellBooking();
                  },
                  title: AppLocalizations.of(context)?.cancelBooking ?? "Cancel Booking ",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelReasons(List<String> reasons) => Column(
        children: [
          for (var i = 0; i < reasons.length; i++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(reasons[i]),
              horizontalTitleGap: 1,
              titleTextStyle:
                  TextStyle(fontSize: _staticVar.titleFontSize.sp, color: _staticVar.blackColor),
              leading: Radio<String>(
                fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  return _staticVar.primaryColor;
                }),
                value: reasons[i],
                groupValue: _reasonValue,
                onChanged: (value) {
                  setState(() {
                    _reasonValue = value!;
                  });
                },
              ),
            ),
        ],
      );

  cancellBooking() async {
    bool acceptCancelling = false;

    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(AppLocalizations.of(context)?.areUsureToCancellThisBooking ??
                  'Are you sure you want to cancel this booking'),
              actions: [
                TextButton(
                    onPressed: () {
                      acceptCancelling = true;
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel',
                        style: TextStyle(color: _staticVar.redColor))),
                TextButton(
                    onPressed: () {
                      acceptCancelling = false;
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(color: _staticVar.greenColor),
                    ))
              ],
            ));

    if (!acceptCancelling) return;

    Map<String, dynamic> userInput = {
      "refNo": widget.bookingREF,
      "cancel": userNoteController.text,
      "reasonOpn": _reasonValue,
      "currency": UtilityVar.genCurrency
    };

    final result = await context.read<UserController>().cancellBooking(data: userInput);

    if (result != null) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                        color: _staticVar.cardcolor,
                        borderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animation/done.json'),
                        SizedBox(height: 2.h),
                        Text(
                          'Your booking has been cancelled',
                          style: TextStyle(
                              fontSize: _staticVar.titleFontSize.sp,
                              fontWeight: _staticVar.titleFontWeight,
                              color: _staticVar.blackColor),
                        ),
                        SizedBox(height: 1.h),
                        Text(result.message),
                        SizedBox(height: 2.h),
                        CustomBTN(
                            onTap: () {
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                            },
                            title: AppLocalizations.of(context)?.close ?? "Close")
                      ],
                    )),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                        color: _staticVar.cardcolor,
                        borderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/animation/failed.json'),
                        SizedBox(height: 2.h),
                        Text(
                          'Failed to Cancel your booking',
                          style: TextStyle(
                              fontSize: _staticVar.titleFontSize.sp,
                              fontWeight: _staticVar.titleFontWeight,
                              color: _staticVar.blackColor),
                        ),
                        SizedBox(height: 1.h),
                        Text(''),
                        SizedBox(height: 2.h),
                        CustomBTN(
                            onTap: () {
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                            },
                            title: AppLocalizations.of(context)?.close ?? "Close")
                      ],
                    )),
              ));
    }
  }
}
