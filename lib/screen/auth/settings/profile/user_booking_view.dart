import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../model/user_models/user_bookings_data.dart';
import 'cancellation_booking_view.dart';

class UserBookingsView extends StatefulWidget {
  const UserBookingsView({super.key});

  @override
  State<UserBookingsView> createState() => _UserBookingsViewState();
}

class _UserBookingsViewState extends State<UserBookingsView> {
  final _staticVar = StaticVar();

  List<String> cancellationReasons = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.myBooking ?? "My booking",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        elevation: 0.2,
        foregroundColor: _staticVar.primaryColor,
        backgroundColor: _staticVar.cardcolor,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<UserController>(builder: (context, data, child) {
          if ((data.userBookingsDataModel?.data ?? <BookingData>[]).isEmpty) {
            return const Center(child: Text("The are no booking yet"));
          } else {
            return ListView(
              children: [
                for (var booking in data.userBookingsDataModel?.data ?? <BookingData>[])
                  _buildBooking(booking)
              ],
            );
          }
        }),
      )),
    );
  }

  Widget _buildBooking(BookingData booking) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        boxShadow: [_staticVar.shadow],
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
        color: _staticVar.cardcolor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${AppLocalizations.of(context)?.serviceDate ?? "Service date"}\n${dateFormatter(booking.startDate ?? DateTime.now())}",
                style: TextStyle(
                  fontSize: _staticVar.subTitleFontSize.sp,
                ),
              ),
              Text(
                "${AppLocalizations.of(context)?.bookingDate ?? "Booking date"}\n${dateFormatter(booking.bookingDate ?? DateTime.now())}",
                style: TextStyle(
                  fontSize: _staticVar.subTitleFontSize.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            "${AppLocalizations.of(context)?.bookingNo ?? 'Booking No: '} ${booking.bookingNumber}",
            style: TextStyle(
              fontSize: _staticVar.subTitleFontSize.sp,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            booking.packageName ?? '',
            style: TextStyle(
                fontSize: _staticVar.titleFontSize.sp,
                color: _staticVar.primaryColor,
                fontWeight: _staticVar.titleFontWeight),
          ),
          SizedBox(height: 2.h),
          (booking.flight ?? []).isEmpty
              ? const SizedBox()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.flight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      children: [
                        for (var service in booking.flight ?? <ServiceData>[])
                          Text((service.serviceDescription ?? '').replaceAll('), ', '),\n'))
                      ],
                    )
                  ],
                ),
          SizedBox(height: 1.h),
          (booking.hotel ?? []).isEmpty
              ? const SizedBox()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.hotel, size: 20),
                    SizedBox(width: 2.w),
                    Column(
                      children: [
                        for (var service in booking.hotel ?? <BookedHotel>[])
                          SizedBox(
                            width: 85.w,
                            child: Text(
                              '${service.serviceName!}, ${service.serviceDescription!}',
                              style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
          (booking.activity ?? []).isEmpty
              ? const SizedBox()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.sim_card,
                      size: 20,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    SizedBox(
                      width: 80.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var service in booking.activity ?? <ServiceData>[])
                            Text(
                              '${service.serviceDescription ?? ''}\n ${AppLocalizations.of(context)!.ins} ${service.serviceName ?? ''}',
                              style: TextStyle(fontSize: _staticVar.subTitleFontSize),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
          (booking.transfer ?? []).isEmpty
              ? const SizedBox()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.directions_car, size: 20),
                    SizedBox(width: 2.w),
                    SizedBox(
                      width: 80.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var service in booking.transfer ?? <ServiceData>[])
                            Text(
                              '${service.serviceDescription ?? ''}\n ${AppLocalizations.of(context)!.ins} ${service.serviceName ?? ''}',
                              style: TextStyle(fontSize: _staticVar.subTitleFontSize),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
          (booking.esim ?? []).isEmpty
              ? const SizedBox()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.sim_card,
                      size: 20,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    SizedBox(
                      width: 80.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var service in booking.esim ?? <ServiceData>[])
                            Text(
                              '${service.serviceDescription ?? ''}\n ${AppLocalizations.of(context)!.ins} ${service.serviceName ?? ''}',
                              style: TextStyle(fontSize: _staticVar.subTitleFontSize),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
          const Divider(),
          ((booking.discountAmount?.contains('0') ?? false) == false)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.discount,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: _staticVar.titleFontSize,
                          color: Colors.black,
                        )),
                    RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                          text: '${booking.currency ?? ' '} ',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: _staticVar.titleFontSize,
                              color: Colors.black),
                          children: [
                            TextSpan(
                                text: booking.discountAmount,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: _staticVar.titleFontSize,
                                    color: Colors.redAccent,
                                    decoration: TextDecoration.lineThrough)),
                          ]),
                    ),
                  ],
                )
              : const SizedBox(),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.paidFromCredit,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: _staticVar.titleFontSize,
                    color: Colors.black,
                  )),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                    text: '${booking.currency ?? ' '} ',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: _staticVar.titleFontSize,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: booking.creditBalanceUsed,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: _staticVar.titleFontSize,
                            color: _staticVar.greenColor,
                          )),
                    ]),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.paidAmount,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: _staticVar.titleFontSize,
                    color: Colors.black,
                  )),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                    text: '${booking.currency ?? ' '} ',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: _staticVar.titleFontSize,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: booking.amountPayed,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: _staticVar.titleFontSize,
                              color: _staticVar.greenColor)),
                    ]),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: booking.status == 'CONFIRMED' ? Colors.lightGreen[100] : Colors.orange[100],
                child: Text(
                  booking.expired! ? AppLocalizations.of(context)!.expired : booking.status!,
                  style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                ),
              ),
              (booking.status == 'CONFIRMED')
                  ? ElevatedButton(
                      onPressed: () {
                        cancelbooking(booking);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent, fixedSize: Size(40.w, 3.h)),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  String dateFormatter(DateTime date) => DateFormat('dd/MM/y').format(date);

  cancelbooking(BookingData booking) async {
    final result =
        await context.read<UserController>().getBookingCancellationPolicy(booking.bookingNumber);

    if (result != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CancellBookingView(
              cancellationPolicy: result, bookingREF: booking.bookingNumber ?? '')));
    }
  }
}
