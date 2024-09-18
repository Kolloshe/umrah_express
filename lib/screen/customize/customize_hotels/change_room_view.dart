import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/model/customize_models/hotel_model/hotel_listing_model.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_image.dart';

class ChangeRoomView extends StatefulWidget {
  const ChangeRoomView({super.key, this.hotel, this.hotelKey, this.hotelData});
  final Hotel? hotel;
  final String? hotelKey;
  final HotelData? hotelData;
  @override
  State<ChangeRoomView> createState() => _ChangeRoomViewState();
}

class _ChangeRoomViewState extends State<ChangeRoomView> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: _staticVar.cardcolor,
          foregroundColor: _staticVar.primaryColor,
          title: Text(
            AppLocalizations.of(context)?.availableRooms ?? 'Available rooms',
            style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp,
            ),
          ),
          elevation: 0.3),
      body: ListView(
        children: widget.hotel != null
            ? [
                for (var rooms in widget.hotel?.rooms ?? <List<Room>>[])
                  _buildRoomHolder(rooms, widget.hotel?.image ?? '')
              ]
            : [
                for (var rooms in widget.hotelData?.rooms ?? <List<Room>>[])
                  _buildRoomHolder(rooms, widget.hotelData?.image ?? '')
              ],
      ),
    );
  }

  _buildRoomHolder(List<Room> rooms, String image) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding * 2),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var room in rooms) ...[
            _buildRoom(room, image),
            SizedBox(height: 1.h),
          ],
          SizedBox(
            width: 30.w,
            child: CustomBTN(
              onTap: () async {
                if (widget.hotel != null) {
                  final result = await context.read<CustomizeController>().changeHotelRoom(rooms);
                  if (!mounted) return;
                  if (result) {
                    Navigator.of(context).pop();
                  }
                } else if (widget.hotelData != null) {
                  final result = await context.read<CustomizeController>().changeTheHotel(
                      hotelId: widget.hotelData?.id, hotelKey: 0, selectedRoom: rooms);

                  if (!mounted) return;

                  if (result) {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  }
                }
              },
              title: 'Select',
              color: _staticVar.yellowColor,
            ),
          )
        ],
      ),
    );
  }

  _buildRoom(Room room, String image) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding * 2),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      // decoration: BoxDecoration(
      //   color: _staticVar.cardcolor,
      //   boxShadow: [_staticVar.shadow],
      //   borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            url: (image),
            height: 25.h,
            width: 100.w,
            boxFit: BoxFit.cover,
            withRadius: true,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.hotel?.name ?? widget.hotelData?.name ?? '',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 60.w,
                child: Text(
                  room.name ?? '',
                  style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                ),
              ),
              SizedBox(
                  width: 32.w,
                  child: Text(
                    room.boardName ?? '',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                  )),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(),
              Text(
                "${(room.amountChange ?? 0) == 0 ? "" : room.type ?? ''} ${room.amountChange ?? 0} ${room.sellingCurrency ?? ''}",
                style: TextStyle(
                    color: (room.amountChange ?? 0) == 0
                        ? _staticVar.blackColor
                        : (room.type ?? '') == '-'
                            ? _staticVar.greenColor
                            : _staticVar.redColor,
                    fontSize: _staticVar.titleFontSize.sp,
                    fontWeight: _staticVar.titleFontWeight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
