import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/prebook_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../model/customize_models/package_customize_model.dart';
import '../../../auth/login.dart';
import '../../../prebook/prebook_stepper.dart';

class IndividualHotelRoomSelection extends StatefulWidget {
  const IndividualHotelRoomSelection({super.key, this.roomLimit = 1});
  final int roomLimit;

  @override
  State<IndividualHotelRoomSelection> createState() => _IndividualHotelRoomSelectionState();
}

class _IndividualHotelRoomSelectionState extends State<IndividualHotelRoomSelection> {
  final _staticVar = StaticVar();

  late List<Room?> selectedRoom = List.generate(widget.roomLimit, (index) => null);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text(
          AppLocalizations.of(context)?.hotelDetails ?? "Hotel Details",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        foregroundColor: _staticVar.primaryColor,
        backgroundColor: _staticVar.cardcolor,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<CustomizeController>(builder: (context, data, child) {
          return ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              SizedBox(
                width: 100.w,
                height: 30.h,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 30.h,
                    viewportFraction: 0.9,
                    aspectRatio: 4 / 3,
                    initialPage: 0,
                    autoPlay: false,
                  ),
                  items: [
                    for (var img
                        in ((data.packageCustomize?.result?.hotels ?? <Hotel>[]).first.imgAll ??
                                <ImgAll>[])
                            .map((e) => (e.src ?? ""))
                            .toList())
                      CustomImage(
                        withRadius: true,
                        url: img,
                        boxFit: BoxFit.cover,
                        width: 85.w,
                      )
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                (data.packageCustomize?.result?.hotels ?? <Hotel>[]).first.name ?? '',
                style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp,
                  fontWeight: _staticVar.titleFontWeight,
                ),
              ),
              SizedBox(height: 1.h),
              ReadMoreText(
                (data.packageCustomize?.result?.hotels ?? <Hotel>[]).first.description ?? "",
                style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                moreStyle: TextStyle(
                    fontSize: _staticVar.subTitleFontSize.sp,
                    fontWeight: _staticVar.titleFontWeight,
                    color: _staticVar.primaryColor),
                lessStyle: TextStyle(
                    fontSize: _staticVar.subTitleFontSize.sp,
                    fontWeight: _staticVar.titleFontWeight,
                    color: _staticVar.primaryColor),
              ),
              SizedBox(height: 1.h),
              Divider(color: _staticVar.gray),
              SizedBox(height: 1.h),
              Text(
                'Select your ${selectedRoom.length > 1 ? 'Rooms' : 'Room'}',
                style: TextStyle(
                  fontSize: _staticVar.titleFontSize.sp,
                  fontWeight: _staticVar.titleFontWeight,
                ),
              ),
              SizedBox(height: 2.h),
              Wrap(
                children: [
                  for (int i = 0; i < selectedRoom.length; i++)
                    GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => _buildBottomSheet(
                                rooms: ((data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                            .first
                                            .rooms ??
                                        <List<Room>>[])
                                    .expand((element) => element)
                                    .map((e) => e)
                                    .toList(),
                                img: (data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                        .first
                                        .image ??
                                    "",
                                index: i));

                        if (selectedRoom.contains(null) == false) {
                          final req = {
                            "customizeId": data.packageCustomize?.result?.customizeId,
                            "hotelId":
                                (data.packageCustomize?.result?.hotels ?? <Hotel>[]).first.id,
                            "hotelKey": 0,
                            "selectedRoom": selectedRoom.map((e) => e?.toJson()),
                            "currency":
                                (data.packageCustomize?.result?.hotels ?? <Hotel>[]).first.currency,
                            "language": UtilityVar.genLanguage
                          };

                          data.changeHotelRoom(selectedRoom
                              .where((element) => element != null)
                              .toList()
                              .map((e) => e!)
                              .toList());
                        }
                      },
                      child: selectedRoom[i] == null
                          ? Container(
                              width: 20.w,
                              height: 20.w,
                              padding: EdgeInsets.all(_staticVar.defaultPadding),
                              margin: EdgeInsets.symmetric(horizontal: _staticVar.defaultPadding),
                              decoration: BoxDecoration(
                                  color: _staticVar.primaryColor,
                                  borderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
                              child: Icon(
                                Icons.add,
                                color: _staticVar.cardcolor,
                              ),
                            )
                          : Container(
                              width: 25.w,
                              height: 28.w,
                              child: Column(
                                children: [
                                  CustomImage(
                                      width: 20.w,
                                      height: 15.w,
                                      withRadius: true,
                                      boxFit: BoxFit.cover,
                                      url: (data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                              .first
                                              .image ??
                                          ""),
                                  Text(
                                    "${selectedRoom[i]?.name ?? ""}\n${selectedRoom[i]?.boardName ?? ""}",
                                    style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                                  ),
                                ],
                              ),
                            ),
                    )
                ],
              )
            ],
          );
        }),
      )),
      bottomSheet: Container(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedRoom.contains(null) == false
                ? "${AppLocalizations.of(context)?.totalP ?? "Total price"} ${context.read<CustomizeController>().packageCustomize?.result?.totalAmount} ${context.read<CustomizeController>().packageCustomize?.result?.sellingCurrency ?? ""}"
                : "${AppLocalizations.of(context)?.roomStartingFrom ?? "Starting from"} ${(context.read<CustomizeController>().packageCustomize?.result?.hotels ?? <Hotel>[]).first.rateFrom ?? ""}"),
            SizedBox(height: 1.h),
            selectedRoom.contains(null) == false
                ? SizedBox(
                    width: 100.w,
                    child: CustomBTN(
                        onTap: () {
                          if (context.read<UserController>().userModel != null) {
                            final pack = context.read<CustomizeController>().packageCustomize;
                            context.read<PrebookController>().getCustomizeData(pack!);
                            context.read<PrebookController>().preparePassengers();
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const PrebookStepper()));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginScreen(fromCustomize: true)));
                          }
                        },
                        title: AppLocalizations.of(context)?.bookNow ?? "Book now"))
                : const SizedBox(),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet({required List<Room> rooms, required String img, required int index}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_staticVar.defaultRadius),
            topRight: Radius.circular(_staticVar.defaultRadius),
          ),
          color: _staticVar.cardcolor),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                color: _staticVar.primaryColor.withAlpha(100),
              ),
              width: 20.w,
              height: 1.h,
            ),
          ),
          Text(
            AppLocalizations.of(context)?.availableRooms ?? "Available room",
            style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp,
              fontWeight: _staticVar.titleFontWeight,
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
              child: ListView(
            children: [
              for (var room in rooms)
                GestureDetector(
                  onTap: () {
                    selectedRoom[index] = room;
                  },
                  child: Container(
                    decoration:
                        BoxDecoration(color: _staticVar.cardcolor, boxShadow: [_staticVar.shadow]),
                    margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
                    child: Row(
                      children: [
                        CustomImage(
                          url: img,
                          width: 20.w,
                          height: 10.h,
                          boxFit: BoxFit.cover,
                          withRadius: true,
                        ),
                        SizedBox(width: 2.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(room.name ?? ""),
                            Text(room.boardName ?? ""),
                            Text(
                                "${room.amount ?? 0} ${room.sellingCurrency ?? UtilityVar.genCurrency}"),
                            GestureDetector(
                              onTap: () async {
                                final result = await context
                                    .read<CustomizeController>()
                                    .getHotelCancellationPolicy(room.rateKey ?? "");
                                if (!mounted) return;
                                if (result.isNotEmpty) {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => Container(
                                            padding: EdgeInsets.all(_staticVar.defaultPadding),
                                            decoration: BoxDecoration(
                                                color: _staticVar.cardcolor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(_staticVar.defaultRadius),
                                                    topRight:
                                                        Radius.circular(_staticVar.defaultRadius))),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(height: 2.h),
                                                Text(
                                                  "The refundable amount on  ${result["date"]} is ${result["total"]} ${result['currency']} and it may change depending on the time of cancellation",
                                                  style: TextStyle(
                                                    fontSize: _staticVar.titleFontSize.sp,
                                                    fontWeight: _staticVar.titleFontWeight,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                              ],
                                            ),
                                          ));
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)?.cancellationPolicy ??
                                    "Cancellation policy",
                                style: TextStyle(
                                  color: _staticVar.primaryColor,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
            ],
          ))
        ],
      ),
    );
  }
}
