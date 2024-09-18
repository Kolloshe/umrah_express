import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../common/utility_var.dart';
import '../../../model/search_models/search_result_models/search_result_model.dart';
import '../../customize/customize_hotels/individual_hotel_view/individual_hotel_room_selection.dart';

class HotelResultScreen extends StatefulWidget {
  const HotelResultScreen({super.key});

  @override
  State<HotelResultScreen> createState() => _HotelResultScreenState();
}

class _HotelResultScreenState extends State<HotelResultScreen> {
  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.hotels ?? "Hotels",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        elevation: 0.3,
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<PackSearchController>(builder: (context, data, child) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(_staticVar.defaultPadding),
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
                      data.searchResultModel?.data?.searchData?.toCity ?? "",
                      style: TextStyle(
                          fontWeight: _staticVar.titleFontWeight,
                          fontSize: _staticVar.subTitleFontSize.sp),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (var hotel in data.searchResultModel?.data?.packages ?? <Package>[])
                      _buildHotelCard(hotel)
                  ],
                ),
              ),
            ],
          );
        }),
      )),
    );
  }

  String dateFormatter(String date) =>
      DateFormat('EEE, dd MMM').format(DateFormat('dd/MM/y').parse(date));

  Widget _buildHotelCard(Package hotel) {
    return Container(
      margin: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            url: hotel.hotelDetails?.image ?? '',
            width: 100.w,
            height: 20.h,
            boxFit: BoxFit.cover,
            withHalfRadius: true,
          ),
          SizedBox(height: 1.h),
          InkWell(
            onTap: () {
              log(jsonEncode(hotel.toJson()));
            },
            child: Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.hotelDetails?.name ?? '',
                    style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                      fontWeight: _staticVar.titleFontWeight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: _staticVar.gray,
                      ),
                      Text(
                        hotel.hotelDetails?.address ?? '',
                        style: TextStyle(
                            color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                    width: 50.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.mapView ?? "Map View",
                          style: TextStyle(
                              color: _staticVar.primaryColor,
                              fontSize: _staticVar.titleFontSize.sp),
                        ),
                        Text(
                          AppLocalizations.of(context)?.streetview ?? "Street View",
                          style: TextStyle(
                              color: _staticVar.primaryColor,
                              fontSize: _staticVar.titleFontSize.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.roomStartingFrom ?? "Starting from",
                            style: TextStyle(
                                color: Colors.grey, fontSize: _staticVar.titleFontSize.sp),
                          ),
                          Text(
                            '${hotel.hotelDetails?.rateFrom ?? ""}  ${UtilityVar.localizeCurrency(val: hotel.sellingCurrency ?? "AED")}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: _staticVar.subTitleFontSize.sp),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.hotelStars ?? 'Stars',
                            style: TextStyle(
                                color: Colors.grey, fontSize: _staticVar.titleFontSize.sp),
                          ),
                          Row(
                            children: [
                              for (int s = 0;
                                  s < (int.tryParse(hotel.hotelDetails?.starRating ?? "") ?? 1);
                                  s++)
                                Text(
                                  "★",
                                  style: TextStyle(
                                      color: _staticVar.yellowColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: _staticVar.subTitleFontSize.sp),
                                )
                            ],
                          )
                        ],
                      ),
                      CustomBTN(
                          onTap: () async {
                            final result = await context
                                .read<CustomizeController>()
                                .customizePackage(hotel.id ?? "");

                            if (result == false) return;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => IndividualHotelRoomSelection(
                                      roomLimit: (hotel.hotelDetails?.roomsRequired ?? 0).toInt(),
                                    )));
                          },
                          title: AppLocalizations.of(context)?.bookNow ?? "Book now")
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
