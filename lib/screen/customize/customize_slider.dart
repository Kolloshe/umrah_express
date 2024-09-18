import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/customize_controller.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/model/customize_models/package_customize_model.dart';
import 'package:umrah_by_lamar/screen/auth/login.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../prebook/prebook_stepper.dart';
import '../widgets/customize_header_delegate.dart';
import '../widgets/image_spinning.dart';
import 'customize_services.dart';

class CustomizeSlider extends StatefulWidget {
  const CustomizeSlider({super.key});

  @override
  State<CustomizeSlider> createState() => _CustomizeSliderState();
}

class _CustomizeSliderState extends State<CustomizeSlider> {
  final _staticVar = StaticVar();
  CarouselController buttonCarouselController = CarouselController();

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: CustmizeHederDelegate(
                    max: 100.h - (kBottomNavigationBarHeight + 200),
                    min: 100.h / 7,
                    builder: (percent) {
                      final topPadding = MediaQuery.of(context).padding.top;
                      final bottomPercent = (percent / .6).clamp(0.0, 1.0);

                      final topPercent = ((1 - percent) / .9).clamp(0.0, 1.0);
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          HeaderWidget(
                              w: 100.w,
                              topPadding: topPadding,
                              bottomPercent: bottomPercent,
                              customizpackage: context.read<CustomizeController>().packageCustomize,
                              buttonCarouselController: buttonCarouselController),
                          Positioned(
                            top: topPadding,
                            left: -60 * (1 - bottomPercent),
                            child: context.read<UserController>().locale == const Locale('en')
                                ? IconButton(
                                    icon: Icon(
                                      context.read<UserController>().locale == const Locale('ar')
                                          ? Icons.keyboard_arrow_right_rounded
                                          : Icons.keyboard_arrow_left_rounded,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // if (Provider.of<AppData>(context, listen: false)
                                      //     .isFromdeeplink) {
                                      //   Provider.of<AppData>(context, listen: false)
                                      //       .isFromDeeplink(false);

                                      //   Navigator.pushNamedAndRemoveUntil(
                                      //       context, TabPage.idScreen, (route) => false);
                                      // } else {
                                      //   Navigator.of(context).pushNamedAndRemoveUntil(
                                      //       PackagesScreen.idScreen, (route) => false);
                                      // }
                                    },
                                    color: Colors.white,
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      final shareUrl = await context
                                          .read<PackSearchController>()
                                          .genarateDynamicLinks(
                                              id: context
                                                      .read<CustomizeController>()
                                                      .packageCustomize
                                                      ?.result
                                                      ?.customizeId ??
                                                  '',
                                              level: 'customizeId');
                                      if (!mounted) return;
                                      Navigator.of(context).pop();
                                      if (shareUrl != null || shareUrl != '') {
                                        Share.share(shareUrl ?? '',
                                            subject: context
                                                    .read<CustomizeController>()
                                                    .packageCustomize
                                                    ?.result
                                                    ?.packageName ??
                                                '');
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          Positioned(
                            top: lerpDouble(-100, 140, topPercent)!.clamp(topPadding + 10, 140),
                            left: lerpDouble(100, 20, topPercent)!.clamp(20.0, 50.0),
                            right: 40,
                            child: AnimatedOpacity(
                              duration: kThemeAnimationDuration,
                              opacity: bottomPercent < 1 ? 0 : 1,
                              child: Text(
                                context
                                        .read<CustomizeController>()
                                        .packageCustomize
                                        ?.result
                                        ?.packageName ??
                                    '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: lerpDouble(0, 40, topPercent)!.clamp(20.0, 40.0),
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Positioned(
                            top: topPadding,
                            right: -60 * (1 - bottomPercent),
                            child: context.read<UserController>().locale == const Locale('en')
                                ? IconButton(
                                    onPressed: () async {
                                      // pressIndcatorDialog(context);
                                      // final shareUrl = await AssistantMethods.sharePackageDeepLink(
                                      //     _customizpackage.result.customizeId, 'customizeId');
                                      // Navigator.of(context).pop();
                                      // if (shareUrl != null || shareUrl != '') {
                                      //   Share.share(shareUrl,
                                      //       subject: _customizpackage.result.packageName);
                                      // }
                                    },
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(
                                      context.read<UserController>().locale == const Locale('ar')
                                          ? Icons.keyboard_arrow_right_rounded
                                          : Icons.keyboard_arrow_left_rounded,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      // if (Provider.of<AppData>(context, listen: false)
                                      //     .isFromdeeplink) {
                                      //   Provider.of<AppData>(context, listen: false)
                                      //       .isFromDeeplink(false);
                                      //   Navigator.pushNamedAndRemoveUntil(
                                      //       context, TabPage.idScreen, (route) => false);
                                      // } else {
                                      //   Navigator.of(context).pushNamedAndRemoveUntil(
                                      //       PackagesScreen.idScreen, (route) => false);
                                      // }
                                    },
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      );
                    },
                  )),
              SliverToBoxAdapter(
                  child: Container(
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                width: 100.w,
                child: Material(
                    borderRadius: BorderRadius.circular(20), child: const CustomizeServices()
                    // NewCustomizePage()

                    ),
              ))
            ],
          )
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(color: _staticVar.cardcolor, boxShadow: [_staticVar.shadow]),
        padding: const EdgeInsets.all(10),
        height: 14.5.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              child: Consumer<CustomizeController>(
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalPACKAGEPRICE,
                      style: TextStyle(
                          color: _staticVar.greenColor,
                          fontWeight: FontWeight.normal,
                          fontSize: _staticVar.subTitleFontSize.sp),
                    ),
                    Text(
                      ' ${value.packageCustomize?.result?.totalAmount ?? ''} ${value.packageCustomize?.result?.sellingCurrency}'
                      //        localizeCurrency(value.packagecustomiz.result.sellingCurrency),
                      ,
                      style: TextStyle(
                          color: _staticVar.greenColor,
                          fontWeight: FontWeight.bold,
                          fontSize: _staticVar.subTitleFontSize.sp),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // screenshotCallbacks.stopScreenshot();
                    // getlogin();
                    // if (Provider.of<AppData>(context, listen: false).isFromdeeplink) {
                    //   pressIndcatorDialog(context);
                    //   await Future.delayed(const Duration(seconds: 2), () {
                    //     if (!isLogin) {
                    //       getlogin();
                    //     }
                    //   });
                    //   Navigator.of(context).pop();
                    // }
                    // if (isLogin) {
                    //   if (users.data.phone.isEmpty) {
                    //     displayTostmessage(context, false,
                    //         message: AppLocalizations.of(context)!.youAccountMissSomeInformation);
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => UserProfileInfomation(
                    //               isFromPreBook: true,
                    //             )));
                    //   } else {
                    //     print(Provider.of<AppData>(context, listen: false).userCollectedPoint);
                    //     Provider.of<AppData>(context, listen: false)
                    //         .newPreBookTitle(AppLocalizations.of(context)!.passengersInformation);
                    //     // GET ACTIVITY QUESTIONS
                    //     context.read<AppData>().toggleHasQuestions(
                    //         await AssistantMethods.getActivityQuestions(
                    //             context, _customizpackage.result.customizeId));
                    //     Navigator.pushNamedAndRemoveUntil(
                    //         context, CheckoutInformation.idScreen, (route) => false);
                    //     //  Provider.of<AppData>(context, listen: false).clearAllPassengerInformation();
                    //     Provider.of<AppData>(context, listen: false)
                    //         .resetSelectedPassingerfromPassList();
                    //   }
                    // } else {
                    // }

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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _staticVar.primaryColor.withOpacity(0.8),
                      elevation: 0.0,
                      fixedSize: Size(40.w, 5.h)),
                  child: Text(
                    AppLocalizations.of(context)!.bookNow,
                    style: TextStyle(
                        fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final shareUrl = await context
                        .read<PackSearchController>()
                        .genarateDynamicLinks(
                            id: context
                                    .read<CustomizeController>()
                                    .packageCustomize
                                    ?.result
                                    ?.packageId ??
                                '',
                            level: 'customizeId');

                    String url =
                        'https://wa.me/+971585588845/?text=${Uri.parse("I+need+help+with+this+package++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++$shareUrl")}';

                    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      elevation: 0.0,
                      fixedSize: Size(35.w, 5.h)),
                  child: Text(
                    AppLocalizations.of(context)!.needHelp,
                    style: TextStyle(
                        fontSize: 10.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.w,
    required this.topPadding,
    required this.bottomPercent,
    required customizpackage,
    required this.buttonCarouselController,
  }) : _customizpackage = customizpackage;

  final double w;
  final double topPadding;
  final double bottomPercent;
  final PackageCustomizeModel _customizpackage;
  final CarouselController buttonCarouselController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      child: Padding(
        padding: EdgeInsets.only(
          top: (10 + topPadding) * (1 - bottomPercent),
          bottom: 0,
        ),
        child: Consumer<CustomizeController>(
          builder: (context, data, child) => Transform.scale(
              scale: lerpDouble(1, 1.3, bottomPercent)!,
              child: data.packageCustomize?.result?.noHotels ?? false
                  ? Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 5,
                        bottom: 5,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/home_header_image.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: PlaceImagesPageView(
                        imagesUrl: (data.packageCustomize?.result?.hotels ?? []).isNotEmpty
                            ? ((data.packageCustomize?.result?.hotels ?? []).first.imgAll ?? [])
                                .map((e) => e.src ?? '')
                                .toList()
                            : ['assets/images/home_header_image.png'],
                      ),
                    )

              //  CachedNetworkImage(
              //   imageUrl: e.src.trimLeft(),
              //   fit: BoxFit.cover,
              //   placeholder: (context, url) => Container(
              //       child: ImageSpinning(
              //     withOpasity: true,
              //   )),
              //   errorWidget: (context, erorr, x) => Image.asset(
              //     'assets/images/image-not-available.png',
              //     fit: BoxFit.cover,
              //   ),
              // ),

              ),
        ),
      ),
    );

    //       Image.network(_customizpackage.result.hotels[0].image,fit: BoxFit.cover,),
  }
}

class PlaceImagesPageView extends StatefulWidget {
  const PlaceImagesPageView({
    super.key,
    required this.imagesUrl,
  });

  final List<String> imagesUrl;

  @override
  State<PlaceImagesPageView> createState() => _PlaceImagesPageViewState();
}

class _PlaceImagesPageViewState extends State<PlaceImagesPageView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: widget.imagesUrl.length,
            onPageChanged: (value) {
              setState(() => currentIndex = value);
            },
            physics: const BouncingScrollPhysics(),
            controller: PageController(viewportFraction: .9),
            itemBuilder: (context, index) {
              final imageUrl = widget.imagesUrl[index];
              final isSelected = currentIndex == index;
              return CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => Center(
                    child: SizedBox(
                  width: 15.w,
                  height: 15.w,
                  child: ImageSpinning(
                    withOpasity: true,
                  ),
                )),
                errorWidget: (context, url, error) => AnimatedContainer(
                  duration: kThemeAnimationDuration,
                  margin: EdgeInsets.only(
                      left: 5, right: 5, top: isSelected ? 5 : 20, bottom: isSelected ? 5 : 20),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/image.jpeg',
                        fit: BoxFit.cover,
                      )),
                ),
                imageBuilder: (context, imageProvider) => AnimatedContainer(
                  duration: kThemeAnimationDuration,
                  margin: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: isSelected ? 5 : 20,
                    bottom: isSelected ? 5 : 20,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                        Colors.black12,
                        BlendMode.dst,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
