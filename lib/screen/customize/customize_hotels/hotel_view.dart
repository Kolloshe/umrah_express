import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:sizer/sizer.dart';

import '../../../model/customize_models/package_customize_model.dart';
import '../../widgets/street_view_screen.dart';
import 'hotel_details_view.dart';
import 'room_details_view.dart';

class HotelView extends StatelessWidget {
  HotelView({super.key, required this.hotel});
  final Hotel hotel;
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hotel.name ?? ''),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomImage(
              url: hotel.image ?? '',
              width: 18.w,
              height: 10.h,
              boxFit: BoxFit.cover,
              withRadius: true,
            ),
            SizedBox(width: 5.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${(hotel.checkInText ?? '')} - ${(hotel.checkOutText ?? '')} "),
                SizedBox(height: 0.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int star = 0; star < (int.tryParse(hotel.starRating ?? '0') ?? 0); star++)
                      Text(
                        "★",
                        style: TextStyle(color: _staticVar.yellowColor),
                      )
                  ],
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HotelDetailsView(hotel: hotel)));
                  },
                  child: Text(
                    'View hotel details',
                    style: TextStyle(
                        color: _staticVar.primaryColor, fontSize: _staticVar.subTitleFontSize.sp),
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
                    'Street view',
                    style: TextStyle(
                        color: _staticVar.primaryColor, fontSize: _staticVar.subTitleFontSize.sp),
                  ),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => RoomDetailsView(
                              hotel: hotel,
                            )));
                  },
                  child: Text(
                    'Room details',
                    style: TextStyle(
                        color: _staticVar.primaryColor, fontSize: _staticVar.subTitleFontSize.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
