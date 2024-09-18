import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/screen/customize/customize_v2/customize_hotel/hotel_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../model/customize_models/hotel_model/hotel_listing_model.dart';
import '../../../../widgets/custom_btn.dart';
import '../../../../widgets/custom_image.dart';

class ChangeHotelListing extends StatefulWidget {
  const ChangeHotelListing({super.key});

  @override
  State<ChangeHotelListing> createState() => _ChangeHotelListingState();
}

class _ChangeHotelListingState extends State<ChangeHotelListing> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: _staticVar.primaryColor,
        title: Text(
          AppLocalizations.of(context)?.hotels ?? "الفنادق",
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          child: Consumer<CustomizeController>(builder: (context, data, child) {
            return ListView(
              children: [
                for (var hotel in data.hotelListModel?.hotelData ?? <HotelData>[])
                  _buildPackageHotel(hotel)
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPackageHotel(HotelData hotel) {
    return Container(
      margin: EdgeInsets.all(_staticVar.defaultPadding),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            url: hotel.image ?? "",
            boxFit: BoxFit.cover,
            withHalfRadius: true,
            width: 100.w,
            height: 45.h,
          ),
          SizedBox(height: 1.h),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(_staticVar.defaultPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          hotel.name ?? "",
                          style: TextStyle(
                            color: _staticVar.cardcolor,
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: _staticVar.titleFontWeight,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.star_border_rounded,
                            color: _staticVar.cardcolor,
                          ),
                          Text(
                            hotel.starRating ?? "",
                            style: TextStyle(
                              color: _staticVar.cardcolor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    hotel.address ?? "",
                    style: TextStyle(
                        color: _staticVar.cardcolor,
                        fontSize: _staticVar.titleFontSize.sp,
                        fontWeight: _staticVar.titleFontWeight),
                  ),
                  // Text(

                  //   "${(hotel. ?? <SelectedRoom>[]).map((e) => e.boardName).join()} ∙ "
                  //   " ${(hotel.selectedRoom ?? <SelectedRoom>[]).map((e) => e.name ?? "").join()}",
                  //   style: TextStyle(
                  //       fontSize: _staticVar.subTitleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
                  // ),
                  SizedBox(height: 2.h),
                  Container(decoration: DottedDecoration()),
                  SizedBox(height: 2.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${hotel.rateFrom.toString()} ${hotel.currency}",
                        style: TextStyle(
                            color: _staticVar.primaryColor,
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: _staticVar.titleFontWeight),
                      ),
                      CustomBTN(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HotelDetailsScreen(newHotel: hotel)));
                        },
                        title: AppLocalizations.of(context)?.hotelDetails ?? "تفاصيل الفندق",
                      ),
                    ],
                  ),
                ],
              ),
            ).asGlass(),
          )
        ],
      ),
    );
  }
}
