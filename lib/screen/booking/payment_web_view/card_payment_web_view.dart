import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/custom_extension.dart';
import '../../../controller/user_controller.dart';
import '../../auth/settings/profile/user_booking_view.dart';
import '../../widgets/custom_btn.dart';

class CardPaymentView extends StatefulWidget {
  const CardPaymentView(
      {super.key, required this.duration, required this.url, required this.streamApi});

  final String url;
  final Duration duration;
  final String streamApi;

  @override
  State<CardPaymentView> createState() => _CardPaymentViewState();
}

class _CardPaymentViewState extends State<CardPaymentView> with WidgetsBindingObserver {
  final _staticVar = StaticVar();

  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  late WebViewController controller;
  bool showBackButton = true;

  double showWebView = 1.0;

  @override
  void initState() {
    if (Platform.isAndroid) if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  Stream<Response> getData() {
    final x = context.read<PrebookController>().getRandomNumberFact(widget.streamApi);

    print(widget.streamApi);
    return x;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool hideTimer = false;

  @override
  Widget build(BuildContext context) {
    print('>>>> ');

    return WillPopScope(
        onWillPop: () => Future.value(true),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.1,
            backgroundColor: _staticVar.cardcolor,
            title: Text(
              AppLocalizations.of(context)!.payment,
              style: TextStyle(color: _staticVar.blackColor),
            ),
            leading: showBackButton
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Provider.of<UserController>(context, listen: false).locale == Locale('en')
                          ? Icons.keyboard_arrow_left
                          : Icons.keyboard_arrow_right,
                      color: _staticVar.primaryColor,
                      size: 30.sp,
                    ))
                : const SizedBox(),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: hideTimer
                  ? const SizedBox()
                  : Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.white),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 48.0,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)?.countdownConfirm ??
                                    ' Time to confirm ',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              SlideCountdownSeparated(
                                duration: widget.duration,
                                showZeroValue: false,
                                countUp: false,
                                onChanged: (d) {},
                                onDone: () {
                                  // 'end and you will redirect to customize phase ';
                                  setState(() {});
                                  // Navigator.of(context).pop();
                                },
                              ),
                            ],
                          )),
                    ),
            ),
          ),
          body: StreamBuilder<Response>(
            stream: getData(),
            builder: (context, AsyncSnapshot<Response> snap) {
              String statusText = '';
              String paymentMessage = '';
              log((snap.data?.body ?? '').toString());
              if (snap.data?.body != null) {
                final dd = json.decode(snap.data?.body.replaceFirst('data: ', '') ?? '');

                statusText = dd['code'].toString();

                paymentMessage = dd['message'];
              }

              //['code'=>'102', 'message'=>'Processing transaction/waiting for payment'];
              //
              // ['code'=>'402','message'=>'Transaction Failed']
              //
              // ['code'=>'499','message'=>'Transaction Cancelled']
              //
              // ['code'=>'202','message'=>'Transaction completed, processing booking !']
              //
              // ['code'=>'406','message'=>'Transaction success,booking failed']
              //
              // ['code'=>'100','message'=>'Transaction success,booking in progress']
              //
              // ['code'=>'200','message'=>'Transaction success,booking success']
              //{"code":422,
              // "error":true,
              // "message":"Prebook failed",
              // "data":{"payUrl":"","details":{"package_name":"London(5N) with Jack the Ripper Walking Tour",
              // "package_days":5,"flight":{"carriers":{"SV":"Saudi Arabian"},"selling_currency":"AED","max_stop":1,
              // "start_date":"04 May 2022","end_date":"09 May 2022","travel_data":[{"travel_time":650,"numstops":1,
              // "stops":["RUH"],"carriers":[{"code":"SV","name":"Saudi Arabian"}],
              // "start":{"date":"2022-05-04","time":"22:30","locationId":"DXB",
              // "terminal":true,"timezone":"Asia/Dubai"},"end":{"date":"2022-05-05",
              // "time":"06:20","locationId":"LHR","terminal":true,"timezone":"Europe/London"},
              // "itenerary":[{"company":{"marketingCarrier":"SV","operatingCarrier":"SV",
              // "logo":"https://mapi2.ibookholiday.com/flight/image/SV"},"flightNo":"553",
              // "departure":{"date":"2022-05-04","time":"22:30","locationId":"DXB",
              // "timezone":"Asia/Dubai","airport":"Dubai Intl Arpt","city"
              // :"Dubai","terminal":true},"flight_time":120,"arrival":{"date":"2022-05-04","time":"23:30","locationId":"RUH","<…>
              // Reloaded 82 of 2912 libraries in 1,213ms (compile: 664 ms, reload: 266 ms, reassemble: 263 ms).

              switch (statusText.trim().toLowerCase()) {
                case '200':
                  return _buildCompletedPaymentUI(paymentMessage);
                case '100':
                  return _buildPendingPaymentUI(paymentMessage);

                case '402':
                  return _buildCancelledPaymentUI(paymentMessage);

                case '499':
                  return _buildCancelledPaymentUI(paymentMessage);
                case '202':
                  return _buildPendingPaymentUI(paymentMessage);
                default:
                  return Opacity(
                    opacity: showWebView,
                    child: WebView(
                      key: Keyz.riKey1,
                      gestureRecognizers: gestureRecognizers,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: //'http://192.168.0.222/ibookaholidaynew/err-2?payment=failed',
                          widget.url,
                      onWebViewCreated: (controller) {
                        this.controller = controller;
                      },
                      onProgress: (i) {},
                      onPageStarted: (v) {
                        print(v);
                        if (v == 'https://migs.mastercard.com.au/ssl') {
                          showBackButton = false;
                          setState(() {});
                        }
                        //   pressIndcatorDialog(context);
                      },
                      onPageFinished: (url) {
                        readJS(url);
                      },
                    ),
                  );
              }
            },
          ),
        ));
  }

  void readJS(String url) async {
    String status;
    try {
      if (url.contains('payment=')) {
        final result = await controller.currentUrl();

        status = result!.split('payment=').last;
        String html = await controller.evaluateJavascript("document.documentElement.innerText");
        controller.evaluateJavascript(
            "document.getElementsByClassName('design-header')[0].style.display='none'");
        controller.evaluateJavascript(
            "document.getElementsByClassName('explore-main')[0].style.display='none'");
        controller
            .evaluateJavascript("document.getElementsByTagName('footer')[0].style.display='none'");
        // this.controller.evaluateJavascript(
        //     "document.getElementsByClassName('breadcrumb')[0].style.display='none'");

        if (status == 'success') {
          context.read<PrebookController>().setStopCountDownTimer(true);

          _buildResultDialog(
              msg: AppLocalizations.of(context)!.bookingWasSuccessfully,
              title: AppLocalizations.of(context)!.congratulations,
              lottie: 'assets/animation/done.json',
              actions: [
                CustomBTN(
                  onTap: () async {
                    final result = await context.read<UserController>().getUserBookingList();

                    if (result) {
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pop()
                        ..push(MaterialPageRoute(builder: (context) => const UserBookingsView()));
                    } else {
                      _staticVar.showToastMessage(
                          message: AppLocalizations.of(context)?.theyNoBooking ?? '');
                    }
                  },
                  title: AppLocalizations.of(context)!.seeConfirmationDetails,
                  color: _staticVar.primaryColor,
                ),
              ]);
        }
      } else if (url.contains('transaction/cancelled')) {
        showWebView = 0.0;
        setState(() {});

        final paymentFailedReason =
            await context.read<PrebookController>().getPaymentFailedReason(url);

        if (paymentFailedReason != null) {
          context.read<PrebookController>().setStopCountDownTimer(true);

          _buildResultDialog(
              msg: paymentFailedReason.data?.errorDesc ?? '',
              title: paymentFailedReason.data?.errorMsg ?? 'Payment Cancelled',
              lottie: "assets/animation/failed.json",
              actions: [
                CustomBTN(
                    onTap: () {
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pop()
                        ..pop();
                    },
                    title: AppLocalizations.of(context)!.cancel)
              ]);
        }
      } else if (url.contains('booking-failed')) {
        showWebView = 0.0;
        setState(() {});

        final bookingFailedReason =
            await context.read<PrebookController>().getBookingFailedReason(url);

        if (bookingFailedReason != null) {
          context.read<PrebookController>().setStopCountDownTimer(true);
          _buildResultDialog(
              msg: bookingFailedReason.data?.desc ?? '',
              title: bookingFailedReason.data?.message ?? 'Booking Failed',
              lottie: 'assets/animation/failed.json',
              actions: [
                CustomBTN(
                  onTap: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop()
                      ..pop();
                  },
                  title: AppLocalizations.of(context)!.cancel,
                ),
              ]);
        }
      }
    } catch (e) {
      context.read<PrebookController>().setStopCountDownTimer(true);
      _buildResultDialog(
          msg: 'something went wrong please try again',
          title: 'booking failed',
          lottie: 'assets/animation/failed.json',
          actions: [
            CustomBTN(
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..pop()
                  ..pop()
                  ..pop();
              },
              title: AppLocalizations.of(context)!.cancel,
            ),
          ]);
      print(e);
    }
  }

  _buildResultDialog(
      {required String title, required String msg, String? lottie, List<Widget>? actions}) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                padding: EdgeInsets.all(_staticVar.defaultPadding),
                decoration: BoxDecoration(
                  color: _staticVar.cardcolor,
                  borderRadius: BorderRadius.circular(_staticVar.defaultRadius),
                ),
                child: Column(
                  children: [
                    if (lottie != null) ...[Lottie.asset(lottie)],
                  ],
                ),
              ),
            ));
  }

  Widget _buildDelayedPaymentUI(String message) {
    hideTimer = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      context.read<PrebookController>().setStopCountDownTimer(true);
      setState(() {});
    });
    return Column(
      children: [
        Lottie.asset('assets/animation/information-session.json',
            fit: BoxFit.contain, repeat: false),
        Text(
          '$message\n\n',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomBTN(
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pop()
                ..pop();
            },
            title: AppLocalizations.of(context)?.back ?? 'Back',
            color: _staticVar.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPendingPaymentUI(String message) {
    hideTimer = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      context.read<PrebookController>().setStopCountDownTimer(true);
      setState(() {});
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Lottie.asset('assets/animation/pending.json', fit: BoxFit.contain, repeat: true),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            '$message \n\n\n',
            style:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: _staticVar.yellowColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledPaymentUI(String message) {
    hideTimer = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      context.read<PrebookController>().setStopCountDownTimer(true);
      setState(() {});
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Lottie.asset('assets/animation/failed.json', fit: BoxFit.contain, repeat: false),
          Text(
            '$message\n\n',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomBTN(
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..pop()
                  ..pop()
                  ..pop();
              },
              title: AppLocalizations.of(context)?.back ?? 'Back',
              color: _staticVar.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedPaymentUI(String message) {
    hideTimer = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      context.read<PrebookController>().setStopCountDownTimer(true);
      setState(() {});
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Lottie.asset('assets/animation/done.json', fit: BoxFit.contain, repeat: false),
          Text(
            '$message \n\n\n',
            style:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: _staticVar.greenColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomBTN(
              onTap: () async {
                final result = await context.read<UserController>().getUserBookingList();

                if (result) {
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop()
                    ..push(MaterialPageRoute(builder: (context) => const UserBookingsView()));
                } else {
                  _staticVar.showToastMessage(
                      message: AppLocalizations.of(context)?.theyNoBooking ?? '');
                }
              },
              title: AppLocalizations.of(context)!.seeConfirmationDetails,
              color: _staticVar.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
