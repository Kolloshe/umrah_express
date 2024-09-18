import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';

import '../../../controller/prebook_controller.dart';
import '../../auth/login.dart';
import '../../prebook/prebook_stepper.dart';
import '../../widgets/widget_v2/images_media_view.dart';
import '../customize_esim/change_esim_view.dart';
import '../customize_esim/esim_view.dart';
import 'customize_flights/flight_card.dart';
import 'customize_hotel/change_hotel/change_hotel_listing.dart';
import 'customize_hotel/hotel_details.dart';
import 'customize_transfer/change_transfer/change_transfer_listing_screen.dart';

class CustomizeDetials extends StatefulWidget {
  const CustomizeDetials({super.key});

  @override
  State<CustomizeDetials> createState() => _CustomizeDetialsState();
}

class _CustomizeDetialsState extends State<CustomizeDetials> {
  final _staticVar = StaticVar();

  int currentImageIndex = 1;

  @override
  Widget build(BuildContext context) {
    print(isContainOnlyOneService());
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Consumer<CustomizeController>(builder: (context, data, child) {
          return ListView(
            padding: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding * 6).copyWith(top: 0),
            children: [
              GestureDetector(
                onTap: () {
                  final images =
                      (((data.packageCustomize?.result?.hotels ?? <Hotel>[]).first.imgAll ??
                                  <ImgAll>[])
                              .map((e) => e.src ?? '')
                              .toList())
                          .where((element) => element != '')
                          .toList();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImagesMediaView(
                            images: images,
                          )));
                },
                child: (data.packageCustomize?.result?.hotels?.isNotEmpty ?? false)
                    ? SizedBox(
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
                                items: (data.packageCustomize?.result?.hotels?.isNotEmpty ?? false)
                                    ? ((data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                                .first
                                                .imgAll ??
                                            [])
                                        .map((e) => CustomImage(
                                              url: e.src ?? "",
                                              boxFit: BoxFit.cover,
                                            ))
                                        .toList()
                                    : [SizedBox()],
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
                                bottom: 5,
                                left: 10,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20.w,
                                    child: (data.packageCustomize?.result?.hotels ?? <Hotel>[])
                                            .isNotEmpty
                                        ? Text(
                                            "${currentImageIndex} ${AppLocalizations.of(context)?.off ?? "من"} ${(data.packageCustomize?.result?.hotels ?? <Hotel>[]).first.imgAll?.length}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: _staticVar.titleFontSize.sp,
                                                color: _staticVar.cardcolor),
                                          )
                                        : const SizedBox(),
                                  ).asGlass(
                                      clipBorderRadius:
                                          BorderRadius.circular(_staticVar.defaultInnerRadius),
                                      tintColor: Colors.transparent),
                                )),
                            Positioned(
                                top: 40,
                                right: context.read<UserController>().isAR() ? 10 : null,
                                left: context.read<UserController>().isAR() ? null : 10,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 5.h,
                                    height: 5.h,
                                    padding: EdgeInsets.all(_staticVar.defaultPadding),
                                    child: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: _staticVar.cardcolor,
                                    ),
                                  ).asGlass(
                                      clipBorderRadius:
                                          BorderRadius.circular(_staticVar.defaultInnerRadius),
                                      tintColor: Colors.black),
                                )),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.packageCustomize?.result?.hotels?.isEmpty ?? false) ...[
                      SizedBox(height: 7.h)
                    ],
                    _buildPackageDetails(data.packageCustomize?.result),
                    SizedBox(height: 1.h),
                    if (data.packageCustomize?.result?.flight != null) const FlightCard(),
                    SizedBox(height: 1.h),
                    if (data.packageCustomize?.result?.hotels != null &&
                        (data.packageCustomize?.result?.hotels ?? []).isNotEmpty)
                      _buildPackageHotel(
                          (data.packageCustomize?.result?.hotels ?? <Hotel>[]).first),
                    SizedBox(height: 1.h),
                    if (data.packageCustomize?.result?.transfer != null &&
                        (data.packageCustomize?.result?.transfer ?? []).isNotEmpty)
                      _buildTransfer(data.packageCustomize?.result?.transfer ?? <Transfer>[]),
                    SizedBox(height: 1.h),
                    if (data.packageCustomize?.result?.activities != null &&
                        (data.packageCustomize?.result?.activities?.values ?? []).isNotEmpty) ...[
                      _buildActivity(),
                      SizedBox(height: 1.h),
                    ],
                    if (data.packageCustomize?.result?.esim != null)
                      _buildEsim(data.packageCustomize!.result!.esim!),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],
          );
        }),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        margin: EdgeInsets.symmetric(
          vertical: _staticVar.defaultPadding * 2,
          horizontal: _staticVar.defaultPadding,
        ),
        width: 100.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<CustomizeController>(builder: (context, data, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)?.totalPACKAGEPRICE ?? "المبلغ الكلي",
                    style: TextStyle(
                      fontSize: _staticVar.subTitleFontSize.sp - 2,
                      fontWeight: _staticVar.titleFontWeight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  (context.read<CustomizeController>().packageCustomize?.result?.totalAmount ?? 0) >
                          0
                      ? Text(
                          "${(context.read<CustomizeController>().packageCustomize?.result?.totalAmount ?? 0).toString()} ${context.read<CustomizeController>().packageCustomize?.result?.sellingCurrency ?? UtilityVar.genCurrency}",
                          style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp + 2,
                            fontWeight: _staticVar.titleFontWeight,
                            color: _staticVar.primaryColor,
                          ),
                        )
                      : const SizedBox(),
                ],
              );
            }),
            SizedBox(
              width: 50.w,
              child: CustomBTN(
                  onTap: () {
                    collectPassengerData();
                  },
                  title: AppLocalizations.of(context)?.bookNow ?? "حجز الرحله "),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageDetails(Result? package) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          package?.packageName ?? "باقه العمره - مكه (ميقات الطائف)",
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp + 2,
            fontWeight: _staticVar.titleFontWeight,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            ((package?.hotels ?? []).isNotEmpty)
                ? _buildIconWithTitle(
                    icon: Icons.location_on,
                    title:
                        "${package?.hotels?.first.distanceFromMakkah} ${AppLocalizations.of(context)?.distenceFromAlKaaba ?? "كيلومتر من المسجد الحرام (الكعبه)"}",
                  )
                : const SizedBox(),
            SizedBox(
              height: 2.h,
              width: 4.w,
              child: VerticalDivider(
                color: _staticVar.secondaryColor,
              ),
            ),
            ((package?.hotels ?? []).isNotEmpty)
                ? _buildIconWithTitle(
                    icon: Icons.star_outline_rounded,
                    title: (package?.hotels ?? <Hotel>[]).first.starRating ?? "",
                  )
                : const SizedBox(),
            SizedBox(
              height: 2.h,
              width: 4.w,
              child: VerticalDivider(
                color: _staticVar.secondaryColor,
              ),
            ),
            _buildIconWithTitle(
                icon: Icons.person,
                title: ((package?.adults ?? 1) + (package?.children ?? 0)).toString()),
          ],
        ),
        ((package?.hotels ?? []).isNotEmpty)
            ? _buildIconWithTitle(
                icon: Icons.calendar_today,
                title: dateFormat((package?.hotels ?? <Hotel>[]).first.checkIn ?? ""))
            : const SizedBox(),
        SizedBox(height: 2.h)
      ],
    );
  }

  Widget _buildPackageHotel(Hotel hotel) {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
        //  color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            url: hotel.image ?? "",
            boxFit: BoxFit.cover,
            withRadius: true,
            height: 45.h,
            width: 100.w,
          ),
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
                  SizedBox(height: 1.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          hotel.name ?? "",
                          style: TextStyle(
                            color: _staticVar.primaryColor,
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: _staticVar.titleFontWeight,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                  SizedBox(height: 1.h),
                  Text(
                    "${(hotel.selectedRoom ?? <SelectedRoom>[]).map((e) => e.boardName).join()} ∙ "
                    " ${(hotel.selectedRoom ?? <SelectedRoom>[]).map((e) => e.name ?? "").join()}",
                    style: TextStyle(
                        color: _staticVar.cardcolor,
                        fontSize: _staticVar.subTitleFontSize.sp,
                        fontWeight: _staticVar.titleFontWeight),
                  ),
                  SizedBox(height: 2.h),
                  Container(decoration: DottedDecoration()),
                  SizedBox(height: 2.h),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    SizedBox(
                      width: 40.w,
                      child: CustomBTN(
                        onTap: () async {
                          await context.read<CustomizeController>().getHotelListing(
                              checkIn: hotel.checkIn,
                              checkOut: hotel.checkOut,
                              hotelID: hotel.id,
                              star: "");
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ChangeHotelListing()));
                        },
                        title: AppLocalizations.of(context)?.moreHotels ?? "تغيير الفندق",
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SizedBox(
                      width: 40.w,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const HotelDetailsScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: _staticVar.primaryColor),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(_staticVar.defaultInnerRadius))),
                        ),
                        child: Text(
                          AppLocalizations.of(context)?.hotelDetails ?? "تفاصيل الفندق",
                          style: TextStyle(
                              color: _staticVar.primaryColor,
                              fontSize: _staticVar.titleFontSize.sp),
                        ),
                      ),
                    )
                  ])
                ],
              ),
            ).asGlass(
                clipBorderRadius: BorderRadius.circular(
                  _staticVar.defaultRadius,
                ),
                tintColor: _staticVar.blackColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTransfer(List<Transfer> transfer) {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var transfer in transfer) ...[
            Container(
              margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(transfer.image ?? ""), fit: BoxFit.contain),
              ),
              child: Container(
                      margin: EdgeInsets.all(_staticVar.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.h),
                          const Divider(),
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transfer.serviceTypeName ?? "",
                                    style: TextStyle(
                                      fontSize: _staticVar.titleFontSize.sp,
                                      fontWeight: _staticVar.titleFontWeight,
                                    ),
                                  ),
                                  Text(
                                    "${transfer.productTypeName ?? ""} • ${transfer.vehicleTypeName ?? ""}",
                                    style: TextStyle(
                                      color: _staticVar.gray,
                                      fontSize: _staticVar.subTitleFontSize.sp,
                                    ),
                                  ),
                                ],
                              ),
                              CustomImage(
                                url: transfer.image ?? "",
                                width: 30.w,
                                height: 7.h,
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Divider(
                            color: _staticVar.gray.withAlpha(100),
                            thickness: 0.5,
                          ),
                          SizedBox(height: 1.h),
                          for (var info in transfer.generalInformation ?? <String>[])
                            Text(
                              info,
                              style: TextStyle(
                                  color: _staticVar.secondaryColor,
                                  fontSize: _staticVar.subTitleFontSize.sp),
                            ),
                          SizedBox(height: 1.h),
                          Divider(
                            color: _staticVar.gray.withAlpha(100),
                            thickness: 0.5,
                          ),
                          SizedBox(height: 1.h),
                          SizedBox(
                            height: 16.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(_staticVar.defaultPadding - 5),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: _staticVar.secondaryColor.withAlpha(100),
                                              spreadRadius: 4,
                                              blurRadius: 4,
                                              offset: Offset.zero),
                                        ],
                                        shape: BoxShape.circle,
                                        color: _staticVar.secondaryColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: VerticalDivider(
                                        color: _staticVar.secondaryColor,
                                      ),
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      color: _staticVar.secondaryColor,
                                    ),
                                    SizedBox(height: 1.h),
                                  ],
                                ),
                                SizedBox(width: 2.w),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)?.transStartFrom ??
                                              "تبدا الرحله من",
                                          style: TextStyle(
                                            color: _staticVar.secondaryColor,
                                            fontSize: _staticVar.subTitleFontSize.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80.w,
                                          child: Text(
                                            transfer.pickUpLocation ?? "",
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: _staticVar.titleFontSize.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)?.transfinalDestination ??
                                              "الوجهة النهائية",
                                          style: TextStyle(
                                            color: _staticVar.secondaryColor,
                                            fontSize: _staticVar.subTitleFontSize.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80.w,
                                          child: Text(
                                            transfer.dropOffLocation ?? "",
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: _staticVar.titleFontSize.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ))
                  .asGlass(
                      blurX: 15,
                      blurY: 15,
                      tintColor: _staticVar.cardcolor,
                      clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
            ),
          ],
          Container(
            decoration: DottedDecoration(),
          ),
          SizedBox(height: 4.h),
          CustomBTN(
              onTap: () async {
                final result = await context.read<CustomizeController>().getTransferListing();

                if (result) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => const ChangeTransferScreen()));
                }
              },
              title: AppLocalizations.of(context)?.moreTransferOption ?? "تغيير المواصلات")
        ],
      ),
    );
  }

  Widget _buildIconWithTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          color: _staticVar.secondaryColor,
          size: 20,
        ),
        SizedBox(width: 1.w),
        Text(
          title,
          style: TextStyle(color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp),
        )
      ],
    );
  }

  bool activateActivitySection = false;
  Widget _buildActivity() {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
      ),
      child: Column(
        children: [],
      ),
    );
  }

  Widget _buildEsim(Esim esim) {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EsimView(
            esim: esim,
          ),
          SizedBox(height: 1.h),
          Container(
            decoration: DottedDecoration(),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: 95.w,
            child: CustomBTN(
              onTap: () async {
                await context.read<CustomizeController>().getEsimListing();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const ChangeEsimView()));
              },
              title: AppLocalizations.of(context)?.moreESIMOption ?? "تغيير شريحه الاتصال",
            ),
          ),
        ],
      ),
    );
  }

  String dateFormat(date) {
    String text = "";

    if (date is String) {
      final tempDate = DateFormat().parse(date);
      text = DateFormat("MMMM dd, y", context.read<UserController>().locale.languageCode)
          .format(tempDate);
    } else {
      text =
          DateFormat("MMMM dd, y", context.read<UserController>().locale.languageCode).format(date);
    }

    return text;
  }

  collectPassengerData() async {
    if (context.read<UserController>().userModel != null) {
      final pack = context.read<CustomizeController>().packageCustomize;
      context.read<PrebookController>().getCustomizeData(pack!);
      context.read<PrebookController>().preparePassengers();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrebookStepper()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginScreen(fromCustomize: true)));
    }
  }

  bool isContainOnlyOneService() {
    final pack = context.read<CustomizeController>().packageCustomize;
    int serviceCount = 0;

    if (pack?.result?.flight != null) serviceCount++;
    if ((pack?.result?.hotels ?? []).isNotEmpty) serviceCount++;
    if ((pack?.result?.transfer ?? []).isNotEmpty) serviceCount++;
    if ((pack?.result?.activities ?? {}).isNotEmpty) serviceCount++;
    if (pack?.result?.esim != null) serviceCount++;

    return serviceCount == 1;
  }
}
