import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glass/glass.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/utility_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_pdf_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../common/network_static.dart';
import '../../../model/customize_models/esim_model/esim_listing_model.dart';

class ChangeEsimView extends StatefulWidget {
  const ChangeEsimView({super.key, this.failedPrebook});
  final bool? failedPrebook;

  @override
  State<ChangeEsimView> createState() => _ChangeEsimViewState();
}

class _ChangeEsimViewState extends State<ChangeEsimView> {
  final _staticVar = StaticVar();

  double mainPrice = 0;

  @override
  void initState() {
    mainPrice =
        (context.read<CustomizeController>().packageCustomize?.result?.esim?.sellingAmount ?? 0)
            .toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/vectors/vector_v2/4.jpg"),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(2.h),
              alignment: Alignment.bottomCenter,
              height: 15.h,
              width: 100.w,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: _staticVar.primaryColor,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Text(AppLocalizations.of(context)?.changeESIMAppbarTitle ?? '',
                      style: TextStyle(
                        color: _staticVar.cardcolor,
                        fontSize: _staticVar.titleFontSize.sp,
                      )),
                ],
              ),
            ).asGlass(),
            (widget.failedPrebook ?? false)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            final result = await context
                                .read<CustomizeController>()
                                .serviceManager(action: 'remove', type: 'esim');
                            if (result) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)?.removeEsimFromPackage ??
                                "Remove E-sim from package",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: _staticVar.subTitleFontSize.sp,
                              decoration: TextDecoration.underline,
                            ),
                          ))
                    ],
                  )
                : const SizedBox(),
            SizedBox(height: 1.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PdfView(
                                isPDF: true,
                                url: '${baseUrl}holiday/esim-install-pdf',
                                title:
                                    "${AppLocalizations.of(context)?.howToInstallEsim ?? 'How to install E-sim'} ?")));
                      },
                      child: Container(
                        padding: EdgeInsets.all(_staticVar.defaultPadding),
                        width: 100.w,
                        child: Text(
                          "${AppLocalizations.of(context)?.howToInstallEsim ?? 'How to install E-sim'} ?",
                          style: TextStyle(
                            color: _staticVar.secondaryColor,
                            fontSize: _staticVar.subTitleFontSize.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ).asGlass(),
                    ),
                    SizedBox(height: 1.h),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 4.h, top: 2.h),
                        children: [
                          for (var esim
                              in context.read<CustomizeController>().esimListModel?.data ??
                                  <EsimData>[]) ...[
                            _buildEsimCard(esim),
                            SizedBox(height: 1.h),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildEsimCard(EsimData esim) {
    return Container(
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      margin: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
        // color: _staticVar.cardcolor,
        // boxShadow: [_staticVar.shadow],
        borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/icons/sim-card.png",
            width: 10.w,
            color: _staticVar.primaryColor,
          ),
          SizedBox(width: 3.w),
          SizedBox(
            width: 55.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                decorateTitle(esim.description ?? ''),
                SizedBox(height: 1.h),
                Text(
                  (esim.groups ?? <String>[]).isEmpty ? "" : (esim.groups ?? <String>[]).first,
                  style: TextStyle(
                      color: _staticVar.cardcolor, fontSize: _staticVar.subTitleFontSize.sp),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Validity ${esim.duration}',
                  style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                ),
                SizedBox(height: 1.h),
                Text(
                  (esim.speed ?? <String>[]).join(', '),
                  style: TextStyle(fontSize: _staticVar.subTitleFontSize.sp),
                ),
                SizedBox(height: 1.h),
                (esim.roamingCountry ?? 0) == 0
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) =>
                                  _buildRoamingCountries(esim.roamingEnabled ?? <String>[]));
                        },
                        child: Text(
                          AppLocalizations.of(context)
                                  ?.roamingAvailableIn(esim.roamingCountry.toString()) ??
                              'Roaming available in ${esim.roamingCountry} Countries',
                          style: TextStyle(
                              fontSize: _staticVar.subTitleFontSize.sp,
                              color: _staticVar.primaryColor),
                        ),
                      ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${((esim.sellingAmount ?? 0) - mainPrice).isNegative ? "- " : "+ "} ${((esim.sellingAmount ?? 0) - mainPrice).abs().toStringAsFixed(0)} ${UtilityVar.genCurrency}',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: (mainPrice - (esim.sellingAmount ?? 0)).isNegative
                        ? Colors.redAccent
                        : _staticVar.greenColor),
              ),
              CustomBTN(
                  onTap: () async {
                    final result = await context
                        .read<CustomizeController>()
                        .updateEsim(esim.simPackageId ?? '');

                    if (result) {
                      Navigator.of(context).pop();
                    }
                  },
                  title: AppLocalizations.of(context)?.select ?? 'Select'),
            ],
          )
        ],
      ),
    ).asGlass(
      clipBorderRadius: BorderRadius.circular(_staticVar.defaultRadius),
    );
  }

  Widget _buildRoamingCountries(List<String> countries) {
    return Container(
      decoration: BoxDecoration(
          color: _staticVar.cardcolor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_staticVar.defaultRadius),
              topRight: Radius.circular(_staticVar.defaultRadius))),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      height: 80.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 1.h,
            decoration: BoxDecoration(
                color: _staticVar.primaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(10)),
          ),
          SizedBox(height: 2.h),
          Text(
            "خدمه التجوال متاحه في هذه البلدان",
            style: TextStyle(fontSize: _staticVar.titleFontSize.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 2.h),
          Expanded(
              child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              for (var data in countries) ...[
                Text(
                  data,
                  style: TextStyle(
                      fontSize: _staticVar.subTitleFontSize.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 0.5.h),
                const Divider()
              ]
            ],
          ))
        ],
      ),
    );
  }

  Widget decorateTitle(String title) {
    final titleSplited = title.split(",");

    return RichText(
        text: TextSpan(
            children: titleSplited
                .map((e) => TextSpan(
                    text: e,
                    style: TextStyle(
                        decoration: e.toLowerCase().contains('gb')
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        color: e.toLowerCase().contains('gb')
                            ? _staticVar.primaryColor
                            : _staticVar.cardcolor,
                        fontWeight:
                            e.toLowerCase().contains('gb') ? FontWeight.bold : FontWeight.normal)))
                .toList()));
  }
}
