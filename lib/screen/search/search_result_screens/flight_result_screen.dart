import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../model/search_models/search_result_models/search_result_model.dart';
import '../../customize/customize_flights/selected_flight_details_view.dart';

class FlightResultScreen extends StatefulWidget {
  const FlightResultScreen({super.key});

  @override
  State<FlightResultScreen> createState() => _FlightResultScreenState();
}

class _FlightResultScreenState extends State<FlightResultScreen> {
  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.flight ?? "Flight",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        backgroundColor: _staticVar.cardcolor,
        elevation: 0.3,
        foregroundColor: _staticVar.primaryColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<PackSearchController>(builder: (context, data, child) {
          return Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${dateFormatter(data.searchResultModel?.data?.searchData?.packageStart ?? '')} - ${dateFormatter(data.searchResultModel?.data?.searchData?.packageEnd ?? '')}",
                      style: TextStyle(
                          fontWeight: _staticVar.titleFontWeight,
                          fontSize: _staticVar.subTitleFontSize.sp),
                    ),
                    Text(
                      "${data.searchResultModel?.data?.searchData?.fromCity ?? ""} - ${data.searchResultModel?.data?.searchData?.toCity ?? ""}",
                      style: TextStyle(
                          fontWeight: _staticVar.titleFontWeight,
                          fontSize: _staticVar.subTitleFontSize.sp),
                    )
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              Expanded(
                  child: ListView(
                children: [
                  for (var flight in data.searchResultModel?.data?.packages ?? <Package>[])
                    _buildFlightCard(flight)
                ],
              )),
            ],
          );
        }),
      )),
    );
  }

  Widget _buildFlightCard(Package flight) {
    return GestureDetector(
      onTap: () async {
        final result = await context.read<CustomizeController>().customizePackage(flight.id ?? "");
        if (result == false) return;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FlightDetials(
                  flightFromCustomize:
                      context.read<CustomizeController>().packageCustomize?.result?.flight,
                  fromFlightSearch: true,
                )));
      },
      child: Container(
        margin: EdgeInsets.all(_staticVar.defaultPadding),
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        decoration: BoxDecoration(
            boxShadow: [_staticVar.shadow],
            borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
            color: _staticVar.cardcolor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 6.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.flightTime ?? "Flight Time",
                        style: TextStyle(
                            color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp),
                      ),
                      Text(
                        flight.flightDetails?.from?.travelTime ?? "",
                        style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                    child: VerticalDivider(
                      color: _staticVar.gray,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.fStops ?? "Stops",
                        style: TextStyle(
                            color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp),
                      ),
                      Text(
                        AppLocalizations.of(context)
                                ?.flightStop((flight.flightDetails?.from?.numstops ?? 0)) ??
                            '',
                        style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                    child: VerticalDivider(
                      color: _staticVar.gray,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.flightClass ?? "Flight Class",
                        style: TextStyle(
                            color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp),
                      ),
                      Text(
                        handleFlightClass(flight.flightDetails?.flightClass ?? ""),
                        style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Divider(color: _staticVar.gray, indent: 10, endIndent: 10),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomImage(
                  url: flight.flightDetails?.from?.itinerary?.first.company?.logo ?? "",
                  height: 7.h,
                ),
                SizedBox(width: 5.w),
                Text(
                  "${flight.flightDetails?.from?.carrierName ?? ""}\n${flight.flightDetails?.from?.carrierCode ?? ""}-${flight.flightDetails?.from?.itinerary?.first.flightNo ?? ""}",
                  style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                ),
              ],
            ),
            Text(AppLocalizations.of(context)?.yourDepartureFlight ?? 'Departure flight'),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Text(
                        flight.flightDetails?.from?.itinerary?.first.departure?.time ?? "",
                        style: TextStyle(fontWeight: FontWeight.w500, color: _staticVar.blackColor),
                      ),
                      Text(flight.flightDetails?.from?.itinerary?.first.departure?.locationId ?? "")
                    ],
                  ),
                  (flight.flightDetails?.from?.numstops ?? 0) > 0
                      ? SizedBox(
                          width: 50.w,
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  height: 1.h,
                                  color: _staticVar.primaryColor,
                                ),
                              ),
                              for (var itinerary
                                  in (flight.flightDetails?.from?.itinerary ?? <FromItinerary>[])
                                      .skip(1))
                                SizedBox(
                                  width: 10.w,
                                  child: Column(
                                    children: [
                                      Text(
                                        itinerary.departure?.time ?? '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: _staticVar.blackColor),
                                      ),
                                      Text(itinerary.departure?.locationId ?? '')
                                    ],
                                  ),
                                ),
                              Expanded(
                                child: Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  height: 1.h,
                                  color: _staticVar.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          width: 50.w,
                          child: Divider(
                            indent: 10,
                            endIndent: 10,
                            height: 1.h,
                            color: _staticVar.primaryColor,
                          ),
                        ),
                  Column(
                    children: [
                      Text(
                        (flight.flightDetails?.from?.itinerary ?? []).last.arrival?.time ?? '',
                        style: TextStyle(fontWeight: FontWeight.w500, color: _staticVar.blackColor),
                      ),
                      Text((flight.flightDetails?.from?.itinerary ?? []).last.arrival?.locationId ??
                          '')
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: _staticVar.primaryColor.withOpacity(0.3)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 20.w,
                  height: 7.h,
                  child: CustomImage(
                    url: (flight.flightDetails?.to?.itinerary ?? []).first.company?.logo ?? '',
                    height: 7.h,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${flight.flightDetails?.to?.carrierName ?? ''}\n${'${flight.flightDetails?.to?.carrierCode ?? ""}-${(flight.flightDetails?.to?.itinerary ?? []).first.flightNo ?? ""}'}",
                      style: TextStyle(
                          fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.blackColor),
                    ),
                  ],
                ),
              ],
            ),
            Text(AppLocalizations.of(context)?.yourArrivalFlight ?? 'Return Flight'),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Text(
                        (flight.flightDetails?.to?.itinerary ?? []).first.departure?.time ?? '',
                        style: TextStyle(fontWeight: FontWeight.w500, color: _staticVar.blackColor),
                      ),
                      Text(
                          (flight.flightDetails?.to?.itinerary ?? []).first.departure?.locationId ??
                              '')
                    ],
                  ),
                  (flight.flightDetails?.to?.numstops ?? 0) > 0
                      ? SizedBox(
                          width: 50.w,
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  height: 1.h,
                                  color: _staticVar.primaryColor,
                                ),
                              ),
                              for (var itinerary
                                  in (flight.flightDetails?.to?.itinerary ?? <ToItinerary>[])
                                      .skip(1))
                                SizedBox(
                                  width: 10.w,
                                  child: Column(
                                    children: [
                                      Text(
                                        itinerary.departure?.time ?? "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: _staticVar.blackColor),
                                      ),
                                      Text(itinerary.departure?.locationId ?? "")
                                    ],
                                  ),
                                ),
                              Expanded(
                                child: Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  height: 1.h,
                                  color: _staticVar.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          width: 50.w,
                          child: Divider(
                            indent: 10,
                            endIndent: 10,
                            height: 1.h,
                            color: _staticVar.primaryColor,
                          ),
                        ),
                  Column(
                    children: [
                      Text(
                        (flight.flightDetails?.to?.itinerary ?? []).last.arrival?.time ?? "",
                        style: TextStyle(fontWeight: FontWeight.w500, color: _staticVar.blackColor),
                      ),
                      Text((flight.flightDetails?.to?.itinerary ?? []).last.arrival?.locationId ??
                          '')
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: _staticVar.primaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5)),
              width: 100.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(((flight.flightDetails?.from?.itinerary ?? []).first.baggageInfo ?? [])
                      .join(',')),
                  Text(
                    '${flight.total} ${UtilityVar.localizeCurrency(val: flight.sellingCurrency ?? "")}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String handleFlightClass(String flightClass) {
    switch (flightClass.toLowerCase().trim()) {
      case 'economy':
        {
          return AppLocalizations.of(context)?.economic ?? flightClass;
        }
      case 'business':
        {
          return AppLocalizations.of(context)?.business ?? flightClass;
        }

      default:
        {
          return flightClass;
        }
    }
  }

  String dateFormatter(String date) =>
      DateFormat('EEE, dd MMM').format(DateFormat('dd/MM/y').parse(date));
}
