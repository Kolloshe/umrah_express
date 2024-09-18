import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/home_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/model/home_models/home_data_model.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/search_models/ind_transfer_search_model.dart';
import '../../model/search_models/payload.dart';
import 'image_spinning.dart';

class CitiesPayload extends StatefulWidget {
  const CitiesPayload(
      {super.key,
      required this.x,
      required this.onTap,
      required this.toRechangeCitiy,
      required this.isfromnavbar});
  final String x;
  final void Function() onTap;
  final VoidCallback toRechangeCitiy;
  final VoidCallback isfromnavbar;

  @override
  State<CitiesPayload> createState() => _CitiesPayloadState();
}

class _CitiesPayloadState extends State<CitiesPayload> with SingleTickerProviderStateMixin {
  final _staticVar = StaticVar();

  late AnimationController _animationController;

  late Animation<Offset> _animation;
  final searchController = TextEditingController();
  List<PayloadElement>? citiyList = [];
  String citiy = '';
  IndTransferSearchModel? indTransferSearch;
  bool isSearching = false;
  HomeDataModel? _holidaysfotter;

  bool isEN = true;

  Future<List<PayloadElement>>? future;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
        .animate(_animationController);
    future = context.read<PackSearchController>().searchForCity(citiy);
    _holidaysfotter = context.read<HomeController>().homeDataModel;
    Future.delayed(const Duration(), () => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    isEN = context.read<UserController>().locale == const Locale('en') ? true : false;
    getInitTransferData();
    super.initState();
  }

