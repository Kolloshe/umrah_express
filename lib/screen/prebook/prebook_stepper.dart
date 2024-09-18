import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glass/glass.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controller/search_controller.dart';
import 'activity_questions.dart';
import 'passenger_forms.dart';
import 'prebook_failed_view.dart';
import 'special_request_to_room.dart';

enum Steppers {
  passengerInformation,
  roomRequest,
  activityQuestions,
}

class PrebookStepper extends StatefulWidget {
  const PrebookStepper({super.key});

  @override
  State<PrebookStepper> createState() => _PrebookStepperState();
}

class _PrebookStepperState extends State<PrebookStepper> with SingleTickerProviderStateMixin {
  Steppers currentStep = Steppers.passengerInformation;

  final _staticVar = StaticVar();

  late AnimationController _animationController;

  late Animation<Offset> _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0))
        .animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/vectors/vector_v2/2.jpg"), fit: BoxFit.cover),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.1, 0.2, 0.5],
                colors: [
                  _staticVar.primaryColor,
                  const Color(0xff788cb6),
                  _staticVar.yellowColor,
                ],
              ),
            ),
          ),
          Positioned(
            top: 15.h,
            left: context.read<UserController>().locale == const Locale("en") ? 7.w : 40.w,
            child: SizedBox(
              child: Consumer<UserController>(
                builder: (BuildContext context, title, Widget? child) {
                  return Text(
                    AppLocalizations.of(context)?.passengersInformation ?? "Passenger information",
                    style: TextStyle(
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        fontSize: 24.sp,
                        color: Colors.white),
                  ).animate().fade();
                },
              ),
            ),
          ),
          SizedBox.expand(
              child: DraggableScrollableSheet(
                  maxChildSize: 0.9,
                  minChildSize: 0.80,
                  initialChildSize: 0.80,
                  expand: false,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                      child: SlideTransition(
                        position: _animation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                primary: false,
                                controller: scrollController,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  height: 8.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                      color: _staticVar.primaryColor.withAlpha(200),
                                      borderRadius: BorderRadius.circular(10.0)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Builder(builder: (context) {
                                  switch (currentStep) {
                                    case Steppers.passengerInformation:
                                      return PassengerFroms(
                                        updateCurrentStep: (value) {
                                          currentStep = value;
                                          setState(() {});
                                        },
                                      );
                                    case Steppers.roomRequest:
                                      return SpecialRequestToRoom(updateCurrentStep: (value) {
                                        currentStep = value;
                                        setState(() {});
                                      });
                                    case Steppers.activityQuestions:
                                      return ActivityQuestionsView(
                                        updateCurrentStep: (value) async {
                                          if (value == Steppers.activityQuestions) {
                                            final result = await context
                                                .read<PrebookController>()
                                                .proceedPreBooking(
                                                    context
                                                            .read<UserController>()
                                                            .userModel
                                                            ?.data
                                                            ?.token ??
                                                        '',
                                                    context
                                                        .read<PackSearchController>()
                                                        .userCollectedPoint);

                                            if (result == false) {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PrebookFailedServicesView()));
                                            }
                                          } else {
                                            currentStep = value;
                                            setState(() {});
                                          }
                                        },
                                      );
                                  }
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).asGlass(tintColor: _staticVar.cardcolor);
                  }))
        ],
      ),
    );
  }
}
