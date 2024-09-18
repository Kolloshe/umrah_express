import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/model/customize_models/hotel_model/hotel_listing_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';

import '../../../../controller/user_controller.dart';
import '../../../../model/customize_models/package_customize_model.dart';

class HotelDetailsScreen extends StatefulWidget {
  const HotelDetailsScreen({super.key, this.newHotel});

  final HotelData? newHotel;

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  final _staticVar = StaticVar();

  int currentImageIndex = 1;

  String roomCancellation = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getCancellation();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _staticVar.primaryColor,
        title: Text(
          AppLocalizations.of(context)?.hotelDetails ?? "تفاصيل الفندق",
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            _staticVar.defaultPadding,
          ),
          child: Consumer<CustomizeController>(builder: (context, data, child) {
            if (widget.newHotel != null) {
              return _buildNewHotel(hotel: widget.newHotel!);
            } else {
              return ListView(
                children: [
                  SizedBox(
                    width: 100.w,
                    height: 50.h,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: CarouselSlider(
                            items: (data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                .first
                                .imgAll
                                ?.map((e) => CustomImage(
                                      url: e.src ?? "",
                                      boxFit: BoxFit.cover,
                                      withHalfRadius: true,
                                    ))
                                .toList(),
                            options: CarouselOptions(
                              viewportFraction: 1,
                              height: 50.h,
                              onPageChanged: (index, reason) {
                                currentImageIndex = index + 1;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 10,
                            left: 10,
                            right: 0,
                            child: Center(
                              child: Container(
                                alignment: Alignment.center,
                                width: 20.w,
                                child: Text(
                                  "${currentImageIndex} ${AppLocalizations.of(context)?.off ?? "من"} ${(data.packageCustomize?.result?.hotels ?? <Hotel>[]).first.imgAll?.length}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: _staticVar.titleFontSize.sp,
                                      color: _staticVar.cardcolor),
                                ),
                              ).asGlass(
                                  clipBorderRadius:
                                      BorderRadius.circular(_staticVar.defaultInnerRadius),
                                  tintColor: Colors.transparent),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildHotelDetails((data.packageCustomize?.result?.hotels ?? <Hotel>[]).first),
                  SizedBox(height: 1.h),
                  _buildHotelRooms((data.packageCustomize?.result?.hotels ?? <Hotel>[]).first),
                  SizedBox(height: 1.h),
                  _buildRoomOptions((data.packageCustomize?.result?.hotels ?? <Hotel>[]).first),
                  SizedBox(height: 1.h),
                  _buildCancellationData(),
                  SizedBox(height: 3.h),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildHotelRooms(Hotel hotel) {
    if ((hotel.selectedRoom ?? <SelectedRoom>[]).isEmpty) {
      return const SizedBox();
    } else {
      final room = (hotel.selectedRoom ?? <SelectedRoom>[]).first;
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)?.roomDetails ?? "تفاصيل الغرفه",
              style: TextStyle(
                fontSize: _staticVar.titleFontSize.sp,
                fontWeight: _staticVar.titleFontWeight,
              )),
          SizedBox(height: 1.h),
          Container(
            margin: EdgeInsets.all(_staticVar.defaultPadding),
            width: 100.w,
            padding: EdgeInsets.all(_staticVar.defaultPadding),
            decoration: BoxDecoration(
                boxShadow: [_staticVar.shadow],
                color: _staticVar.cardcolor,
                borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: _staticVar.secondaryColor.withAlpha(150),
                        borderRadius: BorderRadius.circular(
                          _staticVar.defaultInnerRadius,
                        ),
                      ),
                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                      child: Text(
                        "${(hotel.selectedRoom ?? <SelectedRoom>[]).length}x",
                        style: TextStyle(color: _staticVar.cardcolor),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    SizedBox(
                      width: 75.w,
                      child: Text(
                        room.name ?? "",
                        style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                const Divider(),
                SizedBox(height: 1.h),
                Text(
                  room.boardName ?? '',
                  style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(_staticVar.defaultPadding),
                  decoration: BoxDecoration(
                    color: _staticVar.primaryColor.withAlpha(100),
                    borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                  ),
                  child: Text(
                    room.roomTypeText ?? '',
                    style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  _buildRoomOptions(Hotel hotel) {
    return Container(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("خيارات غرف اخري",
                style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp,
                  fontWeight: _staticVar.titleFontWeight,
                )),
            SizedBox(height: 1.h),
            for (var room in hotel.rooms ?? <List<Room>>[])
              Container(
                margin: EdgeInsets.all(_staticVar.defaultPadding),
                width: 100.w,
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                decoration: BoxDecoration(
                    boxShadow: [_staticVar.shadow],
                    color: _staticVar.cardcolor,
                    borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: _staticVar.secondaryColor.withAlpha(150),
                            borderRadius: BorderRadius.circular(
                              _staticVar.defaultInnerRadius,
                            ),
                          ),
                          padding: EdgeInsets.all(_staticVar.defaultPadding),
                          child: Text(
                            "x${(room).length}",
                            style: TextStyle(color: _staticVar.cardcolor),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        SizedBox(
                          width: 72.w,
                          child: Text(
                            room.first.name ?? "",
                            style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    const Divider(),
                    SizedBox(height: 1.h),
                    Text(
                      room.first.boardName ?? '',
                      style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                      decoration: BoxDecoration(
                        color: _staticVar.primaryColor.withAlpha(100),
                        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                      ),
                      child: Text(
                        room.first.roomTypeText ?? '',
                        style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const Divider(),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 40.w,
                            child: CustomBTN(
                                onTap: () async {
                                  final result = await context
                                      .read<CustomizeController>()
                                      .changeHotelRoom(room);

                                  if (result) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                title: AppLocalizations.of(context)?.changeRoom ?? "Change room")),
                        Text(
                          "${room.first.type ?? ""} ${(room.first.amountChange ?? 0).toString()} ${room.first.sellingCurrency}",
                          style: TextStyle(
                            color: (room.first.type ?? "") == "-"
                                ? _staticVar.greenColor
                                : _staticVar.redColor,
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: _staticVar.titleFontWeight,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
          ],
        ));
  }

  Widget _buildHotelDetails(Hotel hotel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 90.w,
            child: Text(hotel.name ?? "",
                style: TextStyle(fontSize: _staticVar.titleFontSize.sp + 2))),
        SizedBox(height: 1.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: _staticVar.secondaryColor,
                    ),
                    SizedBox(
                        width: 55.w,
                        child: Text(
                          hotel.address ?? "",
                          maxLines: 1,
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: _staticVar.secondaryColor,
                    ),
                    Text(
                      hotel.starRating ?? "1",
                      style: TextStyle(
                        fontSize: _staticVar.titleFontSize.sp + 1,
                        fontWeight: _staticVar.titleFontWeight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: _staticVar.secondaryColor,
                    ),
                    SizedBox(
                        width: 28.w,
                        child: Text(
                          dateFormat(hotel.checkIn),
                          textAlign: TextAlign.end,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: _staticVar.secondaryColor,
                    ),
                    SizedBox(
                        width: 28.w,
                        child: Text(
                          dateFormat(hotel.checkOut),
                          textAlign: TextAlign.end,
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Text(
              "${hotel.distanceFromMakkah ?? ""} ${AppLocalizations.of(context)?.distenceFromAlKaaba ?? "كيلومتر عن المسجد الحرام (الكعبه)"}",
              style: TextStyle(
                fontSize: _staticVar.titleFontSize.sp,
              ),
            )
          ],
        ),
        SizedBox(height: 1.h),
        Text(AppLocalizations.of(context)?.hotelDetails ?? "تفاصيل الفندق",
            style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp,
              fontWeight: _staticVar.titleFontWeight,
            )),
        SizedBox(height: 1.h),
        Text(
          hotel.description ?? '',
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        SizedBox(height: 1.h),
        Text(AppLocalizations.of(context)?.hotelFacilities ?? "خدمات الفندق",
            style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp,
              fontWeight: _staticVar.titleFontWeight,
            )),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [for (var fac in (hotel.facilities ?? <String>[])) Text(fac)],
        ),
        SizedBox(height: 1.h),
      ],
    );
  }

  Widget _buildCancellationData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)?.cancellationPolicy ?? "سياسه الالغاء ",
            style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp,
              fontWeight: _staticVar.titleFontWeight,
            )),
        SizedBox(height: 1.h),
        Text(roomCancellation)
      ],
    );
  }

  String dateFormat(date) {
    String text = "";

    if (date is String) {
      final tempDate = DateFormat().parse(date);
      text = DateFormat(" dd MMMM, y", context.read<UserController>().locale.languageCode)
          .format(tempDate);
    } else {
      text = DateFormat(" dd MMMM, y", context.read<UserController>().locale.languageCode)
          .format(date);
    }

    return text;
  }

  getCancellation() async {
    if (widget.newHotel != null) return;
    if ((context.read<CustomizeController>().packageCustomize?.result?.hotels?.first.selectedRoom ??
            [])
        .isNotEmpty) {
      for (var room in (context
              .read<CustomizeController>()
              .packageCustomize
              ?.result
              ?.hotels
              ?.first
              .selectedRoom ??
          <SelectedRoom>[])) {
        final cancellationPolicy =
            await context.read<CustomizeController>().getHotelCancellationPolicy(room.rateKey);

        if (cancellationPolicy["data"] is List<dynamic>) {
          final List canc = cancellationPolicy["data"];
          roomCancellation = canc
              .map((e) =>
                  AppLocalizations.of(context)?.hotelCancelationValue(e["amount"].toString(),
                      e["currency"].toString(), e["from_date"].toString()) ??
                  "سيتم فرض قيمه ${e["amount"]}${e["currency"]} من يوم ${e["from_date"]}")
              .join("\n");
        }
      }
      setState(() {});
    }
  }

  Widget _buildNewHotelDetails(HotelData hotel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 90.w,
            child: Text(hotel.name ?? "",
                style: TextStyle(fontSize: _staticVar.titleFontSize.sp + 2))),
        SizedBox(height: 1.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: _staticVar.secondaryColor,
                    ),
                    SizedBox(
                        width: 55.w,
                        child: Text(
                          hotel.address ?? "",
                          maxLines: 1,
                        ))
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: _staticVar.secondaryColor,
                    ),
                    Text(
                      hotel.starRating ?? "1",
                      style: TextStyle(
                        fontSize: _staticVar.titleFontSize.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: _staticVar.secondaryColor,
                    ),
                    SizedBox(
                        width: 28.w,
                        child: Text(
                          dateFormat(hotel.checkIn),
                          textAlign: context.read<UserController>().isAR()
                              ? TextAlign.end
                              : TextAlign.start,
                          style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp - 1),
                        )),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: _staticVar.secondaryColor,
                    ),
                    SizedBox(
                        width: 28.w,
                        child: Text(dateFormat(hotel.checkOut),
                            textAlign: context.read<UserController>().isAR()
                                ? TextAlign.end
                                : TextAlign.start,
                            style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp - 1))),
                  ],
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Text(
              "${hotel.distanceFromMakkah ?? ""}  ${AppLocalizations.of(context)?.distenceFromAlKaaba ?? "كيلومتر عن المسجد الحرام (الكعبه)"}",
              style: TextStyle(
                fontSize: _staticVar.titleFontSize.sp,
              ),
            )
          ],
        ),
        SizedBox(height: 1.h),
        Divider(),
        SizedBox(height: 1.h),
        Text(AppLocalizations.of(context)?.hotelDetails ?? "تفاصيل الفندق",
            style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp,
              fontWeight: _staticVar.titleFontWeight,
            )),
        SizedBox(height: 1.h),
        Text(
          hotel.description ?? '',
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        SizedBox(height: 1.h),
        Text(AppLocalizations.of(context)?.hotelFacilities ?? "خدمات الفندق",
            style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp,
              fontWeight: _staticVar.titleFontWeight,
            )),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [for (var fac in (hotel.facilities ?? <String>[])) Text(fac)],
        ),
        SizedBox(height: 1.h),
      ],
    );
  }

  Widget _buildNewRoomOptions(HotelData hotel) {
    return Container(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)?.roomOption ?? "خيارات الغرف ",
                style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp,
                  fontWeight: _staticVar.titleFontWeight,
                )),
            SizedBox(height: 1.h),
            for (var room in hotel.rooms ?? <List<Room>>[])
              Container(
                margin: EdgeInsets.all(_staticVar.defaultPadding),
                width: 100.w,
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                decoration: BoxDecoration(
                    boxShadow: [_staticVar.shadow],
                    color: _staticVar.cardcolor,
                    borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: _staticVar.secondaryColor.withAlpha(150),
                            borderRadius: BorderRadius.circular(
                              _staticVar.defaultInnerRadius,
                            ),
                          ),
                          padding: EdgeInsets.all(_staticVar.defaultPadding),
                          child: Text(
                            "x${(room).length}",
                            style: TextStyle(color: _staticVar.cardcolor),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          room.first.name ?? "",
                          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    const Divider(),
                    SizedBox(height: 1.h),
                    Text(
                      room.first.boardName ?? '',
                      style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                      decoration: BoxDecoration(
                        color: _staticVar.primaryColor.withAlpha(100),
                        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                      ),
                      child: Text(
                        room.first.roomTypeText ?? '',
                        style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const Divider(),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 40.w,
                            child: CustomBTN(
                                onTap: () async {
                                  final result = await context
                                      .read<CustomizeController>()
                                      .changeTheHotel(
                                          selectedRoom: room,
                                          hotelId: widget.newHotel?.id,
                                          hotelKey: 0);

                                  if (result) {
                                    Navigator.of(context)
                                      ..pop()
                                      ..pop();
                                  }
                                },
                                title: AppLocalizations.of(context)?.changeRoom ?? "حجز")),
                        Text(
                          "${room.first.type ?? ""} ${(room.first.amountChange ?? 0).toString()} ${room.first.sellingCurrency}",
                          style: TextStyle(
                            color: (room.first.type ?? "") == "-"
                                ? _staticVar.greenColor
                                : _staticVar.redColor,
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: _staticVar.titleFontWeight,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
          ],
        ));
  }

  Widget _buildNewHotel({required HotelData hotel}) {
    return ListView(
      children: [
        SizedBox(
          width: 100.w,
          height: 50.h,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: CarouselSlider(
                  items: hotel.imgAll
                      ?.map((e) => CustomImage(
                            url: e.src ?? "",
                            boxFit: BoxFit.cover,
                            withHalfRadius: true,
                          ))
                      .toList(),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 50.h,
                    onPageChanged: (index, reason) {
                      currentImageIndex = index + 1;
                      setState(() {});
                    },
                  ),
                ),
              ),
              Positioned(
                  bottom: 10,
                  left: 10,
                  right: 0,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 20.w,
                      child: Text(
                        "${currentImageIndex} ${AppLocalizations.of(context)?.off ?? "من"} ${(hotel.imgAll?.length ?? 0)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp, color: _staticVar.cardcolor),
                      ),
                    ).asGlass(
                        clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                        tintColor: Colors.transparent),
                  )),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        _buildNewHotelDetails(widget.newHotel!),
        SizedBox(height: 1.h),
        _buildNewRoomOptions(hotel),
        SizedBox(height: 3.h),
      ],
    );
  }
}
