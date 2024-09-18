import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:umrah_by_lamar/common/custom_extension.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../model/user_models/user_model.dart';
import 'edit_passenger_data.dart';

class UserPassengersView extends StatefulWidget {
  const UserPassengersView({super.key});

  @override
  State<UserPassengersView> createState() => _UserPassengersViewState();
}

class _UserPassengersViewState extends State<UserPassengersView> {
  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text(AppLocalizations.of(context)?.passengers ?? "Passengers"),
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        titleTextStyle:
            TextStyle(fontSize: _staticVar.titleFontSize.sp, color: _staticVar.primaryColor),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<UserController>(builder: (context, data, child) {
          if ((data.userModel?.data?.passengersDetails ?? <PassengersDetail>[]).isEmpty) {
            return const Center(child: Text("The are no saved  passenger yet"));
          } else {
            return ListView(
              children: [
                for (var pass in data.userModel?.data?.passengersDetails ?? <PassengersDetail>[])
                  _buildPassenger(pass)
              ],
            );
          }
        }),
      )),
    );
  }

  // Widget _buildPassenger(PassengersDetail passenger) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
  //     decoration: BoxDecoration(boxShadow: [
  //       BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           blurRadius: 5,
  //           spreadRadius: 2,
  //           offset: const Offset(1, 1))
  //     ], color: _staticVar.cardcolor),
  //     padding: EdgeInsets.all(_staticVar.defaultPadding),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: EdgeInsets.all(_staticVar.defaultPadding),
  //               decoration: BoxDecoration(
  //                 color: _staticVar.gray.withAlpha(100),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(
  //                 Icons.person,
  //                 color: _staticVar.gray,
  //               ),
  //             ),
  //             SizedBox(width: 3.w),
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "${(passenger.name ?? "").capitalize()} ${passenger.surname ?? ''}",
  //                   style: TextStyle(
  //                       fontSize: _staticVar.titleFontSize.sp,
  //                       fontWeight: _staticVar.titleFontWeight),
  //                 ),
  //                 SizedBox(height: 0.5.h),
  //                 Text(
  //                   passenger.personType ?? '',
  //                   style:
  //                       TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.gray),
  //                 )
  //               ],
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                     builder: (context) => EditPassengerData(passenger: passenger)));
  //               },
  //               child: Container(
  //                 padding: EdgeInsets.all(_staticVar.defaultPadding),
  //                 decoration: BoxDecoration(shape: BoxShape.circle, color: _staticVar.primaryColor),
  //                 child: Icon(
  //                   Icons.edit,
  //                   size: 16,
  //                   color: _staticVar.cardcolor,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 4.w),
  //             GestureDetector(
  //               onTap: () async {
  //                 final result = await showDialog<bool>(
  //                     context: context,
  //                     builder: (context) => AlertDialog(
  //                           content: Text(
  //                             AppLocalizations.of(context)!.rUSureToRemovePassenger,
  //                             style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
  //                           ),
  //                           actions: [
  //                             TextButton(
  //                                 onPressed: () {
  //                                   Navigator.of(context).pop(false);
  //                                 },
  //                                 child: Text(
  //                                   AppLocalizations.of(context)!.cancel,
  //                                   style: TextStyle(
  //                                     color: _staticVar.greenColor,
  //                                   ),
  //                                 )),
  //                             TextButton(
  //                                 onPressed: () async {
  //                                   Navigator.of(context).pop(true);
  //                                 },
  //                                 child: Text(
  //                                   AppLocalizations.of(context)!.remove,
  //                                   style: TextStyle(
  //                                     color: _staticVar.redColor,
  //                                   ),
  //                                 ))
  //                           ],
  //                         ));
  //                 if (!mounted) return;
  //                 if ((result ?? false)) {
  //                   final isDeleted = await context
  //                       .read<UserController>()
  //                       .removeUserPassenger(id: (passenger.id ?? 0).toInt());
  //                   if (!mounted) return;
  //                   if (isDeleted) {
  //                     _staticVar.showToastMessage(
  //                         message: AppLocalizations.of(context)?.deleteSuccess ??
  //                             "Passenger has been deleted successfully");
  //                   } else {
  //                     _staticVar.showToastMessage(
  //                         message: AppLocalizations.of(context)?.deleteFailed ??
  //                             "Failed to delete this passenger");
  //                   }
  //                 }
  //               },
  //               child: Container(
  //                 padding: EdgeInsets.all(_staticVar.defaultPadding),
  //                 decoration: BoxDecoration(shape: BoxShape.circle, color: _staticVar.redColor),
  //                 child: Icon(
  //                   Icons.delete,
  //                   size: 16,
  //                   color: _staticVar.cardcolor,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPassenger(PassengersDetail passenger) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(1, 1))
      ], color: _staticVar.cardcolor),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(_staticVar.defaultPadding),
                    decoration: BoxDecoration(
                      color: _staticVar.gray.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: _staticVar.gray,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${(passenger.name ?? "").capitalize()} ${passenger.surname ?? ''}",
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp,
                            fontWeight: _staticVar.titleFontWeight),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        passenger.personType ?? '',
                        style: TextStyle(
                            fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.gray),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditPassengerData(passenger: passenger)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: _staticVar.primaryColor),
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: _staticVar.cardcolor,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () async {
                      final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text(
                                  AppLocalizations.of(context)!.rUSureToRemovePassenger,
                                  style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: TextStyle(
                                          color: _staticVar.greenColor,
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.remove,
                                        style: TextStyle(
                                          color: _staticVar.redColor,
                                        ),
                                      ))
                                ],
                              ));

                      if (!mounted) return;
                      if ((result ?? false)) {
                        final isDeleted = await context
                            .read<UserController>()
                            .removeUserPassenger(id: (passenger.id ?? 0).toInt());
                        if (!mounted) return;

                        if (isDeleted) {
                          _staticVar.showToastMessage(
                              message: AppLocalizations.of(context)?.deleteSuccess ??
                                  "Passenger has been deleted successfully");
                        } else {
                          _staticVar.showToastMessage(
                              message: AppLocalizations.of(context)?.deleteFailed ??
                                  "Failed to delete this passenger");
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(_staticVar.defaultPadding),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: _staticVar.redColor),
                      child: Icon(
                        Icons.delete,
                        size: 16,
                        color: _staticVar.cardcolor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            "Email: ${passenger.email ?? 'N/A'}",
            style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.gray),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Phone: ${passenger.phone ?? 'N/A'}",
            style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.gray),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Passport Number: ${passenger.passportNumber ?? 'N/A'}",
            style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.gray),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Nationality: ${passenger.nationality ?? 'N/A'}",
            style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.gray),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Date of Birth: ${_formatDate(passenger.dateOfBirth)}",
            style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.gray),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    return DateFormat('dd-MMM-y').format(date);
  }
}
