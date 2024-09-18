import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/custom_extension.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/customize_controller.dart';
import '../../../controller/prebook_controller.dart';
import '../../../controller/search_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../model/search_models/search_result_models/search_result_model.dart';
import '../../auth/login.dart';
import '../../prebook/prebook_stepper.dart';
import '../../widgets/custom_btn.dart';

class TransferResultScreen extends StatefulWidget {
  const TransferResultScreen({super.key});

  @override
  State<TransferResultScreen> createState() => _TransferResultScreenState();
}

class _TransferResultScreenState extends State<TransferResultScreen> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.transfers ?? "Transfer",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
        elevation: 0.3,
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<PackSearchController>(builder: (context, data, child) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${dateFormatter(data.searchResultModel?.data?.searchData?.packageStart ?? '')} - ${dateFormatter(data.searchResultModel?.data?.searchData?.packageEnd ?? '')}",
                      style: TextStyle(
                          fontWeight: _staticVar.titleFontWeight,
                          fontSize: _staticVar.subTitleFontSize.sp),
                    ),
                    Text(
                      data.searchResultModel?.data?.searchData?.toCity ?? "",
                      style: TextStyle(
                          fontWeight: _staticVar.titleFontWeight,
                          fontSize: _staticVar.subTitleFontSize.sp),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (var transfer in data.searchResultModel?.data?.packages ?? <Package>[])
                      _buildTransferCard(transfer)
                  ],
                ),
              ),
            ],
          );
        }),
      )),
    );
  }

  String dateFormatter(String date) =>
      DateFormat('EEE, dd MMM').format(DateFormat('dd/MM/y').parse(date));

  Widget _buildTransferCard(Package transfer) {
    return Container(
      margin: EdgeInsets.all(_staticVar.defaultPadding),
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
          for (var trans in transfer.transfer ?? <Transfer>[])
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImage(
                      url: trans.image ?? '',
                      width: 30.w,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${(trans.productTypeName ?? "").capitalize()} ${(trans.serviceTypeName ?? '').capitalize()} ${trans.vehicleTypeName}",
                          style: TextStyle(
                              fontSize: _staticVar.titleFontSize.sp,
                              fontWeight: _staticVar.titleFontWeight),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: _staticVar.primaryColor, size: 18),
                            SizedBox(width: 1.w),
                            Text(
                              trans.pickup ?? "",
                              style: TextStyle(
                                fontSize: _staticVar.subTitleFontSize.sp,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Icon(Icons.my_location, color: _staticVar.redColor, size: 18),
                            SizedBox(width: 1.w),
                            Text(
                              trans.dropoff ?? "",
                              style: TextStyle(
                                fontSize: _staticVar.subTitleFontSize.sp,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Icon(Icons.date_range, color: _staticVar.blackColor, size: 18),
                            SizedBox(width: 1.w),
                            Text(
                              "${DateFormat('EEE, dd MMM').format(trans.date ?? DateTime.now())} / ${(trans.time ?? "        ").replaceRange(5, 8, "")}",
                              style: TextStyle(
                                fontSize: _staticVar.subTitleFontSize.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                      ],
                    )
                  ],
                ),
                Divider()
              ],
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: 100.w),
              ((transfer.oldPrice == null) || (transfer.oldPrice ?? 0) < 1)
                  ? const SizedBox()
                  : Text(
                      (transfer.oldPrice ?? 0).toString(),
                      style: TextStyle(
                        color: _staticVar.redColor,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2,
                      ),
                    ),
              SizedBox(height: 1.h),
              Text(
                  "${(transfer.total ?? 0).toString()} ${transfer.sellingCurrency ?? UtilityVar.genCurrency}",
                  style: TextStyle(
                      fontWeight: _staticVar.titleFontWeight,
                      color: _staticVar.greenColor,
                      fontSize: _staticVar.titleFontSize.sp)),
            ],
          ),
          SizedBox(height: 1.h),
          Align(
            alignment: Alignment.centerRight,
            child: CustomBTN(
                onTap: () async {
                  final result =
                      await context.read<CustomizeController>().customizePackage(transfer.id ?? "");

                  if (result == false) return;

                  if (!mounted) return;
                  if (context.read<UserController>().userModel != null) {
                    final pack = context.read<CustomizeController>().packageCustomize;
                    context.read<PrebookController>().getCustomizeData(pack!);
                    context.read<PrebookController>().preparePassengers();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const PrebookStepper()));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen(fromCustomize: true)));
                  }
                },
                title: AppLocalizations.of(context)?.bookNow ?? ""),
          )
        ],
      ),
    );
  }
}
