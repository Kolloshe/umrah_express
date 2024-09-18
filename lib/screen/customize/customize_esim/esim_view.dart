import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_image.dart';
import 'package:sizer/sizer.dart';

class EsimView extends StatelessWidget {
  EsimView({super.key, required this.esim});
  final Esim? esim;
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImage(
          url: esim?.imageUrl ?? '',
          withRadius: true,
          width: 25.w,
          height: 12.h,
          boxFit: BoxFit.cover,
        ),
        SizedBox(width: 2.w),
        SizedBox(
          width: 65.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                esim?.description ?? '',
                style: TextStyle(
                    fontSize: _staticVar.titleFontSize.sp - 1, color: _staticVar.secondaryColor),
              ),
              SizedBox(height: 1.h),
              Text((esim?.group ?? <String>[]).isNotEmpty ? esim?.group?.first ?? '' : '',
                  style:
                      TextStyle(color: _staticVar.gray, fontSize: _staticVar.subTitleFontSize.sp)),
              SizedBox(height: 1.h),
              Text(
                "${AppLocalizations.of(context)?.validity ?? ''} ${esim?.duration ?? ''}",
                style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
              )
            ],
          ),
        )
      ],
    );
  }
}
