import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TransferView extends StatelessWidget {
  TransferView({super.key, required this.transfer});
  final List<Transfer> transfer;
  final _staticVar = StaticVar();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (int i = 0; i < transfer.length; i++) _buildTransfer(transfer[i], i, context)],
    );
  }

  Widget _buildTransfer(Transfer data, int i, BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(i == 0
            ? AppLocalizations.of(ctx)?.toHotel ?? ''
            : AppLocalizations.of(ctx)?.toAirport ?? ''),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImage(url: data.image ?? '', width: 30.w, boxFit: BoxFit.cover),
            SizedBox(width: 3.w),
            SizedBox(
              width: 55.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(ctx)?.type ?? 'car Type',
                      style: TextStyle(
                          color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp)),
                  SizedBox(height: 0.5.h),
                  Text(data.type ?? ''),
                  SizedBox(height: 0.5.h),
                  Text(AppLocalizations.of(ctx)?.dates ?? 'Date',
                      style: TextStyle(
                          color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp)),
                  SizedBox(height: 0.5.h),
                  Text(DateFormat('y-MM-dd').format(data.date ?? DateTime.now())),
                  SizedBox(height: 0.5.h),
                  Text(AppLocalizations.of(ctx)?.pickup ?? 'Pickup',
                      style: TextStyle(
                          color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp)),
                  SizedBox(height: 0.5.h),
                  Text(data.pickUpLocation ?? ''),
                  SizedBox(height: 0.5.h),
                  Text(AppLocalizations.of(ctx)?.dropOff ?? 'Drop-Off',
                      style: TextStyle(
                          color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp)),
                  SizedBox(height: 0.5.h),
                  Text(data.dropOffLocation ?? '')
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 1.h),
        const Divider(),
      ],
    );
  }
}
