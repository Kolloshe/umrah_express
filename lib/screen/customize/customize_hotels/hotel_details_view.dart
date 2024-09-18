import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/model/customize_models/hotel_model/hotel_listing_model.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HotelDetailsView extends StatefulWidget {
  const HotelDetailsView({super.key, this.hotel, this.hotelData});

  final Hotel? hotel;
  final HotelData? hotelData;

  @override
  State<HotelDetailsView> createState() => _HotelDetailsViewState();
}

class _HotelDetailsViewState extends State<HotelDetailsView> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        elevation: 0.2,
        title: Text(
          AppLocalizations.of(context)?.hotelDetails ?? 'Hotel Details',
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          children: widget.hotel != null
              ? [
                  _buildImage((widget.hotel?.imgAll ?? <ImgAll>[])
                      .map((e) => e.src ?? '')
                      .take(5)
                      .toList()),
                  SizedBox(height: 1.h),
                  _buildHotelDetails(widget.hotel!),
                  SizedBox(height: 1.h),
                  ReadMoreText(
                    widget.hotel?.description ?? '',
                    trimMode: TrimMode.Line,
                    trimLines: 4,
                    textAlign: TextAlign.justify,
                    colorClickableText: _staticVar.primaryColor,
                    trimCollapsedText: '  Show more',
                    trimExpandedText: '  Show less',
                    moreStyle: TextStyle(
                        fontSize: _staticVar.titleFontSize.sp,
                        color: _staticVar.primaryColor,
                        fontWeight: FontWeight.bold),
                    lessStyle: TextStyle(
                        fontSize: _staticVar.titleFontSize.sp,
                        color: _staticVar.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2.h),
                  (widget.hotel?.facilities ?? <String>[]).isEmpty
                      ? const SizedBox()
                      : _buildFacilities(widget.hotel?.facilities ?? <String>[])
                ]
              : widget.hotelData != null
                  ? [
                      _buildImage((widget.hotelData?.imgAll ?? <ImgAll>[])
                          .map((e) => e.src ?? '')
                          .take(5)
                          .toList()),
                      SizedBox(height: 1.h),
                      _buildHotelDetailsV2(widget.hotelData!),
                      ReadMoreText(
                        widget.hotelData!.description ?? '',
                        trimMode: TrimMode.Line,
                        trimLines: 4,
                        textAlign: TextAlign.justify,
                        colorClickableText: _staticVar.primaryColor,
                        trimCollapsedText: '  Show more',
                        trimExpandedText: '  Show less',
                        moreStyle: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            color: _staticVar.primaryColor,
                            fontWeight: FontWeight.bold),
                        lessStyle: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            color: _staticVar.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.h),
                      (widget.hotel?.facilities ?? <String>[]).isEmpty
                          ? const SizedBox()
                          : _buildFacilities(widget.hotelData?.facilities ?? <String>[])
                    ]
                  : [],
        ),
      ),
    );
  }

  _buildImage(List<String> list) {
    return SizedBox(
        width: 100.w,
        height: 25.h,
        child: StaggeredGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: [
            for (int i = 0; i < list.length; i++)
              StaggeredGridTile.count(
                crossAxisCellCount: i == 0 ? 2 : 1,
                mainAxisCellCount: 1,
                child: i == 4
                    ? Stack(
                        children: [
                          CustomImage(
                            url: list[i],
                            boxFit: BoxFit.cover,
                            height: 11.h,
                          ),
                          Container(
                            height: 11.5.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _staticVar.gray.withAlpha(200),
                            ),
                            child: Text(
                              ((widget.hotel?.imgAll ?? widget.hotelData?.imgAll ?? <ImgAll>[])
                                      .length)
                                  .toString(),
                              style: TextStyle(
                                  color: _staticVar.cardcolor,
                                  fontSize: _staticVar.titleFontSize.sp,
                                  fontWeight: _staticVar.titleFontWeight),
                            ),
                          )
                        ],
                      )
                    : CustomImage(
                        url: list[i],
                        boxFit: BoxFit.cover,
                      ),
              ),
          ],
        ));
  }

  _buildHotelDetails(Hotel hotel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  hotel.name ?? '',
                  style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp, color: _staticVar.primaryColor),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(hotel.address ?? ''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/check-in.png',
                          width: 16,
                          color: _staticVar.gray,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          formatDates(hotel.checkIn ?? DateTime.now()),
                          style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hotelRating(hotel.starRating ?? ''),
                      style: TextStyle(color: _staticVar.yellowColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/check-out.png',
                          width: 16,
                          color: _staticVar.gray,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          formatDates(hotel.checkOut ?? DateTime.now()),
                          style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
              ],
            ))
      ],
    );
  }

  _buildHotelDetailsV2(HotelData hotel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  hotel.name ?? '',
                  style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp, color: _staticVar.primaryColor),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(hotel.address ?? ''),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/check-in.png',
                          width: 16,
                          color: _staticVar.gray,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          formatDates(hotel.checkIn ?? DateTime.now()),
                          style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hotelRating(hotel.starRating ?? ''),
                      style: TextStyle(color: _staticVar.yellowColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/check-out.png',
                          width: 16,
                          color: _staticVar.gray,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          formatDates(hotel.checkOut ?? DateTime.now()),
                          style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
              ],
            ))
      ],
    );
  }

  String formatDates(DateTime date) => DateFormat('dd , MMM y').format(date);

  String hotelRating(String s) {
    final star = int.tryParse(s) ?? 0;
    String text = '';
    for (int i = 0; i < star; i++) {
      text = '$text★';
    }
    return text;
  }

  Widget _buildFacilities(List<String> facilities) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.hotelFacilities ?? '',
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
            fontWeight: _staticVar.titleFontWeight,
          ),
        ),
        SizedBox(height: 2.h),
        for (var facility in facilities)
          Text(
            '• $facility\n',
            style: TextStyle(color: _staticVar.blackColor),
          )
      ],
    );
  }
}
