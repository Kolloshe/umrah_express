import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/model/customize_models/transfer_model/transfer_listing_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChangeTransferView extends StatefulWidget {
  const ChangeTransferView({super.key});

  @override
  State<ChangeTransferView> createState() => _ChangeTransferViewState();
}

class _ChangeTransferViewState extends State<ChangeTransferView> {
  final _staticVar = StaticVar();
  bool isUserSelectingOutTransfer = false;
  Map<String, In?> selectedTransfer = {"In": null, "Out": null};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.transfers ?? 'Transfers',
            style: TextStyle(fontSize: _staticVar.titleFontSize.sp)),
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
        elevation: 0.3,
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
              Expanded(
                child: ListView(
                  children: isUserSelectingOutTransfer
                      ? [
                          for (var transfer in data.transferListModel?.data?.out ?? <In>[])
                            _buildTransferCard(transfer, isInTransfer: false)
                        ]
                      : [
                          for (var transfer in data.transferListModel?.data?.dataIn ?? <In>[])
                            _buildTransferCard(transfer, isInTransfer: true)
                        ],
                ),
              ),
            ],
          );
        }),
      )),
      bottomSheet: Container(
        padding: EdgeInsets.all(_staticVar.defaultPadding * 1.5),
        margin: EdgeInsets.only(bottom: _staticVar.defaultPadding),
        width: 100.w,
        height: 7.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 90.w,
              child: CustomBTN(
                onTap: () async {
                  if ((selectedTransfer['In'] != null) && (selectedTransfer['Out'] != null)) {
                    final result = await context.read<CustomizeController>().updateTransfer(
                        inTransferId: selectedTransfer['In']?.id ?? '',
                        outTransferId: selectedTransfer['Out']?.id ?? '');

                    if (!mounted) return;
                    if (result) {
                      _staticVar.showToastMessage(
                          message: AppLocalizations.of(context)?.transferHasBeenAdded ??
                              'Transfer has been added');
                      Navigator.of(context).pop();
                    }
                  } else if (selectedTransfer['In'] != null) {
                    isUserSelectingOutTransfer = true;
                  } else if (selectedTransfer['Out'] == null) {
                    _staticVar.showToastMessage(
                        message: "Please select transfer from Hotel", isError: true);
                  } else if (selectedTransfer['In'] == null) {
                    _staticVar.showToastMessage(
                        message: "Please select transfer from airport", isError: true);
                    isUserSelectingOutTransfer = false;
                  }

                  setState(() {});
                },
                title: AppLocalizations.of(context)?.next ?? 'Next',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferCard(In transfer, {required bool isInTransfer}) {
    return GestureDetector(
      onTap: () {
        if (isInTransfer) {
          selectedTransfer['In'] = transfer;
        } else {
          selectedTransfer['Out'] = transfer;
        }
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
        decoration: BoxDecoration(
            color: _staticVar.cardcolor,
            boxShadow: [_staticVar.shadow],
            border: Border.all(
                width: 1,
                color: isInTransfer
                    ? transfer == selectedTransfer['In']
                        ? _staticVar.primaryColor
                        : Colors.transparent
                    : transfer == selectedTransfer['Out']
                        ? _staticVar.primaryColor
                        : Colors.transparent),
            borderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImage(
              url: transfer.images ?? '',
              width: 25.w,
              height: 10.h,
              boxFit: BoxFit.contain,
            ),
            SizedBox(width: 2.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transfer.name ?? '',
                    style: TextStyle(
                      fontSize: _staticVar.titleFontSize.sp,
                      fontWeight: _staticVar.titleFontWeight,
                    )),
                SizedBox(height: 1.h),
                Text(
                  "${AppLocalizations.of(context)?.type ?? "Type "}:  ${transfer.serviceTypeName ?? ''}",
                  style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                RichText(
                    text: TextSpan(
                        text:
                            "${AppLocalizations.of(context)?.packagePriceDifference ?? 'Price difference'} : ",
                        style: TextStyle(color: _staticVar.blackColor),
                        children: [
                      TextSpan(
                          text: " ${transfer.priceDifference ?? 0} ${transfer.currency ?? ''}",
                          style: TextStyle(
                              color: (transfer.priceDifference ?? 0).isNegative
                                  ? _staticVar.greenColor
                                  : _staticVar.redColor)),
                    ]))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTransfer(In? transfer, String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (key == "In") {
            print('here');
            isUserSelectingOutTransfer = false;
          } else {
            isUserSelectingOutTransfer = true;
          }
        });
      },
      child: Container(
        width: 20.w,
        height: 20.w,
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
                  Text(transfer.name ?? '')
                ],
              ),
      ),
    );
  }
}
