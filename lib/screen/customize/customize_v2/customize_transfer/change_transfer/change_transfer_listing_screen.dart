import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';

import '../../../../../model/customize_models/transfer_model/transfer_listing_model.dart';
import '../../../../widgets/custom_btn.dart';
import '../../../../widgets/custom_container.dart';
import '../../../../widgets/custom_image.dart';

class ChangeTransferScreen extends StatefulWidget {
  const ChangeTransferScreen({super.key});

  @override
  State<ChangeTransferScreen> createState() => _ChangeTransferScreenState();
}

class _ChangeTransferScreenState extends State<ChangeTransferScreen> {
  bool isUserSelectingOutTransfer = false;
  Map<String, In?> selectedTransfer = {"In": null, "Out": null};
  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: _staticVar.primaryColor,
        title: Text(
          AppLocalizations.of(context)?.moreTransferOption ?? "خيارات اخري للمواصلات",
          style: TextStyle(fontSize: _staticVar.titleFontSize.sp),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: Consumer<CustomizeController>(builder: (context, data, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSelectedTransfer(selectedTransfer["In"], "In"),
                  _buildSelectedTransfer(selectedTransfer["Out"], "Out"),
                ],
              ),
              SizedBox(height: 1.h),
              Text(isUserSelectingOutTransfer
                  ? AppLocalizations.of(context)?.transFromHToA ?? "رحله من الفندق الي المطار"
                  : AppLocalizations.of(context)?.transFromAToH ?? "رحله من المطار الي الفندق"),
              SizedBox(height: 1.h),
              Expanded(
                child: ListView(
                  children: isUserSelectingOutTransfer
                      ? [
                          for (var transfer in data.transferListModel?.data?.out ?? <In>[])
                            _buildTransfer(transfer, isInTransfer: false)
                        ]
                      : [
                          for (var transfer in data.transferListModel?.data?.dataIn ?? <In>[])
                            _buildTransfer(transfer, isInTransfer: true)
                        ],
                ),
              ),
            ],
          );
        }),
      )),
    );
  }

  Widget _buildSelectedTransfer(In? transfer, String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (key == "In") {
            isUserSelectingOutTransfer = false;
          } else {
            isUserSelectingOutTransfer = true;
          }
        });
      },
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: _staticVar.gray.withAlpha(100),
            ),
            borderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
        child: transfer == null
            ? Icon(
                Icons.add,
                color: _staticVar.gray.withAlpha(100),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImage(
                    url: transfer.images ?? '',
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    transfer.name ?? '',
                    style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                  )
                ],
              ),
      ),
    );
  }

  Widget _buildTransfer(In transfer, {required bool isInTransfer}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: _staticVar.defaultPadding, horizontal: _staticVar.defaultPadding),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
        color: _staticVar.cardcolor,
        boxShadow: [_staticVar.shadow],
      ),
      child: CustomContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                      "${transfer.name ?? ""} ",
                      style: TextStyle(
                        color: _staticVar.gray,
                        fontSize: _staticVar.subTitleFontSize.sp,
                      ),
                    ),
                  ],
                ),
                CustomImage(
                  url: transfer.images ?? "",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBTN(
                    onTap: () async {
                      StaticVar.showIndicator();
                      Future.delayed(const Duration(seconds: 1), () {
                        StaticVar.hideIndicator();
                      });
                      if (isInTransfer) {
                        selectedTransfer["In"] = transfer;
                        isUserSelectingOutTransfer = true;
                      } else {
                        selectedTransfer["Out"] = transfer;
                      }
                      setState(() {});

                      if (!isInTransfer && (selectedTransfer.containsValue(null) == false)) {
                        final result = await context.read<CustomizeController>().updateTransfer(
                            inTransferId: selectedTransfer["In"]?.id ?? '',
                            outTransferId: selectedTransfer["Out"]?.id ?? '');

                        if (result) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    title: AppLocalizations.of(context)?.select ?? "تغيير المواصلات"),
                Text(
                  "${(transfer.priceDifference ?? 0).toString()} ${transfer.currency}",
                  style: TextStyle(
                      color: (transfer.priceDifference ?? 0).isNegative
                          ? _staticVar.greenColor
                          : _staticVar.redColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
