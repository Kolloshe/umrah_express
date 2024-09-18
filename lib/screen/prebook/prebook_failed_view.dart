import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/custom_extension.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/customize/customize_activities/activity_listing_view.dart';
import 'package:umrah_by_lamar/screen/customize/customize_esim/change_esim_view.dart';
import 'package:umrah_by_lamar/screen/customize/customize_flights/flight_change_view.dart';
import 'package:umrah_by_lamar/screen/customize/customize_hotels/change_hotel_view.dart';
import 'package:umrah_by_lamar/screen/customize/customize_transfer/change_transfer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../model/customize_models/flights_model/flights_listing_model.dart';
import '../../model/prebook_models/prebook_result_model.dart';
import '../booking/checkout_view.dart';
import '../customize/customize_v2/customize_flights/change_flight/change_flight_listing.dart';
import '../customize/customize_v2/customize_hotel/change_hotel/change_hotel_listing.dart';

class PrebookFailedServicesView extends StatefulWidget {
  const PrebookFailedServicesView({super.key});

  @override
  State<PrebookFailedServicesView> createState() => _PrebookFailedServicesViewState();
}

class _PrebookFailedServicesViewState extends State<PrebookFailedServicesView> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        title: Text(
          AppLocalizations.of(context)?.failedServices ?? "Failed Services",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        elevation: 0.2,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<PrebookController>(builder: (context, data, child) {
          return ListView(
            children: [
              (data.prebookResultModel?.data?.prebookDetails?.flights?.prebookSuccess ?? true) ==
                      false
                  ? _buildFailedServices(
                      icon: Icons.flight,
                      title:
                          "${AppLocalizations.of(context)?.pleaseReplaceYour ?? "Please replace your"} ${AppLocalizations.of(context)?.flight ?? "flight"}",
                      subtitle:
                          data.prebookResultModel?.data?.prebookDetails?.flights?.message ?? '',
                      onTap: () {
                        if (data.prebookResultModel?.data?.prebookDetails?.flights != null) {
                          handleFlightFailed(
                              data.prebookResultModel!.data!.prebookDetails!.flights!);
                        }
                      },
                    )
                  : const SizedBox(),
              SizedBox(height: 1.h),
              for (var failedActivity
                  in data.prebookResultModel?.data?.prebookDetails?.activites?.details ??
                      <ActivitesDetail>[])
                _buildFailedServices(
                    onTap: () async {
                      handelActiviyFailed(failedActivity);
                    },
                    title:
                        '${AppLocalizations.of(context)?.pleaseReplaceYour ?? ''} ${AppLocalizations.of(context)?.activity ?? "Activity"}',
                    subtitle:
                        "${failedActivity.details.name} ${AppLocalizations.of(context)?.on ?? "on"} ${DateFormat("dd/MMM").format(failedActivity.date)}",
                    icon: Icons.directions_run_sharp),
              SizedBox(height: 1.h),
              (data.prebookResultModel?.data?.prebookDetails?.hotels?.prebookSuccess ?? true) ==
                      false
                  ? _buildFailedServices(
                      icon: Icons.hotel,
                      title:
                          '${AppLocalizations.of(context)?.pleaseReplaceYour ?? ''} ${AppLocalizations.of(context)?.hotels ?? "Hotel"}',
                      subtitle:
                          data.prebookResultModel?.data?.prebookDetails?.hotels?.message ?? '',
                      onTap: () {
                        handleHotelFailed(data.prebookResultModel!.data!.prebookDetails!.hotels!);
                      },
                    )
                  : const SizedBox(),
              SizedBox(height: 1.h),
              (data.prebookResultModel?.data?.prebookDetails?.transfers ?? true) == false
                  ? _buildFailedServices(
                      icon: Icons.directions_car,
                      title:
                          '${AppLocalizations.of(context)?.pleaseReplaceYour ?? ''} ${AppLocalizations.of(context)?.transfer ?? "Transfers"}',
                      subtitle:
                          data.prebookResultModel?.data?.prebookDetails?.transfers?.message ?? '',
                      onTap: () {
                        handelTransferFailed();
                      },
                    )
                  : const SizedBox(),
              SizedBox(height: 1.h),
              (data.prebookResultModel?.data?.prebookDetails?.esim?.prebookSuccess ?? true) == false
                  ? _buildFailedServices(
                      icon: Icons.sim_card,
                      title:
                          '${AppLocalizations.of(context)?.pleaseReplaceYour ?? ''} ${AppLocalizations.of(context)?.esimCard ?? "Esim card"}',
                      subtitle: data.prebookResultModel?.data?.prebookDetails?.esim?.message ?? '',
                      onTap: () {
                        handelEsimFailed();
                      })
                  : const SizedBox(),
            ],
          );
        }),
      )),
    );
  }

  int getActivityDay(ActivitesDetail failedActivity) {
    final allActivity = context
            .read<PrebookController>()
            .packageCustomize
            ?.result
            ?.activities
            ?.values
            .map((e) => e.first)
            .toList() ??
        [];

    final f = allActivity
        .where((element) => element.activityDate?.isAtSameMomentAs(failedActivity.date) ?? false)
        .toList();
    if (f.isNotEmpty) {
      return f.first.day?.toInt() ?? 0;
    } else {
      return 0;
    }
  }

  Widget _buildFailedServices(
      {required String title, required IconData icon, String? subtitle, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
        decoration: BoxDecoration(
            border: Border(left: BorderSide(color: _staticVar.redColor, width: 5)),
            color: _staticVar.cardcolor,
            borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
            boxShadow: [_staticVar.shadow]),
        padding: EdgeInsets.symmetric(
          horizontal: _staticVar.defaultPadding,
          vertical: _staticVar.defaultPadding * 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              decoration: BoxDecoration(shape: BoxShape.circle, color: _staticVar.redColor),
              child: Icon(
                icon,
                size: 20,
                color: _staticVar.cardcolor,
              ),
            ),
            SizedBox(width: 2.w),
            SizedBox(
              width: 74.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                        fontWeight: _staticVar.titleFontWeight),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    subtitle ?? '',
                    style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                  )
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  handleFlightFailed(Flights failedFlight) async {
    final result = await context.read<CustomizeController>().getFlightsListing();

    if (result != null) {
      final grouped =
          (result.data ?? <FlightData?>[]).map((e) => e).groupBy((p0) => p0?.carrier?.name ?? '');
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeFlightListingScreen(
                flightListing: result,
                grouped: grouped,
                //prebookFailed: true,
              )));
      context
          .read<PrebookController>()
          .getCustomizeData(context.read<CustomizeController>().packageCustomize!);
      await retryPreBooking();
    }
  }

  handleHotelFailed(Hotels failedHotel) async {
    final result = await context.read<CustomizeController>().getHotelListing(
        checkIn: failedHotel.details.first.details.checkIn,
        checkOut: failedHotel.details.first.details.checkout,
        hotelID: failedHotel.details.first.details.hotelId,
        star: '');

    if (result) {
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ChangeHotelListing()));
      await retryPreBooking();
    }
  }

  handelTransferFailed() async {
    final result = await context.read<CustomizeController>().getTransferListing();

    if (result) {
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ChangeTransferView()));

      await retryPreBooking();
    }
  }

  handelEsimFailed() async {
    final result = await context.read<CustomizeController>().getEsimListing();

    if (result) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeEsimView(
                failedPrebook: true,
              )));
      await retryPreBooking();
    }
  }

  retryPreBooking() async {
    final result = await context.read<PrebookController>().proceedPreBooking(
        context.read<UserController>().userModel?.data?.token ?? '',
        context.read<PackSearchController>().userCollectedPoint);

    if (result['status']) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CheckoutView()));
    }
  }

  handelActiviyFailed(ActivitesDetail failedActivity) async {
    final day = getActivityDay(failedActivity);
    print(day);
    //  if (day != 0) {
    final result = await context.read<CustomizeController>().getActivityList(day);

    if (result) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ActivityListingView(activityDay: day, failedPrebook: true, activityData: {
                "id": failedActivity.details.activityId,
                "activityDate":
                    DateFormat('yyyy-MM-dd').format(failedActivity.details.activityDate),
                "activityName": failedActivity.details.name
              })));

      await retryPreBooking();
    }
    //}
  }
}