  void getInitTransferData() async {
    if (context.read<PackSearchController>().searchMode.contains('transfer')) {
      final location = context.read<PackSearchController>().payloadWhichCityForTransfer!;
      indTransferSearch = await context
          .read<PackSearchController>()
          .getCityForTransfer('A', location.id ?? '', location.airportCode, location.cityName);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        maxChildSize: 0.95,
        minChildSize: 0.50,
        initialChildSize: 0.75,
        // expand: true,
        builder: (BuildContext context, ScrollController scrollController) {
          //print(_scrollController.position.minScrollExtent);
          return NotificationListener(
            onNotification: (OverscrollNotification notification) {
              if (notification.metrics.pixels == -1.0) {
                widget.isfromnavbar();
                //  Navigator.of(context).pop();
              }
              return true;
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: SlideTransition(
                position: _animation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onPanUpdate: (d) {},
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          primary: false,
                          controller: scrollController,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 8.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                                color: _staticVar.primaryColor.withAlpha(100),
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: widget.toRechangeCitiy,
                          child: Icon(
                            isEN ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
                            size: 30.sp,
                            color: _staticVar.primaryColor,
                          ),
                        ),
                        SizedBox(
                            width: 80.w,
                            child: TextFormField(
                              autofocus: true,
                              controller: searchController,
                              onChanged: (value) async {
                                if (value.characters.length > 1 &&
                                    searchController.text.isNotEmpty) {
                                  isSearching = true;
                                  citiy = value;
                                  context
                                          .read<PackSearchController>()
                                          .searchMode
                                          .contains('transfer')
                                      ? indTransferSearch = await context
                                          .read<PackSearchController>()
                                          .getCityForTransfer(
                                              citiy,
                                              context
                                                      .read<PackSearchController>()
                                                      .payloadWhichCityForTransfer
                                                      ?.countryCode ??
                                                  '',
                                              context
                                                  .read<PackSearchController>()
                                                  .payloadWhichCityForTransfer!
                                                  .airportCode,
                                              context
                                                  .read<PackSearchController>()
                                                  .payloadWhichCityForTransfer!
                                                  .cityName)
                                      : context.read<PackSearchController>().searchForCity(citiy);
                                } else {
                                  isSearching = false;
                                }

                                Future.delayed(const Duration(seconds: 1), () {
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                              },
                              cursorColor: _staticVar.primaryColor,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.where_Are_You_Going,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                            ))
                      ],
                    ),
                    Expanded(
                      child: isSearching ||
                              context.read<PackSearchController>().searchMode.contains('transfer')
                          ? context.read<PackSearchController>().searchMode.contains('transfer')
                              ? ListView(
                                  children: [
                                    for (int i = 0; i < (indTransferSearch?.data?.length ?? 0); i++)
                                      GestureDetector(
                                        onTap: widget.onTap,
                                        child: InkWell(
                                            onTap: () {
                                              context
                                                  .read<PackSearchController>()
                                                  .injectTransferIndPoint(
                                                      'to',
                                                      (indTransferSearch?.data ??
                                                          <IndTransferSearchResultData>[])[i]);
                                              widget.onTap();
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(5).copyWith(right: 20),
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: _staticVar.primaryColor,
                                                      borderRadius: BorderRadius.circular(15)),
                                                  child: const Icon(
                                                    Icons.location_on,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 70.w,
                                                      child: Text(
                                                        (indTransferSearch?.data ??
                                                                    <IndTransferSearchResultData>[])[i]
                                                                .label ??
                                                            '',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12.sp),
                                                      ),
                                                    ),
                                                    Text(
                                                      (indTransferSearch?.data ??
                                                                  <IndTransferSearchResultData>[])[i]
                                                              .category ??
                                                          '',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 10.sp,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      )
                                  ],
                                )
                              : FutureBuilder<List<PayloadElement>>(
                                  future: future,
                                  //AssistantMethods.searchfrom(citiy, context),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      citiyList = context
                                          .read<PackSearchController>()
                                          .cities
                                          .where((element) =>
                                              (element.countryName ?? '')
                                                  .toLowerCase()
                                                  .contains(citiy.toLowerCase().trim()) ||
                                              (element.cityName ?? '')
                                                  .toLowerCase()
                                                  .contains(citiy.toLowerCase().trim()))
                                          .toList();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.separated(
                                        primary: false,
                                        shrinkWrap: true,
                                        separatorBuilder: (context, i) => const Divider(),
                                        itemBuilder: (context, index) => GestureDetector(
                                          onTap: widget.onTap,
                                          child: GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<PackSearchController>()
                                                    .getpayloadTo(citiyList!.elementAt(index));
                                                widget.onTap();
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(5).copyWith(right: 20),
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: _staticVar.primaryColor,
                                                        borderRadius: BorderRadius.circular(15)),
                                                    child: const Icon(
                                                      Icons.location_on,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        citiyList?[index].cityName ?? '',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12.sp),
                                                      ),
                                                      Text(
                                                        citiyList?[index].countryName ?? '',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10.sp,
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                        itemCount: citiyList!.length,
                                        controller: scrollController,
                                      ),
                                    );
                                  })
                          : ListView.separated(
                              itemBuilder: (context, index) => _buildsuggeitionList(
                                  (_holidaysfotter?.data?.sectionOne?.data ??
                                      <SectionData>[])[index]),
                              separatorBuilder: (context, i) => const Divider(),
                              itemCount:
                                  (_holidaysfotter?.data?.sectionOne?.data ?? <SectionData>[])
                                      .length),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildsuggeitionList(SectionData holiday) => GestureDetector(
        onTap: () async {
          final tocode =
              await context.read<PackSearchController>().searchForCity(holiday.city ?? '');
          if (!mounted) return;
          context.read<PackSearchController>().getpayloadTo(tocode.first);
          widget.onTap();
        },
        child: SizedBox(
          height: 11.h,
          width: 90.w,
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(1, 1),
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.1)),
                ],
                color: _staticVar.cardcolor),
            child: Row(
              children: [
                SizedBox(
                    width: 25.w,
                    height: 100.h,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: holiday.image ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                            child: ImageSpinning(
                          withOpasity: true,
                        )),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/image-not-available.png'),
                      ),

                      //  Image.network(
                      //   holiday.image,
                      //   fit: BoxFit.cover,
                      // ),
                    )),
                SizedBox(
                  width: 3.w,
                ),
                SizedBox(
                  width: 60.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loclaizetrinding(holiday.city ?? ''),
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        isEN
                            ? holiday.label ?? ""
                            : "إحجز عطله في ${loclaizetrinding(holiday.city ?? '')}",
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

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
}

class RechagethefromCitiy extends StatefulWidget {
  RechagethefromCitiy(
      {Key? key,
      required this.x,
      required this.onTap,
      required this.back,
      required this.toRechangeCitiy,
      required this.isfromnavbar})
      : super(key: key);
  final String x;
  final void Function() onTap;
  final VoidCallback back;
  final VoidCallback toRechangeCitiy;
  final VoidCallback isfromnavbar;

  @override
  _RechagethefromCitiyState createState() => _RechagethefromCitiyState();
}

class _RechagethefromCitiyState extends State<RechagethefromCitiy>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<Offset> _animation;
  bool _showcurrentLocation = true;
  List<PayloadElement>? citiyList = [];
  String citiy = '';
  bool isEN = true;
  IndTransferSearchModel? indTransferSearch;
  final searchController = TextEditingController();
  FocusNode f = FocusNode();
  Future<List<PayloadElement>>? future;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
        .animate(_animationController);
    _showcurrentLocation = true;
    future = context.read<PackSearchController>().searchForCity(citiy);
    Future.delayed(const Duration(), () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      context.read<PackSearchController>().resetApp();
    });

    if (context.read<PackSearchController>().searchMode.contains('transfer')) {
      getInitTransferDataModel();
    }
    isEN = context.read<UserController>().locale == const Locale('en') ? true : false;
    super.initState();
  }

