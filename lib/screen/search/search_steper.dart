import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';

import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/search_city_payload.dart';
import 'search_stepper_screen/select_citiy_for_transfer.dart';

List<String> images = [
  'assets/images/vectors/from.png',
  'assets/images/vectors/from.png',
  'assets/images/vectors/to.png',
  'assets/images/vectors/dates.png',
  'assets/images/vectors/pax.png',
  'assets/images/vectors/pref.png',
  'assets/images/vectors/pref.png',
  'assets/images/vectors/pref.png'
];

class SearchStepper extends StatefulWidget {
  static String idScreen = 'SearchStepper';

  const SearchStepper({super.key, this.isFromNavBar = false, this.section = -1, this.searchMode});
  final bool? isFromNavBar;
  final int? section;
  final String? searchMode;

  @override
  State<SearchStepper> createState() => _SearchStepperState();
}

class _SearchStepperState extends State<SearchStepper> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late Animation<double> _animation;
  String x = 'dd';
  int i = -1;

  @override
  void initState() {
    i = widget.section ?? -1;
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool animate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned(
              child: SizedBox(
                width: 100.w,
                child: FadeTransition(
                    opacity: _animation,
                    child: Image.asset(
                      images[i + 2],
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Builder(builder: (context) {
              switch (i) {
                case -2:
                  {
                    if (animate) {
                      _controller.forward();

                      if (_controller.isCompleted) {
                        _controller
                          ..reset()
                          ..forward();
                      }
                      animate = false;
                    }

                    return SelectCityForTransfer(
                      onTap: () {
                        animate = true;
                        context
                            .read<PackSearchController>()
                            .newSearchTitle(AppLocalizations.of(context)!.where_From);
                        setState(() {
                          i = -1;
                        });
                      },
                      back: () {
                        if (widget.isFromNavBar ?? false) {
                          //  Navigator.of(context).pushNamedAndRemoveUntil(TabPage.idScreen, (route) => false);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      toRechangeCitiy: () {
                        animate = true;
                        context
                            .read<PackSearchController>()
                            .newSearchTitle(AppLocalizations.of(context)!.where_Are_You_Going);
                        setState(() {
                          i = -1;
                        });
                      },
                      isfromnavbar: () {
                        if (widget.isFromNavBar ?? false) {
                          context
                              .read<PackSearchController>()
                              .newSearchTitle(AppLocalizations.of(context)!.where_From);
                          // Navigator.of(context)
                          //     .pushNamedAndRemoveUntil(TabPage.idScreen, (route) => false);
                        } else {
                          Navigator.of(context).pop();
                          context
                              .read<PackSearchController>()
                              .newSearchTitle(AppLocalizations.of(context)!.where_From);
                        }
                      },
                      x: '',
                    );
                  }

                case -1:
                  if (animate) {
                    _controller.forward();

                    if (_controller.isCompleted) {
                      _controller
                        ..reset()
                        ..forward();
                    }
                    animate = false;
                  }

                  return RechagethefromCitiy(
                      isfromnavbar: () {
                        if (widget.isFromNavBar ?? false) {
                          context
                              .read<PackSearchController>()
                              .newSearchTitle(AppLocalizations.of(context)!.where_From);
                          // Navigator.of(context)
                          //     .pushNamedAndRemoveUntil(TabPage.idScreen, (route) => false);
                        } else {
                          Navigator.of(context).pop();
                          context
                              .read<PackSearchController>()
                              .newSearchTitle(AppLocalizations.of(context)!.where_From);
                        }
                      },
                      toRechangeCitiy: () {
                        animate = true;
                        context
                            .read<PackSearchController>()
                            .newSearchTitle(AppLocalizations.of(context)!.where_Are_You_Going);
                        setState(() {
                          i = 0;
                        });
                      },
                      back: () {
                        if (context.read<PackSearchController>().searchMode.contains('transfer')) {
                          i = -2;
                          setState(() {});
                        } else {
                          if (widget.isFromNavBar ?? false) {
                            // Navigator.of(context)
                            //     .pushNamedAndRemoveUntil(TabPage.idScreen, (route) => false);
                          } else {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      x: '',
                      onTap: () {
                        animate = true;
                        context
                            .read<PackSearchController>()
                            .newSearchTitle(AppLocalizations.of(context)!.where_From);
                        setState(() {
                          i = 0;
                        });
                      });

                case 0:
                  if (animate) {
                    _controller.forward();
                    if (_controller.isCompleted) {
                      _controller
                        ..reset()
                        ..forward();
                    }
                    animate = false;
                  }

                  //  Provider.of<AppData>(context, listen: false).title = 'Where To';

                  return CitiesPayload(
                    isfromnavbar: () {
                      if (widget.isFromNavBar ?? false) {
                        // Navigator.of(context)
                        //     .pushNamedAndRemoveUntil(TabPage.idScreen, (route) => false);
                        context
                            .read<PackSearchController>()
                            .newSearchTitle(AppLocalizations.of(context)!.where_From);
                      } else {
                        Navigator.of(context).pop();
                        context
                            .read<PackSearchController>()
                            .newSearchTitle(AppLocalizations.of(context)!.where_From);
                      }
                    },
                    x: '',
                    toRechangeCitiy: () {
                      animate = true;
                      if (context.read<PackSearchController>().searchMode.toLowerCase().trim() !=
                              'hotel' &&
                          context.read<PackSearchController>().searchMode.toLowerCase().trim() !=
                              'activity') {
                        context
                            .read<PackSearchController>()
                            .newSearchTitle(AppLocalizations.of(context)!.where_From);
                        setState(() {
                          i = -1;
                        });
                      } else {
                        // Navigator.of(context)
                        //     .pushNamedAndRemoveUntil(TabPage.idScreen, (route) => false);
                      }
                    },
                    onTap: () {
                      animate = true;
                      if (context.read<PackSearchController>().payloadFrom != null) {
                        context
                            .read<PackSearchController>()
                            .newSearchTitle(AppLocalizations.of(context)!.when_will_you_be_there);
                        setState(() {
                          i = 1;
                        });
                      } else {
                        StaticVar().showToastMessage(
                            message: AppLocalizations.of(context)!.errorAddYorCurrentLocation,
                            isError: true);
                      }
                    },
                  );

                case 1:
                  _controller.forward();

                  if (animate) {
                    _controller.forward();

                    if (_controller.isCompleted) {
                      _controller
                        ..reset()
                        ..forward();
                    }
                    animate = false;
                  }

                  return Container();

                // DateRangePickers(
                //   isfromnavbar: () {
                //     if (widget.isFromNavBar??false) {
                //       // Navigator.of(context)
                //       //     .pushNamedAndRemoveUntil(TabPage.idScreen, (route) => false);
                //       context.read<PackSearchController>().newSearchTitle(AppLocalizations.of(context)!.where_From);
                //     } else {
                //       Navigator.of(context).pop();
                //   context
                //           .read<PackSearchController>()
                //           .newSearchTitle(AppLocalizations.of(context)!.where_From);
                //     }
                //   },
                //   next: () {
                //     animate = true;
                //     setState(() {
                //      context.read<PackSearchController>().newSearchTitle(AppLocalizations.of(context)!.who_Coming);
                //       i = 2;
                //       print(i);
                //     });
                //   },
                //   ontap: () {
                //     animate = true;
                //  context.read<PackSearchController>().newSearchTitle(AppLocalizations.of(context)!.where_Are_You_Going);
                //     setState(() {
                //       i = 0;
                //       print(i);
                //     });
                //   },
                // );

                case 2:
                  if (animate) {
                    _controller.forward();

                    if (_controller.isCompleted) {
                      _controller
                        ..reset()
                        ..forward();
                    }
                    animate = false;
                  }

                  return Container();

                //  NewSearchRoomAndPassinger(isfromnavbar: () {
                //   if (widget.isFromNavBar ?? false) {
                //     context
                //         .read<PackSearchController>()
                //         .newSearchTitle(AppLocalizations.of(context)!.where_From);
                //     // Navigator.of(context)
                //     //     .pushNamedAndRemoveUntil(TabPage.idScreen, (route) => false);
                //   } else {
                //     Navigator.of(context).pop();
                //     context
                //         .read<PackSearchController>()
                //         .newSearchTitle(AppLocalizations.of(context)!.where_From);
                //   }
                // }, next: () {
                //   context
                //       .read<PackSearchController>()
                //       .newSearchTitle(AppLocalizations.of(context)!.travelerDetails);
                //   i = 4;
                //   setState(() {});
                // }, ontap: () {
                //   animate = true;
                //   context
                //       .read<PackSearchController>()
                //       .newSearchTitle(AppLocalizations.of(context)!.when_will_you_be_there);
                //   setState(() {
                //     i = 1;
                //     print(i);
                //   });
                // });

                case 3:
                  _controller.forward();

                  if (animate) {
                    _controller.forward();

                    if (_controller.isCompleted) {
                      _controller
                        ..reset()
                        ..forward();
                    }
                    animate = false;
                  }

                  return Container();

                //  AdvanceSearchOption(
                //     next: () {},
                //     ontap: () {
                //       animate = true;
                //       context
                //           .read<PackSearchController>()
                //           .newSearchTitle(AppLocalizations.of(context)!.who_Coming);
                //       setState(() {
                //         i = 2;
                //         print(i);
                //       });
                //     });

                case 4:
                  {
                    _controller.forward();

                    if (animate) {
                      _controller.forward();

                      if (_controller.isCompleted) {
                        _controller
                          ..reset()
                          ..forward();
                      }
                      animate = false;
                    }
                    return Container();

                    // PrivetJetInformation(next: () {
                    //   i = 5;
                    //   setState(() {});
                    // }, onTapBack: () {
                    //   i = 2;
                    //   setState(() {});
                    // });
                  }

                case 5:
                  {
                    _controller.forward();

                    if (animate) {
                      _controller.forward();

                      if (_controller.isCompleted) {
                        _controller
                          ..reset()
                          ..forward();
                      }
                      animate = false;
                    }
                    return Container();

                    //  TravelInsuranceForms(
                    //   onTapBack: () {
                    //     i = 4;
                    //     setState(() {});
                    //   },
                    //   next: () {},
                    // );
                  }

                default:
                  return Container();
              }
            }),
          ],
        ));
  }
}
