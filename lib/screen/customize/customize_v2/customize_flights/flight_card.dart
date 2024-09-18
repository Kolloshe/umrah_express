import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/custom_extension.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/model/customize_models/flights_model/flights_listing_model.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'change_flight/change_flight_listing.dart';

class FlightCard extends StatefulWidget {
  const FlightCard({super.key});

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return _buildFlightCollection();
  }

  Widget _buildFlightCollection() {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        boxShadow: [_staticVar.shadow],
        color: _staticVar.cardcolor,
        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
      ),
      child: Column(
        children: [
          Container(
            //  padding: EdgeInsets.all(_staticVar.defaultPadding),
            decoration: BoxDecoration(
              boxShadow: [_staticVar.shadow],
              color: _staticVar.cardcolor,
              borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    context
                        .read<CustomizeController>()
                        .serviceManager(action: "remove", type: "transfer");
                  },
                  child: Text(
                    AppLocalizations.of(context)?.departureInformation ?? "رحله الذهاب",
                    style: TextStyle(
                      fontSize: _staticVar.subTitleFontSize.sp,
                      color: _staticVar.primaryColor,
                      fontWeight: _staticVar.titleFontWeight,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                for (int i = 0;
                    i <
                        (context
                                    .read<CustomizeController>()
                                    .packageCustomize
                                    ?.result
                                    ?.flight
                                    ?.from
                                    ?.itinerary ??
                                <Itinerary>[])
                            .length;
                    i++) ...[
                  _buildflightCard(
                      (context
                              .read<CustomizeController>()
                              .packageCustomize
                              ?.result
                              ?.flight
                              ?.from
                              ?.itinerary ??
                          <Itinerary>[])[i],
                      context
                              .read<CustomizeController>()
                              .packageCustomize
                              ?.result
                              ?.flight
                              ?.from
                              ?.numstops ??
                          0,
                      i,
                      context
                              .read<CustomizeController>()
                              .packageCustomize
                              ?.result
                              ?.flight
                              ?.from
                              ?.carrierName ??
                          ""),
                  // SizedBox(height: 1.h)
                ],
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
            decoration: DottedDecoration(),
          ),
          SizedBox(height: 2.h),
          Container(
            //  padding: EdgeInsets.all(_staticVar.defaultPadding),
            decoration: BoxDecoration(
              //  boxShadow: [_staticVar.shadow],
              //  color: _staticVar.cardcolor,
              borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.returnInformation ?? "رحله العوده",
                  style: TextStyle(
                    fontSize: _staticVar.subTitleFontSize.sp,
                    color: _staticVar.primaryColor,
                    fontWeight: _staticVar.titleFontWeight,
                  ),
                ),
                SizedBox(height: 1.h),
                for (int i = 0;
                    i <
                        (context
                                    .read<CustomizeController>()
                                    .packageCustomize
                                    ?.result
                                    ?.flight
                                    ?.to
                                    ?.itinerary ??
                                <Itinerary>[])
                            .length;
                    i++) ...[
                  _buildflightCard(
                      (context
                              .read<CustomizeController>()
                              .packageCustomize
                              ?.result
                              ?.flight
                              ?.to
                              ?.itinerary ??
                          <Itinerary>[])[i],
                      context
                              .read<CustomizeController>()
                              .packageCustomize
                              ?.result
                              ?.flight
                              ?.to
                              ?.numstops ??
                          0,
                      i,
                      context
                              .read<CustomizeController>()
                              .packageCustomize
                              ?.result
                              ?.flight
                              ?.to
                              ?.carrierName ??
                          ""),
                  SizedBox(height: 1.h)
                ],
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
              width: 100.w,
              child: CustomBTN(
                  onTap: () async {
                    final data = await context.read<CustomizeController>().getFlightsListing();

                    if (data != null) {
                      final grouped = (data.data ?? <FlightData?>[])
                          .map((e) => e)
                          .groupBy((p0) => p0?.carrier?.name ?? '');
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeFlightListingScreen(
                                flightListing: data,
                                grouped: grouped,
                              )));

                      setState(() {});
                    }
                  },
                  title: AppLocalizations.of(context)?.changeFlights ?? "تغيير الرحله"))
        ],
      ),
    );
  }

  Widget _buildflightCard(Itinerary flight, num stops, index, String name) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: CachedNetworkImageProvider(
              flight.company?.logo ?? "",
            ),
            fit: BoxFit.cover),
      ),
      child: Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: _staticVar.cardcolor,
                              borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                            ),
                            child: CustomImage(
                              url: flight.company?.logo ?? "",
                              width: 20.w,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          SizedBox(
                              width: 30.w,
                              child: Text(
                                flight.company?.name ?? "",
                                maxLines: 1,
                              ))
                        ],
                      ),
                      if (index == 0)
                        Container(
                          decoration: BoxDecoration(
                              color: _staticVar.secondaryColor.withAlpha(150),
                              borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
                          padding: EdgeInsets.all(_staticVar.defaultPadding),
                          child: Text(
                            stops == 0
                                ? AppLocalizations.of(context)?.nonStop ?? ""
                                : AppLocalizations.of(context)?.flightStop(stops) ?? '$stops توقف',
                            style: TextStyle(
                                fontSize: _staticVar.subTitleFontSize.sp,
                                color: _staticVar.background),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        if (flight.departure?.date != null)
                          Text(
                            formatDate(flight.departure!.date!),
                            style: TextStyle(
                              fontSize: _staticVar.titleFontSize.sp,
                            ),
                          ),
                        Text(
                          flight.departure?.time ?? "",
                          style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp + 2,
                            fontWeight: _staticVar.titleFontWeight,
                          ),
                        ),
                        Text(
                          flight.departure?.locationId ?? "",
                          style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                          ),
                        ),
                      ]),
                      SizedBox(
                        width: 60.w,
                        height: 8.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: _staticVar.defaultPadding,
                                      right: _staticVar.defaultPadding,
                                    ),
                                    decoration: DottedDecoration(color: _staticVar.cardcolor),
                                  ),
                                ),
                                Icon(
                                  Icons.flight,
                                  color: _staticVar.primaryColor,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: _staticVar.defaultPadding,
                                      right: _staticVar.defaultPadding,
                                    ),
                                    decoration: DottedDecoration(color: _staticVar.cardcolor),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              durationToString(flight.flightTime?.toInt() ?? 0),
                              style: TextStyle(
                                  color: _staticVar.blackColor,
                                  fontSize: _staticVar.subTitleFontSize.sp),
                            )
                          ],
                        ),
                      ),
                      Column(children: [
                        if (flight.arrival?.date != null)
                          Text(
                            formatDate(flight.arrival!.date!),
                            style: TextStyle(
                              fontSize: _staticVar.titleFontSize.sp,
                            ),
                          ),
                        Text(
                          flight.arrival?.time ?? "",
                          style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp + 2,
                            fontWeight: _staticVar.titleFontWeight,
                          ),
                        ),
                        Text(
                          flight.arrival?.locationId ?? "",
                          style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                          ),
                        )
                      ]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 25.w,
                        child: Text(
                          flight.departure?.airport ?? "",
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: _staticVar.subTitleFontSize.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25.w,
                        child: Text(
                          flight.arrival?.airport ?? "",
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: _staticVar.subTitleFontSize.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  if ((flight.baggageInfo ?? <String>[]).isNotEmpty)
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                      decoration: BoxDecoration(
                          color: _staticVar.gray.withAlpha(150),
                          borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
                      child: Text(
                        (flight.baggageInfo ?? <String>[]).join(),
                        style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                      ),
                    )
                ],
              ))
          .asGlass(
              tintColor: _staticVar.cardcolor,
              blurX: 20,
              blurY: 20,
              clipBorderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
    );
  }

  String durationToString(int minutes) {
    final int hour = minutes ~/ 60;
    final int minute = minutes % 60;
    return "${hour.toString().padLeft(2, "0")} h ${minute.toString().padLeft(2, "0")} m ";
  }

  bool isItineraryEmpty(List<FromItinerary>? itinerary) {
    if (itinerary == null) {
      return false;
    } else if (itinerary.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  String formatDate(DateTime date) => DateFormat(DateFormat.ABBR_MONTH_DAY).format(date);
}
