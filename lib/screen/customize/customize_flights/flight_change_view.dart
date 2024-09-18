import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glass/glass.dart';
import 'package:intl/intl.dart';
import 'package:umrah_by_lamar/common/custom_extension.dart';

import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:umrah_by_lamar/model/customize_models/flights_model/flights_listing_model.dart';

import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_search_form_with_debouncer.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_btn.dart';
import 'selected_flight_details_view.dart';

class FlightChangeViewModel extends ChangeNotifier {
  Map<String, List<FlightData?>> flights = {};
  final Map<String, List<FlightData?>> grouped;

  FlightChangeViewModel(this.grouped) {
    loadFlightList();
  }

  void loadFlightList() {
    flights = grouped;
    notifyListeners();
  }

  void searchByAirline(String airline) {
    Map<String, List<FlightData?>> x = {};
    x.addEntries(
        grouped.filter((entry) => entry.key.toLowerCase().contains(airline.toLowerCase())));

    if (x.keys.isNotEmpty) {
      flights = x;
    } else {
      flights = grouped;
    }
    notifyListeners();
  }
}

class FlightChangeView extends StatelessWidget {
  final FlightsListingModel data;
  final bool? prebookFailed;
  final Map<String, List<FlightData?>> grouped;

  const FlightChangeView({
    Key? key,
    required this.data,
    required this.grouped,
    this.prebookFailed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlightChangeViewModel(grouped),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: StaticVar().cardcolor,
          elevation: 0.2,
          foregroundColor: StaticVar().primaryColor,
          title: Text(
            AppLocalizations.of(context)?.changeFlightAppbarTitle ?? '',
            style: TextStyle(fontSize: StaticVar().titleFontSize.sp),
          ),
          bottom: ((context
                          .read<PrebookController>()
                          .prebookResultModel
                          ?.data
                          ?.prebookDetails
                          ?.flights
                          ?.prebookSuccess ??
                      true) ==
                  false)
              ? PreferredSize(
                  preferredSize: Size.fromHeight(5.h),
                  child: Padding(
                    padding: EdgeInsets.all(StaticVar().defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: Text(
                              (AppLocalizations.of(context)?.thisFlightFailedToBookingPlease ?? "")
                                  .replaceAll(":", "")),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await context
                                .read<CustomizeController>()
                                .serviceManager(action: 'remove', type: 'flight');

                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppLocalizations.of(context)?.remove ?? "",
                            style: TextStyle(
                                color: StaticVar().primaryColor,
                                fontSize: StaticVar().titleFontSize.sp),
                          ),
                        )
                      ],
                    ),
                  ))
              : null,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: StaticVar().defaultPadding),
                decoration:
                    BoxDecoration(boxShadow: [StaticVar().shadow], color: StaticVar().cardcolor),
                padding: EdgeInsets.all(StaticVar().defaultPadding),
                width: 100.w,
                child: Row(
                  children: [
                    SizedBox(
                      width: 90.w,
                      child: CustomSearchFormDebouncer(
                        method: (v) {
                          context.read<FlightChangeViewModel>().searchByAirline(v);
                        },
                        controller: TextEditingController(),
                        title: 'Search by airlines',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: Consumer<FlightChangeViewModel>(
                  builder: (context, model, child) {
                    return ListView.builder(
                      itemCount: model.flights.keys.length,
                      itemBuilder: (context, index) {
                        var career = model.flights.keys.elementAt(index);
                        return EXa(
                          collapsed: (model.flights[career] ?? <FlightData>[]).first,
                          expanded: (model.flights[career] ?? <FlightData>[]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EXa extends StatefulWidget {
  const EXa({
    Key? key,
    required this.collapsed,
    required this.expanded,
  }) : super(key: key);

  final FlightData? collapsed;
  final List<FlightData?> expanded;

  @override
  State<EXa> createState() => _EXaState();
}

class _EXaState extends State<EXa> {
  final controller = ExpandableController();
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: false,
      child: Expandable(
        controller: controller,
        collapsed: _buildFlightCollection(widget.collapsed!, true),
        expanded: Column(
          children: [
            GestureDetector(
              onTap: () {
                controller.toggle();
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(right: _staticVar.defaultPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: _staticVar.cardcolor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        offset: const Offset(1, 2),
                        blurRadius: 7),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomImage(
                          url: widget.collapsed!.from?.carrierImage ?? '',
                          width: 18.w,
                          height: 40,
                        ),
                        SizedBox(width: 2.w),
                        Text(widget.collapsed!.carrier?.label ?? '')
                      ],
                    ),
                    const Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
            ),
            for (var data in widget.expanded) _buildFlightCollection(data!, false)
          ],
        ),
      ),
    );
  }

  Widget _buildFlightCollection(FlightData flight, bool isCollapsed) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: _staticVar.defaultPadding * 2,
        horizontal: _staticVar.defaultPadding,
      ),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
      ),
      child: Column(
        children: [
          if (isCollapsed) ...[
            CustomImage(url: flight.from?.carrierImage ?? ""),
            SizedBox(height: 2.h),
          ],
          Column(
            children: [
              Text(
                AppLocalizations.of(context)?.yourDepartureFlight ?? "الذهاب",
                style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
              ),
              for (int i = 0; i < (flight.from?.itinerary ?? <FromItinerary>[]).length; i++) ...[
                _buildflightCard(
                  (flight.from?.itinerary ?? <FromItinerary>[])[i],
                  flight.from?.stops?.length ?? 0,
                  i,
                ),
              ],
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding * 3),
            decoration: DottedDecoration(),
          ),
          Column(
            children: [
              Text(
                AppLocalizations.of(context)?.yourArrivalFlight ?? "العوده",
                style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
              ),
              for (int i = 0; i < (flight.to?.itinerary ?? <FromItinerary>[]).length; i++) ...[
                _buildflightCard(
                  (flight.to?.itinerary ?? <FromItinerary>[])[i],
                  (flight.to?.stops ?? []).length,
                  i,
                ),
              ],
            ],
          ),
          SizedBox(height: 2.h),
          if (((flight.from?.itinerary ?? []).first.baggageInfo ?? <String>[]).isNotEmpty)
            Container(
              width: 100.w,
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              decoration: BoxDecoration(
                  color: _staticVar.gray.withAlpha(150),
                  borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
              child: Text(
                ((flight.from?.itinerary ?? []).first.baggageInfo ?? <String>[]).join(),
                style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
              ),
            ),
          SizedBox(height: 1.h),
          if (!isCollapsed)
            SizedBox(
                width: 100.w,
                child: CustomBTN(
                    onTap: () async {
                      final result =
                          await context.read<CustomizeController>().changeFlights(flight.flightId);

                      if (result) {
                        Navigator.of(context).pop();
                      }
                    },
                    title: AppLocalizations.of(context)?.select ?? "تغيير الرحله")),
          SizedBox(height: 1.h),
          if (isCollapsed)
            GestureDetector(
                onTap: () {
                  controller.toggle();
                  setState(() {});
                },
                child: Text(
                  AppLocalizations.of(context)?.showMore ?? "عرض المزيد ...",
                  style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                ))
        ],
      ),
    );
  }

  Widget _buildflightCard(FromItinerary flight, num stops, index) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomImage(
              url: flight.company?.logo ?? "",
              boxFit: BoxFit.cover,
            )),
        Container(
          margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _staticVar.cardcolor,
                            borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                          ),
                          child: CustomImage(
                            withRadius: true,
                            url: flight.company?.logo ?? "",
                            width: 20.w,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        SizedBox(
                            width: 30.w,
                            child: Text(
                              flight.company?.name ?? "",
                              maxLines: 1,
                              style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                            ))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (index == 0)
                          Container(
                            decoration: BoxDecoration(
                                color: _staticVar.secondaryColor.withAlpha(150),
                                borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
                            padding: EdgeInsets.all(_staticVar.defaultPadding),
                            child: Text(
                              AppLocalizations.of(context)?.flightStop(stops) ?? "$stops توقف",
                              style: TextStyle(
                                  fontSize: _staticVar.subTitleFontSize.sp,
                                  color: _staticVar.background),
                            ),
                          ),
                        Text(
                            "${AppLocalizations.of(context)?.flightNo ?? "رقم الرحله: "} ${flight.flightNo ?? ""}")
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
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
                    )
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
                                margin: EdgeInsets.only(right: _staticVar.defaultPadding),
                                decoration: DottedDecoration(),
                              ),
                            ),
                            Icon(
                              Icons.flight,
                              color: _staticVar.gray,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: _staticVar.defaultPadding),
                                decoration: DottedDecoration(),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          durationToString(flight.flightTime?.toInt() ?? 0),
                          style: TextStyle(
                              color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp),
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
              SizedBox(height: 2.h),
            ],
          ).asGlass(
              blurX: 25,
              blurY: 25,
              clipBorderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
        ),
      ],
    );
  }

  String durationToString(int minutes) {
    final int hour = minutes ~/ 60;
    final int minute = minutes % 60;
    return " h ${hour.toString().padLeft(2, "0")}  m ${minute.toString().padLeft(2, "0")} ";
  }

  String formatDate(DateTime date) => DateFormat(DateFormat.ABBR_MONTH_DAY).format(date);
}
