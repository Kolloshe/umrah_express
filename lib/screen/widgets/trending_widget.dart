import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import 'image_spinning.dart';

class Trending extends StatelessWidget {
  Trending({super.key, required this.label, required this.image, required this.cityName});
  final String label;
  final String image;
  final String cityName;
  final staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: staticVar.defaultPadding),
        decoration: BoxDecoration(
          // color: cardcolor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [staticVar.shadow],
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            SizedBox(
              width: size.width * 0.6,
              height: size.height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: size.width * 0.6,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: ImageSpinning(
                    withOpasity: true,
                  )),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/image-not-available.png'),
                ),
              ),
            ),
            Positioned(
              left: context.read<UserController>().locale == const Locale('en') ? 0 : null,
              right: context.read<UserController>().locale == const Locale('en') ? null : 0,
              top: 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.only(
                      topLeft: context.read<UserController>().locale == const Locale('en')
                          ? const Radius.circular(16)
                          : const Radius.circular(0),
                      topRight: context.read<UserController>().locale == const Locale('en')
                          ? const Radius.circular(0)
                          : const Radius.circular(16),
                    )),
                child: RichText(
                  text: TextSpan(
                    text: cityName.characters.first.toUpperCase() + cityName.substring(1),
                    style: TextStyle(
                      fontFamily: context.read<UserController>().locale == const Locale('en')
                          ? 'Lato'
                          : 'Bhaijaan',
                      fontWeight: FontWeight.bold,
                      fontSize: staticVar.titleFontSize.sp,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 1,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.centerLeft,
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: const BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Align(
                        alignment: context.read<UserController>().locale == const Locale('en')
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          '${AppLocalizations.of(context)!.nightCount(3)} | ${AppLocalizations.of(context)!.dayCount(4)}',
                          style: TextStyle(
                            color: staticVar.yellowColor,
                            fontWeight: FontWeight.w700,
                            fontSize: staticVar.subTitleFontSize.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.55,
                      child: Align(
                        alignment: context.read<UserController>().locale == const Locale('en')
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          context.read<UserController>().locale == const Locale('en')
                              ? 'Holiday packages in $label'
                              : "إحجز عطله في $label",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: staticVar.subTitleFontSize.sp,
                              color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
}

class BudgetTravelpackages extends StatefulWidget {
  const BudgetTravelpackages(
      {super.key, required this.label, required this.image, required this.cityName});
  final String label;
  final String image;
  final String cityName;

  //final Color color;

  @override
  State<BudgetTravelpackages> createState() => _BudgetTravelpackagesState();
}

class _BudgetTravelpackagesState extends State<BudgetTravelpackages> {
  final _staticVar = StaticVar();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            SizedBox(
              width: 100.w,
              height: 40.h,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: ImageSpinning(
                    withOpasity: true,
                  )),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/image-not-available.png'),
                ),
              ),
            ),
            Positioned(
              left: context.read<UserController>().locale == const Locale('en') ? 0 : null,
              right: context.read<UserController>().locale == const Locale('en') ? null : 0,
              top: 0.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                      topLeft: context.read<UserController>().locale == const Locale('en')
                          ? const Radius.circular(15)
                          : const Radius.circular(0),
                      topRight: context.read<UserController>().locale == const Locale('en')
                          ? const Radius.circular(0)
                          : const Radius.circular(15)),
                ),
                child: RichText(
                  text: TextSpan(
                    text: widget.cityName.characters.first.toUpperCase() +
                        widget.cityName.substring(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: context.read<UserController>().locale == const Locale('en')
                          ? 'Lato'
                          : 'Bhaijaan',
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                alignment: context.read<UserController>().locale == const Locale('en')
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                width: 97.w,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15), bottomRight: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Align(
                        alignment: context.read<UserController>().locale == const Locale('en')
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          "${AppLocalizations.of(context)!.nightCount(3)} | ${AppLocalizations.of(context)!.dayCount(4)}",
                          style: TextStyle(
                              fontSize: _staticVar.subTitleFontSize.sp,
                              color: _staticVar.yellowColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Align(
                      alignment: context.read<UserController>().locale == const Locale('en')
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        context.read<UserController>().locale == const Locale('en')
                            ? 'Holiday packages in ${widget.cityName}'
                            : "إحجز عطله في ${widget.cityName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: _staticVar.titleFontSize.sp,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Text(,style: TextStyle(fontWeight: FontWeight.w500,fontSize:AdaptiveTextSize().getadaptiveTextSize(context, 30) ),),
          ],
        ));
  }
}
