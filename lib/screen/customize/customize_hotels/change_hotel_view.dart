import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/screen/customize/customize_hotels/change_room_view.dart';
import 'package:umrah_by_lamar/screen/customize/customize_hotels/hotel_details_view.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_search_form_with_debouncer.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../model/customize_models/hotel_model/hotel_listing_model.dart';
import '../../widgets/custom_map_view.dart';
import '../../widgets/street_view_screen.dart';

class ChangeHotelView extends StatefulWidget {
  const ChangeHotelView({super.key});

  @override
  State<ChangeHotelView> createState() => _ChangeHotelViewState();
}

class _ChangeHotelViewState extends State<ChangeHotelView> {
  final _staticVar = StaticVar();
  final hotelSearchController = TextEditingController();

  @override
  void dispose() {
    hotelSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        elevation: 0.3,
        title: Text(
          AppLocalizations.of(context)?.hotels ?? 'Hotels',
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<CustomizeController>(builder: (context, data, child) {
          return Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: _staticVar.cardcolor, boxShadow: [_staticVar.shadow]),
                width: 100.w,
                child: CustomSearchFormDebouncer(
                    controller: hotelSearchController,
                    title:
                        AppLocalizations.of(context)?.searchByHotelName ?? 'Search by hotel name',
                    method: (v) {}),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: ListView(
                  children: [
                    for (var hotel in data.hotelListModel?.hotelData ?? <HotelData>[])
                      _buildHotel(hotel)
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHotel(HotelData hotel) {
    return Container(
      margin: EdgeInsets.all(_staticVar.defaultPadding),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HotelDetailsView(hotelData: hotel)));
            },
            child: CustomImage(
              url: hotel.image ?? '',
              width: 30.w,
              height: 21.h,
              boxFit: BoxFit.cover,
              withRadius: true,
            ),
          ),
          SizedBox(width: 2.w),
          SizedBox(
            width: 55.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 61.w,
                  child: Text(
                    hotel.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: _staticVar.subTitleFontSize.sp,
                        fontWeight: _staticVar.titleFontWeight),
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    for (int i = 0; i < (int.tryParse((hotel.starRating ?? '0')) ?? 1); i++)
                      Text(
                        '★',
                        style: TextStyle(color: _staticVar.yellowColor),
                      )
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: _staticVar.blackColor,
                    ),
                    SizedBox(
                        width: 50.w,
                        child: Text(
                          " ${hotel.address ?? ''}",
                          style: TextStyle(
                            fontSize: _staticVar.subTitleFontSize.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    if (hotel.latitude == null && hotel.longitude == null) {
                      _staticVar.showToastMessage(
                          message: "Map view is unavailable for this hotel");
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomMapView(
                                lat: double.tryParse(hotel.latitude ?? "") ?? 0,
                                lon: double.tryParse(hotel.longitude ?? "") ?? 0,
                              )));
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)?.mapView ?? "Map view",
                    style: TextStyle(
                        color: _staticVar.primaryColor,
                        fontSize: _staticVar.subTitleFontSize.sp,
                        decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    if (hotel.latitude == null && hotel.longitude == null) {
                      _staticVar.showToastMessage(
                          message: "Street View is unavailable for this hotel");
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CustomStreetView(
                                lat: double.tryParse(hotel.latitude ?? "") ?? 0,
                                lon: double.tryParse(hotel.longitude ?? "") ?? 0,
                                isFromCus: true,
                                isfromHotel: false,
                              )));
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)?.streetview ?? "Street view",
                    style: TextStyle(
                        color: _staticVar.primaryColor,
                        fontSize: _staticVar.subTitleFontSize.sp,
                        decoration: TextDecoration.underline),
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${hotel.rooms?[0][0].type ?? ''} ${hotel.rooms?[0][0].amountChange ?? 0} ${hotel.currency ?? UtilityVar.genCurrency}",
                      style: TextStyle(
                          color: (hotel.rooms?[0][0].type ?? '') == '-'
                              ? _staticVar.greenColor
                              : _staticVar.redColor,
                          fontSize: _staticVar.subTitleFontSize.sp,
                          fontWeight: _staticVar.titleFontWeight),
                    )),
                SizedBox(height: 1.h),
                SizedBox(
                    width: 100.w,
                    child: CustomBTN(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangeRoomView(
                                    hotelData: hotel,
                                    hotelKey: "0",
                                  )));
                        },
                        title: AppLocalizations.of(context)?.select ?? "Select"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
