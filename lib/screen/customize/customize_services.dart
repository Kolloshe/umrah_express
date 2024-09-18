import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/custom_extension.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/customize/customize_activities/activity_view.dart';
import 'package:umrah_by_lamar/screen/customize/customize_flights/flight_change_view.dart';
import 'package:umrah_by_lamar/screen/customize/customize_hotels/hotel_view.dart';
import 'package:umrah_by_lamar/screen/customize/customize_transfer/transfer_view.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controller/customize_controller.dart';
import '../../model/customize_models/flights_model/flights_listing_model.dart';
import '../widgets/custom_clipper.dart';
import 'customize_activities/activity_manager_view.dart';
import 'customize_esim/change_esim_view.dart';
import 'customize_esim/esim_view.dart';
import 'customize_flights/flight_view.dart';
import 'customize_flights/selected_flight_details_view.dart';
import 'customize_hotels/change_hotel_view.dart';
import 'customize_hotels/change_room_view.dart';
import 'customize_transfer/change_transfer.dart';

class CustomizeServices extends StatefulWidget {
  const CustomizeServices({super.key});

  @override
  State<CustomizeServices> createState() => _CustomizeServicesState();
}

class _CustomizeServicesState extends State<CustomizeServices> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomizeController>(builder: (context, data, child) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 15.h),
        primary: true,
        child: Padding(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 20.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                      color: _staticVar.primaryColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                AppLocalizations.of(context)?.yourDepartureFlight ?? 'Your departure flight',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(height: 2.h),
              data.packageCustomize?.result?.flight == null
                  ? _buildTiketContainer(
                      child: _buildNoSectionText(AppLocalizations.of(context)?.flight ?? "Flight"),
                      oprations: [
                          GestureDetector(
                            onTap: () async {
                              data.serviceManager(action: 'add', type: 'flight');
                            },
                            child: Container(
                                padding: EdgeInsets.all(_staticVar.defaultPadding),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                                    border: Border.all(color: _staticVar.gray)),
                                child: Icon(
                                  Icons.add,
                                  color: _staticVar.gray,
                                )),
                          )
                        ])
                  : _buildTiketContainer(
                      child: FlightView(
                        flight: data.packageCustomize!.result!.flight!.from!,
                        tripStart: data.packageCustomize!.result!.flight?.tripStart ?? '',
                      ),
                      oprations: [
                          GestureDetector(
                            onTap: () async {
                              final result = await data.getFlightsListing();
                              if (!mounted) return;
                              if (result != null) {
                                final grouped = (result.data ?? <FlightData?>[])
                                    .map((e) => e)
                                    .groupBy((p0) => p0?.carrier?.name ?? '');
                                if (!mounted) return;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        FlightChangeView(data: result, grouped: grouped)));
                              }
                            },
                            child: Image.asset(
                              'assets/icons/change.png',
                              width: 7.w,
                              color: _staticVar.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FlightDetials(
                                        flightFromCustomize: data.packageCustomize?.result?.flight,
                                      )));
                            },
                            child: Image.asset(
                              'assets/icons/tickets.png',
                              width: 7.w,
                              color: _staticVar.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              data.serviceManager(action: 'remove', type: 'flight');
                            },
                            child: Image.asset(
                              'assets/icons/delete.png',
                              width: 7.w,
                              color: _staticVar.primaryColor,
                            ),
                          ),
                        ]),
              SizedBox(height: 1.h),
              Text(
                AppLocalizations.of(context)?.yourhotel ?? 'Your hotel',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(height: 2.h),
              (data.packageCustomize?.result?.hotels == null ||
                      (data.packageCustomize?.result?.hotels ?? []).isEmpty)
                  ? _buildTiketContainer(
                      child: _buildNoSectionText(AppLocalizations.of(context)?.hotels ?? "Hotels"),
                      oprations: [
                          GestureDetector(
                            onTap: () async {
                              data.serviceManager(action: 'add', type: 'hotel');
                            },
                            child: Container(
                                padding: EdgeInsets.all(_staticVar.defaultPadding),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                                    border: Border.all(color: _staticVar.gray)),
                                child: Icon(
                                  Icons.add,
                                  color: _staticVar.gray,
                                )),
                          )
                        ])
                  : _buildTiketContainer(
                      child: Column(
                        children: [
                          for (var hotel in data.packageCustomize!.result!.hotels!)
                            HotelView(hotel: hotel)
                        ],
                      ),
                      oprations: [
                          GestureDetector(
                            onTap: () async {
                              final result = await context
                                  .read<CustomizeController>()
                                  .getHotelListing(
                                      checkIn: (data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                              .first
                                              .checkIn ??
                                          DateTime.now(),
                                      checkOut: (data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                              .first
                                              .checkOut ??
                                          DateTime.now(),
                                      hotelID: (data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                              .first
                                              .id ??
                                          0,
                                      star:

                                          //  (data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                          //         .first
                                          //         .starRating ??
                                          '');

                              if (result) {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const ChangeHotelView()));
                              }
                            },
                            child: Image.asset(
                              'assets/icons/hotel.png',
                              width: 7.w,
                              color: _staticVar.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if ((data.packageCustomize?.result?.hotels ?? <Hotel>[]).isNotEmpty) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ChangeRoomView(
                                          hotel:
                                              (data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                                  .first,
                                          hotelKey: "0",
                                        )));
                              }
                            },
                            child: Image.asset(
                              'assets/icons/bed.png',
                              width: 7.w,
                              color: _staticVar.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              data.serviceManager(action: 'remove', type: 'hotel');
                            },
                            child: Image.asset(
                              'assets/icons/delete.png',
                              width: 7.w,
                              color: _staticVar.primaryColor,
                            ),
                          ),
                        ]),
              SizedBox(height: 1.h),
              Text(
                AppLocalizations.of(context)?.yourActivity ?? 'Your activity',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(height: 2.h),
              (data.packageCustomize?.result?.activities == null ||
                      (data.packageCustomize?.result?.activities ?? {}).isEmpty)
                  ? _buildTiketContainer(
                      child: _buildNoSectionText(
                          AppLocalizations.of(context)?.activities ?? "Activities"),
                      oprations: [
                          GestureDetector(
                            onTap: () async {
                              data.serviceManager(action: 'add', type: 'activities');
                            },
                            child: Container(
                                padding: EdgeInsets.all(_staticVar.defaultPadding),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                                    border: Border.all(color: _staticVar.gray)),
                                child: Icon(
                                  Icons.add,
                                  color: _staticVar.gray,
                                )),
                          )
                        ])
                  : _buildTiketContainer(
                      child: ActivityView(
                          activities: data.packageCustomize!.result!.activities?.values
                                  .map((e) => e)
                                  .toList()
                                  .expand((element) => element)
                                  .toList() ??
                              <Activity>[]),
                      oprations: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const ActivityManager()));
                            },
                            child: Image.asset(
                              'assets/icons/activities.png',
                              width: 7.w,
                              color: _staticVar.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              data.serviceManager(action: 'remove', type: 'activities');
                            },
                            child: Image.asset(
                              'assets/icons/delete.png',
                              width: 7.w,
                              color: _staticVar.primaryColor,
                            ),
                          ),
                        ]),
              SizedBox(height: 1.h),
              Text(
                AppLocalizations.of(context)?.yourTransfer ?? 'Your transfer',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(height: 2.h),
              (data.packageCustomize?.result?.transfer == null ||
                      (data.packageCustomize?.result?.transfer ?? []).isEmpty)
                  ? _buildTiketContainer(
                      child:
                          _buildNoSectionText(AppLocalizations.of(context)?.transfer ?? "Transfer"),
                      oprations: [
                          GestureDetector(
                            onTap: () async {
                              data.serviceManager(action: 'add', type: 'transfer');
                            },
                            child: Container(
                                padding: EdgeInsets.all(_staticVar.defaultPadding),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                                    border: Border.all(color: _staticVar.gray)),
                                child: Icon(
                                  Icons.add,
                                  color: _staticVar.gray,
                                )),
                          )
                        ])
                  : _buildTiketContainer(
                      child: TransferView(
                          transfer: data.packageCustomize?.result?.transfer ?? <Transfer>[]),
                      oprations: [
                        GestureDetector(
                          onTap: () async {
                            final result = await data.getTransferListing();
                            if (!mounted) return;
                            if (result) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ChangeTransferView()));
                            }
                          },
                          child: Image.asset(
                            'assets/icons/transfer.png',
                            width: 7.w,
                            color: _staticVar.primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            data.serviceManager(action: 'remove', type: 'transfer');
                          },
                          child: Image.asset(
                            'assets/icons/delete.png',
                            width: 7.w,
                            color: _staticVar.primaryColor,
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 1.h),
              Text(
                AppLocalizations.of(context)?.yourESimCard ?? 'Your Esim card',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              SizedBox(height: 2.h),
              data.packageCustomize?.result?.esim == null
                  ? _buildTiketContainer(
                      child: _buildNoSectionText(
                          AppLocalizations.of(context)?.esimCard ?? "E-sim card"),
                      oprations: [
                          GestureDetector(
                            onTap: () async {
                              data.serviceManager(action: 'add', type: 'esim');
                            },
                            child: Container(
                                padding: EdgeInsets.all(_staticVar.defaultPadding),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                                    border: Border.all(color: _staticVar.gray)),
                                child: Icon(
                                  Icons.add,
                                  color: _staticVar.gray,
                                )),
                          )
                        ])
                  : _buildTiketContainer(
                      child: EsimView(esim: data.packageCustomize?.result?.esim),
                      oprations: [
                        GestureDetector(
                          onTap: () async {
                            final result =
                                await context.read<CustomizeController>().getEsimListing();

                            if (result) {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const ChangeEsimView()));
                            }
                          },
                          child: Image.asset(
                            'assets/icons/sim-card.png',
                            width: 7.w,
                            color: _staticVar.primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            data.serviceManager(action: 'remove', type: 'esim');
                          },
                          child: Image.asset(
                            'assets/icons/delete.png',
                            width: 7.w,
                            color: _staticVar.primaryColor,
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 1.h),
              data.packageCustomize?.result?.flight == null
                  ? const SizedBox()
                  : Text(
                      AppLocalizations.of(context)?.yourArrivalFlight ?? 'Your arrival flight',
                      style: TextStyle(
                          fontSize: _staticVar.titleFontSize.sp,
                          fontWeight: _staticVar.titleFontWeight),
                    ),
              SizedBox(height: 2.h),
              data.packageCustomize?.result?.flight == null
                  ? const SizedBox()
                  : _buildTiketContainer(
                      child: FlightView(
                        flight: data.packageCustomize!.result!.flight!.to!,
                        tripStart: data.packageCustomize!.result!.flight?.tripEnd ?? '',
                      ),
                      oprations: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FlightDetials(
                                        flightFromCustomize: data.packageCustomize?.result?.flight,
                                      )));
                            },
                            child: Image.asset(
                              'assets/icons/tickets.png',
                              width: 7.w,
                              color: _staticVar.primaryColor,
                            ),
                          ),
                        ]),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNoSectionText(String section) => Container(
        width: 100.w,
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text('$section ${AppLocalizations.of(context)!.removeSectionMsG} $section'),
        ),
      );

  Widget _buildTiketContainer({required Widget child, required List<Widget> oprations}) {
    return Column(
      children: [
        ClipPath(
          clipper: MyClipperForShadow(),
          child: Container(
            padding: const EdgeInsets.only(right: 1, bottom: 0, top: 1, left: 1),
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
            ),
            clipBehavior: Clip.hardEdge,
            child: ClipPath(
                clipper: MyClipper(),
                child: Container(
                    padding: const EdgeInsets.all(15), color: _staticVar.cardcolor, child: child)),
          ),
        ),
        SizedBox(
          width: 88.w,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 15, bottom: 5),
            child: fullWidthPath,
          ),
        ),
        ClipPath(
          clipper: MyClipper2ForShadow(),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Colors.grey.withOpacity(0.4),
              ),
              padding: const EdgeInsets.only(right: 1, bottom: 1, top: 0, left: 1),
              width: 100.w,
              height: 8.h,
              child: ClipPath(
                  clipper: MyClipper2(),
                  child: Container(
                      color: _staticVar.cardcolor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: oprations,
                      )))),
          //_spacer(0, 20),
        ),
        SizedBox(height: 1.h)
      ],
    );
  }

  Widget get fullWidthPath {
    return DottedBorder(
      customPath: (size) {
        return Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width, size.height);
      },
      color: Colors.grey.withOpacity(0.4),
      strokeWidth: 4,
      strokeCap: StrokeCap.round,
      dashPattern: const [0, 10],
      borderType: BorderType.Circle,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Container(
          height: 0,
          // color: Colors.red,
        ),
      ),
    );
  }
}