  final _staticVar = StaticVar();

  void getInitTransferDataModel() async {
    indTransferSearch = await context.read<PackSearchController>().getCityForTransfer(
        'AE',
        context.read<PackSearchController>().payloadWhichCityForTransfer?.countryCode ?? '',
        context.read<PackSearchController>().payloadWhichCityForTransfer?.airportCode,
        context.read<PackSearchController>().payloadWhichCityForTransfer?.cityName);
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<PackSearchController>().title = 'Where From';
    _animationController.forward();
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        maxChildSize: 0.95,
        minChildSize: 0.50,
        initialChildSize: 0.75,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return NotificationListener(
            onNotification: (OverscrollNotification notification) {
              if (notification.metrics.pixels == -1.0) {
                widget.isfromnavbar();
              }
              return true;
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: SlideTransition(
                position: _animation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        primary: false,
                        controller: scrollController,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 8.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              color: _staticVar.primaryColor.withAlpha(100),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: widget.back,
                          child: Icon(
                            isEN ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
                            size: 30.sp,
                            color: _staticVar.primaryColor,
                          ),
                        ),
                        SizedBox(
                            width: 80.w,
                            child: TextFormField(
                              autofocus: true,
                              showCursor: true,
                              controller: searchController,
                              onChanged: (value) async {
                                setState(() {
                                  if (value.isNotEmpty &&
                                      searchController.text.characters.length >= 1) {
                                    _showcurrentLocation = false;
                                  } else {
                                    _showcurrentLocation = true;
                                  }
                                  citiy = value;
                                });
                                context.read<PackSearchController>().searchMode.contains('transfer')
                                    ? indTransferSearch = await context
                                        .read<PackSearchController>()
                                        .getCityForTransfer(
                                            citiy,
                                            context
                                                    .read<PackSearchController>()
                                                    .payloadWhichCityForTransfer
                                                    ?.countryCode ??
                                                '',
                                            context
                                                .read<PackSearchController>()
                                                .payloadWhichCityForTransfer!
                                                .airportCode,
                                            context
                                                .read<PackSearchController>()
                                                .payloadWhichCityForTransfer!
                                                .cityName)
                                    : context.read<PackSearchController>().searchForCity(citiy);

                                Future.delayed(const Duration(seconds: 1), () {
                                  if (mounted) {
                                    setState(() {});
                                  }
                                });
                              },
                              cursorColor: _staticVar.primaryColor,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.where_From,
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                            ))
                      ],
                    ),
                    const SizedBox(height: 5),
                    _showcurrentLocation &&
                            !context.read<PackSearchController>().searchMode.contains('transfer')
                        ? SizedBox(
                            width: 100.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.your_Current_Location}\n',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (Provider.of<PackSearchController>(context, listen: false)
                                            .payloadFromlocation ==
                                        null) return;
                                    widget.toRechangeCitiy();
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: _staticVar.primaryColor,
                                        ),
                                        child: const Icon(
                                          Icons.my_location,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Provider.of<PackSearchController>(context, listen: false)
                                                  .payloadFromlocation !=
                                              null
                                          ? Text(
                                              '${Provider.of<PackSearchController>(context, listen: false).payloadFromlocation!.cityName ?? ""} ${Provider.of<PackSearchController>(context, listen: false).payloadFromlocation!.countryName ?? ''}',
                                              style: TextStyle(
                                                  fontSize: 12.sp, fontWeight: FontWeight.w600),
                                            )
                                          : const Text('Add Your Location')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    //   SizedBox(height: 16),
                    Expanded(
                      child: context.read<PackSearchController>().searchMode.contains('transfer')
                          ? ListView(
                              children: [
                                for (int i = 0;
                                    i <
                                        ((indTransferSearch?.data ??
                                                <IndTransferSearchResultData>[])
                                            .length);
                                    i++)
                                  GestureDetector(
                                    onTap: widget.onTap,
                                    child: InkWell(
                                        onTap: () {
                                          context
                                              .read<PackSearchController>()
                                              .injectTransferIndPoint(
                                                  'from',
                                                  (indTransferSearch?.data ??
                                                      <IndTransferSearchResultData>[])[i]);
                                          widget.onTap();
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5).copyWith(right: 20),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: _staticVar.primaryColor,
                                                  borderRadius: BorderRadius.circular(15)),
                                              child: const Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 70.w,
                                                  child: Text(
                                                    indTransferSearch?.data?[i].label ?? '',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.sp),
                                                  ),
                                                ),
                                                Text(
                                                  (indTransferSearch?.data ??
                                                              <IndTransferSearchResultData>[])[i]
                                                          .category ??
                                                      '',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.sp,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  )
                              ],
                            )
                          : FutureBuilder<List<PayloadElement>>(
                              future: future,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  citiyList =
                                      Provider.of<PackSearchController>(context, listen: false)
                                          .cities
                                          .where((element) =>
                                              (element.countryName ?? "")
                                                  .toLowerCase()
                                                  .contains(citiy.toLowerCase().trim()) ||
                                              (element.cityName ?? "")
                                                  .toLowerCase()
                                                  .contains(citiy.toLowerCase().trim()))
                                          .toList();

                                  // citiyList = snapshot.data!
                                  //     .where((element) =>
                                  //         element.cityName
                                  //             .trim()
                                  //             .toLowerCase()
                                  //             .contains(citiy.toLowerCase().trim()) ||
                                  //         element.countryName
                                  //             .trim()
                                  //             .toLowerCase()
                                  //             .contains(citiy.toLowerCase().trim()))
                                  //     .toList();
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _showcurrentLocation
                                      ? const SizedBox()
                                      : ListView.separated(
                                          separatorBuilder: (context, i) => const Divider(),
                                          itemBuilder: (context, index) => GestureDetector(
                                            onTap: widget.onTap,
                                            child: InkWell(
                                                onTap: () {
                                                  context
                                                      .read<PackSearchController>()
                                                      .getpayloadFrom(citiyList!.elementAt(index));
                                                  widget.onTap();
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.all(5)
                                                          .copyWith(right: 20),
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: _staticVar.primaryColor,
                                                          borderRadius: BorderRadius.circular(15)),
                                                      child: const Icon(
                                                        Icons.location_on,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          (citiyList ?? <PayloadElement>[])[index]
                                                                  .cityName ??
                                                              '',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 12.sp),
                                                        ),
                                                        Text(
                                                          (citiyList ?? <PayloadElement>[])[index]
                                                                  .countryName ??
                                                              '',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 10.sp,
                                                              color: Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          itemCount: citiyList!.length,
                                          controller: scrollController,
                                        ),
                                );
                              }),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
