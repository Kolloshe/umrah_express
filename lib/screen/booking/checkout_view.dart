import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:umrah_by_lamar/common/custom_extension.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../model/prebook_models/prebook_pricing_details_model.dart';
import '../../model/prebook_models/prebook_result_model.dart';
import '../widgets/custom_pdf_view.dart';
import 'payment_web_view/card_payment_web_view.dart';
import 'payment_web_view/coin_payment_web_view.dart';

enum PaymentMethod { card, coin, creditAmount }

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _staticVar = StaticVar();

  final couponController = TextEditingController();

  PaymentMethod? paymentMethod = PaymentMethod.coin;

  PrebookPricingDetails? pricingDetails;

  bool partialAmountWithCredit = false;

  Duration? currentDuration = const Duration(minutes: 15);

  @override
  void initState() {
    getPricing();
    super.initState();
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.2,
          backgroundColor: _staticVar.cardcolor,
          foregroundColor: _staticVar.primaryColor,
          title: Text(
            AppLocalizations.of(context)?.bookingSummary ?? "",
            style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
          )),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(_staticVar.defaultPadding),
          child: Consumer<PrebookController>(builder: (context, data, child) {
            return ListView(
              padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
              children: [
                (data.prebookResultModel?.data?.details?.hotel?.isNotEmpty ?? false)
                    ? SizedBox(
                        width: 100.w,
                        child: Stack(
                          children: [
                            CustomImage(
                                height: 45.h,
                                width: 100.w,
                                withRadius: true,
                                boxFit: BoxFit.cover,
                                url: data.prebookResultModel?.data?.details?.hotel?.first
                                        .hotelImage ??
                                    ''),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(_staticVar.defaultPadding),
                                child: _buildTitle(
                                    data.prebookResultModel?.data?.details,
                                    data.prebookResultModel?.data?.payment?.finalSellingAmount ??
                                        ""),
                              ).asGlass(
                                  clipBorderRadius:
                                      BorderRadius.circular(_staticVar.defaultRadius)),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                SizedBox(height: 1.h),
                SizedBox(
                    width: 100.w,
                    height: 6.h,
                    child: CustomBTN(
                        onTap: () async {
                          final result = await context
                              .read<PrebookController>()
                              .getPackageCancellationPrice(context
                                      .read<PackSearchController>()
                                      .searchResultModel
                                      ?.data
                                      ?.packageId ??
                                  '');
                          if (result.isEmpty) return;

                          if (!mounted) return;

                          showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (_) => Container(
                                    padding: EdgeInsets.all(_staticVar.defaultPadding),
                                    decoration: BoxDecoration(
                                        color: _staticVar.cardcolor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(_staticVar.defaultRadius),
                                            topRight: Radius.circular(_staticVar.defaultRadius))),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 2.h),
                                        Text(
                                          AppLocalizations.of(context)!.currentRefundableAmount(
                                              result['total'].toString(), result['currency']),
                                          style: TextStyle(
                                            fontSize: _staticVar.titleFontSize.sp,
                                            fontWeight: _staticVar.titleFontWeight,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                      ],
                                    ),
                                  ));
                        },
                        title: AppLocalizations.of(context)?.cancellationPolicy ?? "")),
                SizedBox(height: 1.h),
                _buildPackageIncludes(data.prebookResultModel?.data),
                SizedBox(height: 1.h),
                _buildCoupon(),
                SizedBox(height: 1.h),
                _buildPaymentSelection(),
                SizedBox(height: 1.h),
                _buildOrderSummary(),
                SizedBox(height: 1.h),
                _buildAcceptTerms()
              ],
            );
          }),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        width: 100.w,
        height: 9.h,
        child: Column(
          children: [
            SizedBox(
              width: 100.w,
              height: 5.h,
              child: CustomBTN(
                color: isAcceptTermsAndPolicy ? _staticVar.primaryColor : _staticVar.gray,
                onTap: () {
                  proceedToPayment();
                },
                title: AppLocalizations.of(context)?.payNow ?? "Pay now",
              ),
            ),
            SizedBox(height: 2.h)
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(DataDetails? details, String amount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${(AppLocalizations.of(context)?.totalPACKAGEPRICE ?? " TOTAL PACKAGE PRICE").trimLeft().capitalize()}"
          "${(AppLocalizations.of(context)?.fors ?? " for")}"
          " - ${(AppLocalizations.of(context)?.adultCount((details?.adultsCount ?? 1)))}"
          " ${(AppLocalizations.of(context)?.childCount((details?.childrenCount ?? 0)))}",
          style: TextStyle(
              color: _staticVar.secondaryColor,
              fontSize: _staticVar.titleFontSize.sp,
              fontWeight: _staticVar.titleFontWeight),
        ),
        SizedBox(height: 0.5.h),
        Text(
          "${(((details?.totalAmount ?? 0) == 0) ? amount : (details?.totalAmount ?? 0)).toString()} ${UtilityVar.genCurrency}",
          style: TextStyle(
              color: _staticVar.greenColor,
              fontSize: _staticVar.titleFontSize.sp,
              fontWeight: _staticVar.titleFontWeight),
        ),
        SizedBox(height: 0.5.h),
        Text(
          "${AppLocalizations.of(context)!.nightCount((details?.packageDays ?? 2) - 1)} ${AppLocalizations.of(context)!.dayCount((details?.packageDays ?? 0))}",
          style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
        ),
        SizedBox(height: 0.5.h),
        SizedBox(
          width: 100.w,
          child: Text(
            details?.packageName ?? "",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildPackageIncludes(Data? data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.alsoIncludes ?? "ALSO INCLUDES",
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
            fontWeight: _staticVar.titleFontWeight,
          ),
        ),
        SizedBox(height: 2.h),
        if ((data?.details?.noFlights ?? false) == false) ...[
          _buildServiceTitleWithIcon(
              icon: Icons.flight, title: AppLocalizations.of(context)?.flight ?? ""),
          Container(
            width: 100.w,
            padding: EdgeInsets.symmetric(
                horizontal: _staticVar.defaultPadding * 2, vertical: _staticVar.defaultPadding),
            child: Stack(
              children: [
                Positioned(
                    left: context.read<UserController>().isAR() ? 0 : null,
                    right: context.read<UserController>().isAR() ? null : 0,
                    bottom: 0,
                    top: 0,
                    child: Icon(
                      Icons.flight,
                      color: _staticVar.secondaryColor,
                      size: 100,
                    )),
                Container(
                  width: 100.w,
                  height: 12.h,
                  padding: EdgeInsets.all(_staticVar.defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (data?.details?.flight?.travelData ?? []).length <= 1
                          ? Text(AppLocalizations.of(context)?.onWayFlight ?? '')
                          : Text(AppLocalizations.of(context)?.roundTrip ?? ""),
                      SizedBox(height: 1.h),
                      //((data?.details?.flight?.travelData ?? <TravelDatum>[])
                      // .map((e) => e.carriers ?? <Carrier>[])
                      // .toList())
                      // .expand((element) => element)
                      // .map((e) => e.name)
                      // .join(' , ')
                      for (var flightData in data?.details?.flight?.travelData ?? <TravelDatum>[])
                        Text(
                            "${flightData.carriers!.map((e) => e.name).toList().join(' ')} on ${DateFormat('MMM dd, y').format(flightData.start!.date!)}"),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ).asGlass(
                    blurX: 5,
                    blurY: 5,
                    clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius)),
              ],
            ),
          ),
          const Divider()
        ],
        if ((data?.details?.noHotels ?? false) == false) ...[
          _buildServiceTitleWithIcon(
              icon: Icons.hotel, title: AppLocalizations.of(context)?.hotels ?? ""),
          for (var hotel in data?.details?.hotel ?? <Hotel>[])
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _staticVar.defaultPadding * 2, vertical: _staticVar.defaultPadding),
              child: Stack(
                children: [
                  Positioned(
                      left: context.read<UserController>().isAR() ? 2 : null,
                      right: context.read<UserController>().isAR() ? null : 3,
                      bottom: 0,
                      top: 0,
                      child: Icon(
                        Icons.hotel,
                        color: _staticVar.secondaryColor,
                        size: 100,
                      )),
                  Container(
                          padding: EdgeInsets.all(_staticVar.defaultPadding),
                          alignment: context.read<UserController>().isAR()
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          width: 100.w,
                          height: 12.h,
                          child: Text(hotel.name ?? ""))
                      .asGlass(
                          clipBorderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                          blurX: 5,
                          blurY: 5),
                ],
              ),
            ),
          const Divider()
        ],
        // if ((data?.details?.noActivities ?? false) == false) ...[
        //   _buildServiceTitleWithIcon(
        //       icon: Icons.directions_walk, title: AppLocalizations.of(context)?.activities ?? ""),
        //   for (var activity in data?.details?.activities?.name ?? <String>[])
        //     Container(
        //       padding: EdgeInsets.symmetric(
        //           horizontal: _staticVar.defaultPadding * 2, vertical: _staticVar.defaultPadding),
        //       child: Text(activity),
        //     ),
        //   const Divider()
        // ],
        if ((data?.details?.noTransfers ?? false) == false) ...[
          _buildServiceTitleWithIcon(
              icon: Icons.directions_car, title: AppLocalizations.of(context)?.transfer ?? ""),
          Padding(
            padding: EdgeInsets.all(_staticVar.defaultPadding * 2),
            child: Stack(
              children: [
                Positioned(
                    left: context.read<UserController>().isAR() ? 0 : null,
                    right: context.read<UserController>().isAR() ? null : 0,
                    bottom: 0,
                    top: 0,
                    child: Icon(
                      Icons.directions_car,
                      color: _staticVar.secondaryColor,
                      size: 90,
                    )),
                Container(
                  // padding: EdgeInsets.all(_staticVar.defaultPadding),
                  height: 11.h,
                  width: 100.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var transfer in data?.details?.transfer ?? <Transfer>[])
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: _staticVar.defaultPadding * 2,
                              vertical: _staticVar.defaultPadding),
                          child: Text("${transfer.serviceTypeName ?? ""} ${transfer.type ?? ""}"),
                        ),
                    ],
                  ),
                ).asGlass(
                    clipBorderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                    blurX: 5,
                    blurY: 5)
              ],
            ),
          ),
          const Divider()
        ],
        if ((data?.details?.noEsim ?? false) == false) ...[
          _buildServiceTitleWithIcon(
              icon: Icons.sim_card, title: AppLocalizations.of(context)?.esimCard ?? ""),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: _staticVar.defaultPadding * 2, vertical: _staticVar.defaultPadding),
            child: Text(data?.details?.esim?.name ?? ""),
          ),
          const Divider()
        ],
      ],
    );
  }

  Widget _buildServiceTitleWithIcon({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          color: _staticVar.primaryColor,
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
        ),
      ],
    );
  }

  Widget _buildCoupon() {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
          border: Border.all(
            color: _staticVar.primaryColor,
            width: 1,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/icons/coupontick.png',
            color: _staticVar.primaryColor,
            width: 5.w,
          ),
          SizedBox(
              width: 50.w,
              height: 7.h,
              child: CustomUserForm(
                  withShadow: true,
                  hintText: AppLocalizations.of(context)?.couponCode ?? "Coupon code")),
          GestureDetector(
            onTap: () {
              applyCoupon();
            },
            child: Text(
              AppLocalizations.of(context)?.coupon ?? "",
              style: TextStyle(
                  fontSize: _staticVar.subTitleFontSize.sp,
                  fontWeight: _staticVar.titleFontWeight,
                  color: _staticVar.primaryColor),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return GestureDetector(
      onTap: () async {
        await context.read<PrebookController>().updatePackagePrice(PaymentMethod.coin);
      },
      child: Container(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
            border: Border.all(
              color: _staticVar.primaryColor,
              width: 1,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.orderSummary ?? "Order summary",
              style: TextStyle(
                fontSize: _staticVar.titleFontSize.sp,
                color: _staticVar.primaryColor,
                fontWeight: _staticVar.titleFontWeight,
              ),
            ),
            SizedBox(height: 1.h),
            priceWithTitle(
                title: AppLocalizations.of(context)?.initialAmount ?? "Initial amount",
                price:
                    "${pricingDetails?.data?.paymentDetails?.packageAmountWithoutAnyDiscount ?? ""} ${pricingDetails?.data?.paymentDetails?.userCurrency ?? ""}"),
            const Divider(),
            if ((double.tryParse(
                        pricingDetails?.data?.paymentDetails?.discounts?.totalDiscount?.amount ??
                            "0") ??
                    0) >
                0) ...[
              priceWithTitle(
                  title: AppLocalizations.of(context)?.discount ?? "Discount",
                  price:
                      "${pricingDetails?.data?.paymentDetails?.discounts?.totalDiscount?.amount ?? ""} ${pricingDetails?.data?.paymentDetails?.userCurrency ?? ""}"),
              const Divider(),
            ],
            if ((double.tryParse(pricingDetails
                            ?.data?.paymentDetails?.discounts?.gamePointsDiscount?.amount ??
                        "0") ??
                    0) >
                0) ...[
              priceWithTitle(
                  title: AppLocalizations.of(context)?.gameDiscount ?? "Game discount",
                  price:
                      "${pricingDetails?.data?.paymentDetails?.discounts?.gamePointsDiscount?.amount ?? ""} ${pricingDetails?.data?.paymentDetails?.userCurrency ?? ""}"),
              const Divider(),
            ],
            if ((double.tryParse(pricingDetails?.data?.paymentDetails?.transactionFees ?? "0") ??
                    0) >
                0) ...[
              priceWithTitle(
                  title: AppLocalizations.of(context)?.transactionFees ?? "Transaction fees",
                  price:
                      "${pricingDetails?.data?.paymentDetails?.transactionFees ?? ""} ${pricingDetails?.data?.paymentDetails?.userCurrency ?? ""}"),
              const Divider(),
            ],
            priceWithTitle(
                title: AppLocalizations.of(context)?.totalP ?? "Total price",
                price:
                    "${pricingDetails?.data?.paymentDetails?.finalSellingAmount ?? ""} ${pricingDetails?.data?.paymentDetails?.userCurrency ?? ""}"),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSelection() {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: _staticVar.primaryColor),
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.paymentMethod ?? "Payment method",
            style: TextStyle(
              fontSize: _staticVar.titleFontSize.sp,
              color: _staticVar.primaryColor,
              fontWeight: _staticVar.titleFontWeight,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)?.card ?? 'Credit/Debit Cards ',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
              ),
              Radio.adaptive(
                  activeColor: _staticVar.primaryColor,
                  value: PaymentMethod.card,
                  groupValue: paymentMethod,
                  onChanged: (v) async {
                    paymentMethod = v;
                    if (paymentMethod != null) {
                      pricingDetails = await context
                          .read<PrebookController>()
                          .updatePackagePrice(paymentMethod!);
                    }
                    setState(() {});
                  })
            ],
          ),
          // SizedBox(height: 0.5.h),
          // const Divider(),
          // SizedBox(height: 0.5.h),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Text.rich(
          //       TextSpan(
          //           text: AppLocalizations.of(context)?.cryptoCurrency ?? 'Coinbase ',
          //           children: [
          //             TextSpan(
          //                 text: 'pay by Crypto currency',
          //                 style: TextStyle(
          //                     fontSize: _staticVar.subTitleFontSize.sp,
          //                     color: _staticVar.gray,
          //                     fontWeight: _staticVar.subTitleFontWeight))
          //           ]),
          //       style: TextStyle(
          //           fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
          //     ),
          //     Radio.adaptive(
          //         activeColor: _staticVar.primaryColor,
          //         value: PaymentMethod.coin,
          //         groupValue: paymentMethod,
          //         onChanged: (v) async {
          //           paymentMethod = v;
          //           if (paymentMethod != null) {
          //             pricingDetails = await context
          //                 .read<PrebookController>()
          //                 .updatePackagePrice(paymentMethod!);
          //           }
          //           setState(() {});
          //         }),
          //   ],
          // ),
          SizedBox(height: 0.5.h),
          const Divider(),
          if ((pricingDetails?.data?.paymentDetails?.payFullAmountByCredit ?? false) ||
              (pricingDetails?.data?.paymentDetails?.payPartialAmountByCredit ?? false)) ...[
            SizedBox(height: 0.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)?.useCreditBalance ?? 'Use you credit balance',
                  style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                      fontWeight: _staticVar.titleFontWeight),
                ),
                (pricingDetails?.data?.paymentDetails?.payFullAmountByCredit ?? false)
                    ? Radio.adaptive(
                        activeColor: _staticVar.primaryColor,
                        value: PaymentMethod.creditAmount,
                        groupValue: paymentMethod,
                        onChanged: (v) {
                          paymentMethod = v;
                          setState(() {});
                        },
                      )
                    : (pricingDetails?.data?.paymentDetails?.payPartialAmountByCredit ?? false)
                        ? Checkbox(
                            value: partialAmountWithCredit,
                            onChanged: (v) async {
                              partialAmountWithCredit = v ?? false;

                              pricingDetails = await context
                                  .read<PrebookController>()
                                  .applyCreditAmount(partialAmountWithCredit);
                              setState(() {});
                            })
                        : const SizedBox(),
              ],
            ),
          ],
          SizedBox(height: 2.h)
        ],
      ),
    );
  }

  bool isAcceptTermsAndPolicy = false;
  Widget _buildAcceptTerms() {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
          border: Border.all(color: _staticVar.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Checkbox(
              activeColor: _staticVar.primaryColor,
              value: isAcceptTermsAndPolicy,
              onChanged: (value) {
                isAcceptTermsAndPolicy = value ?? false;
                setState(() {});
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              //https://mapi2.ibookholiday.com/terms
              // 'https://mapi2.ibookholiday.com/privacy'
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PdfView(
                        isPDF: false,
                        url: 'https://mapi2.ibookholiday.com/privacy',
                        title: AppLocalizations.of(context)!.privacyPolicy,
                      )));
            },
            child: SizedBox(
              width: 80.w,
              child: RichText(
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                text: TextSpan(
                    text: AppLocalizations.of(context)?.iHaveReadAndAccept ??
                        "I have read and accept the ",
                    style: TextStyle(color: Colors.black, fontSize: _staticVar.titleFontSize.sp),
                    children: <TextSpan>[
                      TextSpan(
                        text: AppLocalizations.of(context)?.generalTerms ?? "general terms",
                        style: TextStyle(
                            color: _staticVar.primaryColor, fontSize: _staticVar.titleFontSize.sp),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)?.andCancellationPolicyConditions ??
                            " and cancellation policy conditions",
                        style: TextStyle(
                            color: _staticVar.blackColor, fontSize: _staticVar.titleFontSize.sp),
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  priceWithTitle({required String title, required String price}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
            fontWeight: _staticVar.titleFontWeight,
          ),
        ),
        Text(
          price,
          style: TextStyle(
              fontWeight: _staticVar.titleFontWeight, fontSize: _staticVar.titleFontSize.sp),
        )
      ],
    );
  }

  getPricing() async {
    if (paymentMethod == null) return;
    pricingDetails = await context.read<PrebookController>().updatePackagePrice(paymentMethod!);
  }

  void applyCoupon() {}

  proceedToPayment() {
    if (isAcceptTermsAndPolicy == false) return;
    final url = pricingDetails?.data?.paymentData?.paymentUrl ?? "";
    if (url.isEmpty) return;

    if (paymentMethod == PaymentMethod.coin) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CoinPaymentView(
              url: url,
              duration: currentDuration ?? const Duration(minutes: 2),
              id: pricingDetails?.data?.paymentData?.streamApi ?? "")));
    } else if (paymentMethod == PaymentMethod.card) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CardPaymentView(
                url: url,
                duration: currentDuration ?? const Duration(minutes: 2),
                streamApi: pricingDetails?.data?.paymentData?.streamApi ?? "",
              )));
    } else {}
  }
}
