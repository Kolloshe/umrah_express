import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/model/customize_models/flights_model/flights_listing_model.dart';
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

class FlightDetials extends StatefulWidget {
  const FlightDetials({
    super.key,
    this.flight,
    this.flightFromCustomize,
    this.fromFlightSearch = false,
  });

  final FlightData? flight;
  final Flight? flightFromCustomize;
  final bool fromFlightSearch;

  @override
  State<FlightDetials> createState() => _FlightDetialsState();
}

class _FlightDetialsState extends State<FlightDetials> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        elevation: 0.3,
        title: Text(
          AppLocalizations.of(context)?.flightDetails ?? 'Flight details',
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp, color: _staticVar.blackColor),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          child: ListView(
            padding: EdgeInsets.only(
                bottom: widget.fromFlightSearch
                    ? _staticVar.defaultPadding * 14
                    : widget.flight == null
                        ? _staticVar.defaultPadding
                        : _staticVar.defaultPadding * 14),
            children: [
              if (widget.flight != null) ...[
                _buildCard(widget.flight!.from!,
                    AppLocalizations.of(context)?.departureInformation ?? "Departure information"),
                const Divider(),
                _buildCard(widget.flight!.to!,
                    AppLocalizations.of(context)?.returnInformation ?? "Return information"),
              ],
              if (widget.flightFromCustomize != null) ...[
                _buildCardV2(widget.flightFromCustomize!.from!,
                    AppLocalizations.of(context)?.departureInformation ?? "Departure information"),
                const Divider(),
                _buildCardV2(widget.flightFromCustomize!.to!,
                    AppLocalizations.of(context)?.returnInformation ?? "Return information"),
              ]
            ],
          ),
        ),
      ),
      bottomSheet: widget.fromFlightSearch
          ? Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding * 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${widget.flightFromCustomize?.tripStart ?? ""} - ${widget.flightFromCustomize?.tripEnd ?? ""}",
                            style: TextStyle(
                              color: _staticVar.primaryColor,
                              fontWeight: _staticVar.titleFontWeight,
                            ),
                          ),
                          Text(
                            "${widget.flightFromCustomize?.from?.departureDate ?? ""} - ${widget.flightFromCustomize?.to?.departureDate ?? ""}",
                            style: TextStyle(
                              color: _staticVar.primaryColor,
                              fontWeight: _staticVar.titleFontWeight,
                            ),
                          )
                        ],
                      ),
                      Text(
                        "${context.read<CustomizeController>().packageCustomize?.result?.totalAmount ?? ""} ${UtilityVar.localizeCurrency(val: context.read<CustomizeController>().packageCustomize?.result?.sellingCurrency ?? '')}",
                        style: TextStyle(
                          color: _staticVar.primaryColor,
                          fontWeight: _staticVar.titleFontWeight,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                      width: 100.w,
                      child: CustomBTN(
                          onTap: () async {
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
                          title: AppLocalizations.of(context)?.bookNow ?? ""))
                ],
              ),
            )
          : widget.flight == null
              ? const SizedBox()
              : Container(
                  width: 100.w,
                  padding: EdgeInsets.all(_staticVar.defaultPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            Text(
                              "${widget.flight?.from?.departureDate ?? widget.flightFromCustomize?.from?.departureDate ?? ''} - ${widget.flight?.to?.arrivalDate ?? widget.flightFromCustomize?.to?.arrivalDate ?? ''}",
                              style: TextStyle(
                                fontSize: _staticVar.titleFontSize.sp,
                                color: _staticVar.primaryColor,
                                fontWeight: _staticVar.titleFontWeight,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              "${widget.flight?.from?.departureCity ?? widget.flightFromCustomize?.from?.departure ?? ''} - ${widget.flight?.to?.arrivalCity ?? widget.flightFromCustomize?.to?.arrival ?? ''}",
                              style: TextStyle(
                                fontSize: _staticVar.titleFontSize.sp,
                                color: _staticVar.primaryColor,
                                fontWeight: _staticVar.titleFontWeight,
                              ),
                            ),
                          ]),
                          widget.flight == null
                              ? const SizedBox()
                              : SizedBox(
                                  child: Text(
                                  ' ${(AppLocalizations.of(context)?.packagePriceDifference ?? "price difference").replaceFirst('Package', '')}  ${widget.flight?.priceDiff ?? ''}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, color: _staticVar.primaryColor),
                                ))
                        ],
                      ),
                      SizedBox(height: 1.h),
                      widget.flight == null
                          ? const SizedBox()
                          : SizedBox(
                              width: 100.w,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    final result = await context
                                        .read<CustomizeController>()
                                        .changeFlights(widget.flight!.flightId);

                                    if (result) {
                                      Navigator.of(context)
                                        ..pop()
                                        ..pop();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: _staticVar.greenColor),
                                  child: Text(
                                    AppLocalizations.of(context)!.select,
                                    style: TextStyle(
                                      fontSize: _staticVar.subTitleFontSize.sp,
                                    ),
                                  )),
                            ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCard(FlightFrom flight, String title) {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
          color: _staticVar.cardcolor,
          borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
          boxShadow: [_staticVar.shadow]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.w,
            height: 4.h,
            padding: EdgeInsets.all(_staticVar.defaultPadding),
            color: _staticVar.gray.withAlpha(50),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style:
                  TextStyle(color: _staticVar.primaryColor, fontWeight: _staticVar.titleFontWeight),
            ),
          ),
          SizedBox(height: 1.h),
          Text(DateFormat('EEEE, MMM dd').format(flight.departureFdate ?? DateTime.now())),
          SizedBox(height: 1.h),
          Text(
            '${flight.departureCity}(${flight.departureCityCode}) > ${flight.arrivalCity} (${flight.arrivalCityCode})',
          ),
          SizedBox(height: 1.h),
          Text(flight.travelTime ?? ''),
          SizedBox(height: 1.h),
          const Divider(),
          SizedBox(height: 1.h),
          for (var itinerary in flight.itinerary ?? <FromItinerary>[]) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImage(url: itinerary.company?.logo ?? '', width: 15.w),
                SizedBox(width: 3.w),
                Text(
                    "${(widget.flight!.carrier?.name ?? '')} - ${itinerary.company!.operatingCarrier ?? ""} ${itinerary.flightNo}"),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateFormat('MMMM d ', UtilityVar.genLanguage).format(itinerary.departure?.date ?? DateTime.now())} ${itinerary.departure?.time ?? ""}',
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    Text(
                      '${itinerary.departure?.city ?? ''} (${itinerary.departure?.locationId ?? ''})',
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    Text(
                      itinerary.departure?.airport ?? '',
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM d ', UtilityVar.genLanguage)
                              .format(itinerary.arrival?.date ?? DateTime.now()) +
                          (itinerary.arrival?.time ?? ''),
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    Text(
                      itinerary.arrival?.city ?? '' ' (${itinerary.arrival?.locationId ?? ''})',
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    SizedBox(
                      width: 25.w,
                      child: Text(
                        itinerary.arrival?.airport ?? '',
                        style: TextStyle(
                          fontSize: _staticVar.subTitleFontSize.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      minutesToTimeOfDay((itinerary.flightTime ?? 0).toInt()).toString(),
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    Text(
                      itinerary.cabinClass == 'C'
                          ? AppLocalizations.of(context)!.business
                          : AppLocalizations.of(context)!.economic,
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 1.h),
            (itinerary.baggageInfo ?? []).isNotEmpty
                ? Text(
                    '${AppLocalizations.of(context)!.baggageDetails} : ${(itinerary.baggageInfo ?? []).join(',')}',
                    style: TextStyle(
                        color: _staticVar.primaryColor, fontSize: _staticVar.subTitleFontSize.sp),
                  )
                : const SizedBox(),
            SizedBox(height: 2.h),
            Container(
              width: 100.w,
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              decoration: BoxDecoration(
                color: _staticVar.gray.withAlpha(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)?.changeIn ?? "Change in"} ${itinerary.arrival?.city ?? ''} (${itinerary.arrival?.locationId ?? ""})',
                    style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "${AppLocalizations.of(context)!.waitingTime} - ${durationToString((itinerary.layover ?? 0).toInt())}",
                    style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                  )
                ],
              ),
            )
          ],
        ],
      ),
    );
  }

  String minutesToTimeOfDay(int minutes) {
    Duration duration = Duration(minutes: minutes);
    List<String> parts = duration.toString().split(':');
    var time = "${parts[0]} : ${parts[1]}";
    TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    return time;
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return ' ${parts[0].padLeft(2, '0')}h ${parts[1].padLeft(2, '0')}m';
  }

  Widget _buildCardV2(From flight, String title) {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
          color: _staticVar.cardcolor,
          borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
          boxShadow: [_staticVar.shadow]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.w,
            height: 4.h,
            padding: EdgeInsets.all(_staticVar.defaultPadding),
            color: _staticVar.gray.withAlpha(50),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style:
                  TextStyle(color: _staticVar.primaryColor, fontWeight: _staticVar.titleFontWeight),
            ),
          ),
          SizedBox(height: 1.h),
          Text(DateFormat('EEEE, MMM dd').format(flight.departureFdate ?? DateTime.now())),
          SizedBox(height: 1.h),
          Text(
            '${flight.departure} > ${flight.arrival}',
          ),
          SizedBox(height: 1.h),
          Text(flight.travelTime ?? ''),
          SizedBox(height: 1.h),
          const Divider(),
          SizedBox(height: 1.h),
          for (var itinerary in flight.itinerary ?? <Itinerary>[]) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImage(url: itinerary.company?.logo ?? '', width: 15.w),
                SizedBox(width: 3.w),
                Text(
                    "${(widget.flightFromCustomize!.carrier?.name ?? '')} - ${itinerary.company!.operatingCarrier ?? ""} ${itinerary.flightNo}"),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateFormat('MMMM d ', UtilityVar.genLanguage).format(itinerary.departure?.date ?? DateTime.now())} ${itinerary.departure?.time ?? ""}',
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    Text(
                      '${itinerary.departure?.city ?? ''} (${itinerary.departure?.locationId ?? ''})',
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    Text(
                      itinerary.departure?.airport ?? '',
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM d ', UtilityVar.genLanguage)
                              .format(itinerary.arrival?.date ?? DateTime.now()) +
                          (itinerary.arrival?.time ?? ''),
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    Text(
                      itinerary.arrival?.city ?? '' ' (${itinerary.arrival?.locationId ?? ''})',
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    SizedBox(
                      width: 25.w,
                      child: Text(
                        itinerary.arrival?.airport ?? '',
                        style: TextStyle(
                          fontSize: _staticVar.subTitleFontSize.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      minutesToTimeOfDay((itinerary.flightTime ?? 0).toInt()).toString(),
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                    Text(
                      itinerary.cabinClass == 'C'
                          ? AppLocalizations.of(context)!.business
                          : AppLocalizations.of(context)!.economic,
                      style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 1.h),
            (itinerary.baggageInfo ?? []).isNotEmpty
                ? Text(
                    '${AppLocalizations.of(context)!.baggageDetails} : ${(itinerary.baggageInfo ?? []).join(',')}',
                    style: TextStyle(
                        color: _staticVar.primaryColor, fontSize: _staticVar.subTitleFontSize.sp),
                  )
                : const SizedBox(),
            SizedBox(height: 2.h),
            Container(
              width: 100.w,
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              decoration: BoxDecoration(
                color: _staticVar.gray.withAlpha(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)?.changeIn ?? "Change in"} ${itinerary.arrival?.city ?? ''} (${itinerary.arrival?.locationId ?? ""})',
                    style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "${AppLocalizations.of(context)!.waitingTime} - ${durationToString((itinerary.layover ?? 0).toInt())}",
                    style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                  )
                ],
              ),
            )
          ],
        ],
      ),
    );
  }
}
