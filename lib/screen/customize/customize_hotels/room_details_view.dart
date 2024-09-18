import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:sizer/sizer.dart';

class RoomDetailsView extends StatefulWidget {
  const RoomDetailsView({super.key, required this.hotel});
  final Hotel hotel;

  @override
  State<RoomDetailsView> createState() => _RoomDetailsViewState();
}

class _RoomDetailsViewState extends State<RoomDetailsView> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.roomDetails ?? "Room details",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        elevation: 0.3,
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: ListView(
          children: [for (var room in widget.hotel.selectedRoom ?? []) _buildRoomDetails(room)],
        ),
      ),
    );
  }

  _buildRoomDetails(SelectedRoom room) {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            url: (widget.hotel.image ?? ''),
            height: 25.h,
            width: 100.w,
            boxFit: BoxFit.cover,
            withRadius: true,
          ),
          SizedBox(height: 2.h),
          Text(
            widget.hotel.name ?? '',
            style: TextStyle(
                fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                room.name ?? '',
                style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
              ),
              Text(room.boardName ?? ''),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //       Text(room.type ?? ''),
              const SizedBox(),
              //   Text(
              //   "${(room.amountChange ?? 0) == 0 ? "" : room.type ?? ''} ${room.amountChange ?? 0} ${room.sellingCurrency ?? ''}",
              //   style: TextStyle(
              //       color: (room.amountChange ?? 0) == 0
              //           ? _staticVar.blackTextColor
              //           : (room.type ?? '') == '-'
              //               ? _staticVar.greenColor
              //               : _staticVar.redColor,
              //       fontSize: _staticVar.titleFontSize.sp,
              //       fontWeight: _staticVar.titleFontWeight),
              // ),
              Text(
                "${room.amount ?? 0} ${room.sellingCurrency ?? ''}",
                style: TextStyle(
                    color: _staticVar.primaryColor,
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
