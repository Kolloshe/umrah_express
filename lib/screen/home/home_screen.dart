import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/home_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controller/search_controller.dart';
import '../../model/home_models/home_data_model.dart';
import '../../model/home_models/promotion_list_model.dart';
import '../search/search_result_screens/search_result_router.dart';
import '../search/search_v2/search_stepper_v2.dart';
import '../widgets/custom_loading_with_game.dart';
import '../widgets/custom_promotion_widget.dart';
import '../widgets/individual_service.dart';
import '../widgets/trending_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _staticVar = StaticVar();

  List<String> image = [
    'assets/images/vectors/1.png',
    'assets/images/vectors/7(1).png',
    'assets/images/vectors/3.png',
    'assets/images/vectors/4.png',
    'assets/images/vectors/7.png',
    'assets/images/vectors/6.png',
    'assets/images/vectors/8.png',
    'assets/images/vectors/9.png',
  ];
  List<String> titles = ['Book', '', '', '', 'Book', '', '', ''];

  List<String> subtitle = [
    "Your Holiday Packages",
    "Travel from anywhere to anywhere in the world",
    "With our fully customizable Holiday Packages",
    "Including Flight, Hotel, Transfer and Tours.!",
    "Your Holiday Packages",
    "Travel from anywhere to anywhere in the world",
    "With our fully customizable Holiday Packages",
    "Including Flight, Hotel, Transfer and Tours.!",
  ];

  int _current = 0;

  CarouselController buttonCarouselController = CarouselController();

  final CarouselController _controller = CarouselController();

  initApp() async {
    if (context.read<HomeController>().homeDataModel == null) {
      await context.read<HomeController>().getHomeData();

      final userCityData = await context
          .read<PackSearchController>()
          .searchForCity(context.read<HomeController>().userGeoData?.city ?? '');
      print(userCityData.first.cityName);
      if (userCityData.isNotEmpty) {
        context.read<PackSearchController>().payloadFromlocation = userCityData.first;
      }
    }
    if (context.read<HomeController>().promotionDataModel == null) {
      context.read<HomeController>().getPromotionList();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _staticVar.background,
      body: Container(
        color: _staticVar.cardcolor,
        child: SafeArea(
          top: false,
          child: CustomScrollView(physics: const ClampingScrollPhysics(), slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              expandedHeight: MediaQuery.of(context).size.height * 0.4,
              pinned: true,
              leading: null,
              leadingWidth: 0,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(vertical: 5),
                background: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    disableCenter: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: image
                      .map((e) => _buildImageHeader(
                          loclaizetheImageHeader(titles.elementAt(image.indexOf(e))),
                          loclaizetheImageHeader(subtitle.elementAt(image.indexOf(e))),
                          e,
                          context))
                      .toList(),
                  carouselController: buttonCarouselController,
                ),
                title: Container(
                  width: 60.w,
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      context.read<PackSearchController>().searchMode = '';
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchStepperV2(
                                serviceType: ServiceType.holiday,
                              )));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      height: 40,
                      width: 70.w,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 1),
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                          //  border: Border.all(),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.search,
                            color: _staticVar.primaryColor,
                          ),
                          Text(
                            AppLocalizations.of(context)!.choose_your_holiday,
                            style: const TextStyle(
                                letterSpacing: 0.5,
                                color: Color(0xff37474F),
                                fontSize: 10,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<HomeController>(builder: (context, data, child) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        color: _staticVar.cardcolor,
                        child: Text(
                          AppLocalizations.of(context)!.exploreMore,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        height: 20.h,
                        child: ListView(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          scrollDirection: Axis.horizontal,
                          children: const [
                            IndividualProducts(
                              image: 'assets/images/vectors/fullpackage.png',
                              title: 'Holiday packages',
                              subtitle: '',
                            ),
                            IndividualProducts(
                              image: 'assets/images/vectors/indflight.png',
                              title: 'Flights',
                              subtitle: '',
                            ),
                            IndividualProducts(
                              image: 'assets/images/vectors/indHoltel.png',
                              title: 'Hotels',
                              subtitle: '',
                            ),
                            IndividualProducts(
                              image: 'assets/images/vectors/indtransfer.png',
                              title: 'Transfers',
                              subtitle: '',
                            ),
                            IndividualProducts(
                              image: 'assets/images/vectors/indactivity.png',
                              title: 'Activities',
                              subtitle: '',
                            ),
                            IndividualProducts(
                              image: 'assets/images/vectors/indJet.png',
                              title: 'Privet jet',
                              subtitle: '',
                            ),
                            IndividualProducts(
                              image: 'assets/images/vectors/indTravelIn.png',
                              title: 'Travel insurance',
                              subtitle: '',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        color: _staticVar.cardcolor,
                        child: Text(
                          context.read<UserController>().locale == const Locale('en')
                              ? data.homeDataModel?.data?.sectionOne?.title ??
                                  AppLocalizations.of(context)!.bestFamilyPac
                              : AppLocalizations.of(context)!.bestFamilyPac,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
                        ),
                      ),
                      Container(
                        color: _staticVar.cardcolor,
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.only(top: 3, bottom: 0, left: 0, right: 0),
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 5,
                          ),
                          primary: false,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          itemCount: data.homeDataModel?.data?.sectionOne?.data?.isNotEmpty ?? false
                              ? data.homeDataModel?.data?.sectionOne?.data?.length ?? 0
                              : 0,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => LoadingWidgetMain()));
                                final result =
                                    await context.read<PackSearchController>().searchFormTreanding(
                                          withOutLoadder: true,
                                          url: (data.homeDataModel?.data?.sectionOne?.data ??
                                                      <SectionData>[])[index]
                                                  .searchUrl ??
                                              "",
                                        );
                                Navigator.of(context).pop();

                                if (result) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const SearchResultRouter(
                                            searchType: ServiceType.holiday,
                                          )));
                                }
                              },
                              child: Trending(
                                cityName: loclaizetrinding(
                                    (data.homeDataModel?.data?.sectionOne?.data ??
                                                <SectionData>[])[index]
                                            .city ??
                                        ''),
                                image: (data.homeDataModel?.data?.sectionOne?.data ??
                                            <SectionData>[])[index]
                                        .image ??
                                    '',
                                label: loclaizetrinding(
                                    (data.homeDataModel?.data?.sectionOne?.data ??
                                                <SectionData>[])[index]
                                            .city ??
                                        ''),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        color: _staticVar.cardcolor,
                        child: Text(
                          AppLocalizations.of(context)!.offerAndPromotions,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(
                        height: 150.sp,
                        width: 100.w,
                        child: Column(
                          children: [
                            SizedBox(
                                height: 120.sp,
                                width: 100.w,
                                child: CarouselSlider.builder(
                                  carouselController: _controller,
                                  itemCount:
                                      (data.promotionDataModel?.data ?? <PromoListData>[]).length,
                                  itemBuilder:
                                      (BuildContext context, int itemIndex, int pageViewIndex) =>
                                          PromotionWidget(
                                              data: (data.promotionDataModel?.data ??
                                                  <PromoListData>[])[itemIndex]),
                                  options: CarouselOptions(
                                      viewportFraction: 1,
                                      disableCenter: true,
                                      aspectRatio: 16.0 / 9.0,
                                      enlargeCenterPage: true,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      }),
                                  //            ListView(
                                  //   scrollDirection: Axis.horizontal,
                                  //   children: [
                                  //   for(int i = 0 ; i <  (data.promotionDataModel?.data??<PromoListData>[]).length ;i++)
                                  //             PromotionWidget(data: (data.promotionDataModel?.data??<PromoListData>[])[i])
                                  //   ],
                                  // ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: (data.promotionDataModel?.data ?? <PromoListData>[])
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return GestureDetector(
                                  onTap: () => _controller.animateToPage(entry.key),
                                  child: Container(
                                    width: 12.0,
                                    height: 12.0,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.black)
                                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        color: _staticVar.cardcolor,
                        child: Text(
                          AppLocalizations.of(context)!.topTrendingHPack,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
                        ),
                      ),
                      Container(
                        color: _staticVar.cardcolor,
                        padding: const EdgeInsets.only(top: 3, bottom: 0, left: 3, right: 3),
                        child: Column(children: [
                          for (var index = 0;
                              index < (data.homeDataModel?.data?.sectionTwo?.data?.length ?? 0);
                              index++)
                            GestureDetector(
                              onTap: () async {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => LoadingWidgetMain()));

                                final result = await context
                                    .read<PackSearchController>()
                                    .searchFormTreanding(
                                        withOutLoadder: true,
                                        url: (data.homeDataModel?.data?.sectionTwo?.data ??
                                                    <SectionData>[])[index]
                                                .searchUrl ??
                                            "");
                                Navigator.of(context).pop();
                                if (result) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const SearchResultRouter(
                                            searchType: ServiceType.holiday,
                                          )));
                                }
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) => LoadingWidgetMain()));

                                context.read<PackSearchController>().searchMode = '';
                                // try {
                                //   final noError = await AssistantMethods.mainSearchFromTrending(
                                //       context,
                                //       holidaysfotter.data.sectionTwo.data[index].searchUrl);
                                //   tocode = await AssistantMethods.getPayloadFromLocation(
                                //       context, holidaysfotter.data.sectionTwo.data[index].city);
                                //   Provider.of<AppData>(context, listen: false).getpayloadTo(tocode);
                                //   PickerDateRange pickerDateRange = PickerDateRange(
                                //       DateTime.parse(holidaysfotter.data.packageStart),
                                //       DateTime.parse(holidaysfotter.data.packageEnd));
                                //   Provider.of<AppData>(context, listen: false)
                                //       .newsearchdateRange(pickerDateRange);

                                //   Provider.of<AppData>(context, listen: false).getdatesfromCal(
                                //       DateTime.parse(holidaysfotter.data.packageStart),
                                //       DateTime.parse(holidaysfotter.data.packageEnd));
                                //   if (noError) {
                                //     Navigator.of(context).popAndPushNamed(
                                //       PackagesScreen.idScreen,
                                //     );
                                //   } else {
                                //     Navigator.of(context).pop();
                                //   }
                                // } catch (e) {
                                //   print(e);
                                //   Navigator.of(context).pop();
                                //   Errordislog().error(context, 'No Trending package available now');
                                // }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: BudgetTravelpackages(
                                  cityName: localizeTop(
                                      (data.homeDataModel?.data?.sectionTwo?.data ??
                                                  <SectionData>[])[index]
                                              .city ??
                                          ''),
                                  image: (data.homeDataModel?.data?.sectionTwo?.data ??
                                              <SectionData>[])[index]
                                          .image ??
                                      '',
                                  label: (data.homeDataModel?.data?.sectionTwo?.data ??
                                              <SectionData>[])[index]
                                          .label ??
                                      '',
                                ),
                              ),
                            )
                        ]),
                      ),
                      //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++Slide SHOW End +++++++++++++++++++++++++++++++++++++++++++++++++++
                      const SizedBox(
                        height: 16,
                      ),

                      // //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++SUBSCRIBE FOR DISCOUNT END +++++++++++++++++++++++++++++++++++++++++++++++++++
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildImageHeader(String? title, String subtitle, String image, BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Image(
            image: AssetImage(image),
            gaplessPlayback: true,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            top: 80,
            child: Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.84,
                child: RichText(
                  text: TextSpan(
                    text: '$title \n',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: context.read<UserController>().locale == const Locale('en')
                            ? 'Lato'
                            : 'Bhaijaan'),
                    children: <TextSpan>[
                      TextSpan(
                          text: subtitle,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily:
                                  context.read<UserController>().locale == const Locale('en')
                                      ? 'Lato'
                                      : 'Bhaijaan')),
                    ],
                  ),
                ))),
      ],
    );
  }

  String loclaizetheImageHeader(String val) {
    switch (val) {
      case "Your Holiday Packages":
        {
          return AppLocalizations.of(context)!.yourHolidayPackages;
        }
      case "Travel from anywhere to anywhere in the world":
        {
          return AppLocalizations.of(context)!.travelFromAnywhereToAnywhereInTheWorld;
        }
      case "With our fully customizable Holiday Packages":
        {
          return AppLocalizations.of(context)!.customizableHolidayPackages;
        }
      case "Including Flight, Hotel, Transfer and Tours.!":
        {
          return AppLocalizations.of(context)!.includingServices;
        }
      case "Book":
        {
          return AppLocalizations.of(context)!.book;
        }
      default:
        {
          return val;
        }
    }
  }

  String loclaizetrinding(String val) {
    switch (val) {
      case 'Colombo':
        {
          return AppLocalizations.of(context)!.colombo;
        }
      case 'Male':
        {
          return AppLocalizations.of(context)!.male;
        }
      case 'Paris':
        {
          return AppLocalizations.of(context)!.paris;
        }
      case 'Miami Beach':
        {
          return AppLocalizations.of(context)!.miamiBeach;
        }
      case 'Helsinki':
        {
          return AppLocalizations.of(context)!.helsinki;
        }
      case 'Dubrovnik':
        {
          return AppLocalizations.of(context)!.dubrovnik;
        }
      case 'Madrid':
        {
          return AppLocalizations.of(context)!.madrid;
        }
      case 'Gothenburg':
        {
          return AppLocalizations.of(context)!.gothenburg;
        }
      case 'Copenhagen':
        {
          return AppLocalizations.of(context)!.copenhagen;
        }
      case 'San Salvador':
        {
          return AppLocalizations.of(context)!.sanSalvador;
        }

      default:
        {
          return val;
        }
    }
  }

  String localizeTop(String val) {
    switch (val) {
      case 'Dubai':
        {
          return AppLocalizations.of(context)!.dubai;
        }
      case 'London':
        {
          return AppLocalizations.of(context)!.london;
        }
      case 'Cancun':
        {
          return AppLocalizations.of(context)!.cancun;
        }
      case 'Crete':
        {
          return AppLocalizations.of(context)!.crete;
        }
      case 'Rome':
        {
          return AppLocalizations.of(context)!.rome;
        }
      case 'Baku':
        {
          return AppLocalizations.of(context)!.baku;
        }
      case 'Tbilisi':
        {
          return AppLocalizations.of(context)!.tbilisi;
        }
      case 'Belgrade':
        {
          return AppLocalizations.of(context)!.belgrade;
        }
      case 'Tirana':
        {
          return AppLocalizations.of(context)!.tirana;
        }
      case 'Hurghada':
        {
          return AppLocalizations.of(context)!.hurghada;
        }

      default:
        {
          return val;
        }
    }
  }
}
