import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../model/customize_models/package_customize_model.dart';

class FlightView extends StatelessWidget {
  FlightView({super.key, required this.flight, required this.tripStart});
  final From flight;
  final String tripStart;
  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tripStart),
        SizedBox(height: 1.h),
        Text(DateFormat('EEEE dd, MMMM y').format(flight.departureFdate ?? DateTime.now())),
        SizedBox(height: 2.h),
        CustomImage(url: flight.carrierLogo ?? '', width: 20.w),
        SizedBox(height: 2.h),
        SizedBox(
          width: 100.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [Text(flight.departure ?? ''), Text(flight.departureTime ?? '')],
              ),
              (flight.stops ?? []).isEmpty
                  ? Expanded(
                      child: Divider(
                      color: _staticVar.yellowColor,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10,
                    ))
                  : Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Divider(
                              color: _staticVar.yellowColor,
                              thickness: 1.5,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ),
                          Column(
                            children: [
                              for (var stop in flight.stops ?? <String>[])
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: _staticVar.defaultPadding),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '●',
                                        style: TextStyle(
                                            color: _staticVar.yellowColor,
                                            fontSize: _staticVar.titleFontSize.sp),
                                      ),
                                      Text(
                                        stop,
                                        style: TextStyle(
                                            color: _staticVar.primaryColor,
                                            fontSize: _staticVar.subTitleFontSize.sp),
                                      )
                                    ],
                                  ),
                                ),
                              Text(
                                flight.travelTime ?? '',
                                style: TextStyle(
                                    color: _staticVar.primaryColor,
                                    fontSize: _staticVar.subTitleFontSize.sp),
                              )
                            ],
                          ),
                          Expanded(
                            child: Divider(
                              color: _staticVar.yellowColor,
                              thickness: 1.5,
                              indent: 10,
                              endIndent: 10,
                            ),
                          )
                        ],
                      ),
                    ),
              Column(
                children: [Text(flight.arrival ?? ''), Text(flight.arrivalTime ?? '')],
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h)
      ],
    );
  }
}
