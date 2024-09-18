import 'dart:async';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/custom_extension.dart';
import '../../auth/settings/profile/user_booking_view.dart';

class CoinPaymentView extends StatefulWidget {
  const CoinPaymentView({super.key, required this.duration, required this.id, required this.url});
  final String url;
  final String id;

  final Duration duration;

  @override
  State<CoinPaymentView> createState() => _CoinPaymentViewState();
}

class _CoinPaymentViewState extends State<CoinPaymentView> {
  late WebViewController controller;

  final _streamController = StreamController<Response>();

  final _staticVar = StaticVar();
  double showWebView = 1.0;
  bool hideTimer = false;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  getdata() async {
    context.read<PrebookController>().getCoinPaymentStatus = {};
    await context.read<PrebookController>().tryThis(widget.id);
  }

  @override
  void initState() {
    _streamController.addStream(context.read<PrebookController>().coinPaymentStreaming(widget.id));
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: _staticVar.cardcolor,
        title: Text(
          AppLocalizations.of(context)!.payment,
          style: TextStyle(color: _staticVar.blackColor),
        ),
        leading: GestureDetector(
            onTap: () async {
              final valid = await controller.canGoBack();
              final z = await controller.currentUrl();
              print(z);
              if (valid) {
                await controller.goBack();
              }
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              color: _staticVar.primaryColor,
            )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.white),
            child: hideTimer
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.all(10),
                    height: 48.0,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.countdownConfirm ?? ' Time to confirm ',
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
      body: Consumer<PrebookController>(builder: (context, data, child) {
        switch (data.switchThePaymentResponse()) {
          case 0:
            Future.delayed(const Duration(seconds: 1), () {
              hideTimer = false;
              setState(() {});
            });
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Opacity(
                  opacity: showWebView,
                  child: WebView(
                    key: Keyz.riKey2,
                    gestureRecognizers: gestureRecognizers,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: widget.url,
                    onWebViewCreated: (controller) {
                      this.controller = controller;
                    },
                    onProgress: (i) {},
                    onPageStarted: (v) async {
                      if (v.contains('ethereum:') ||
                          v.contains('bitcoin:') ||
                          v.contains('dogecoin:') ||
                          v.contains('litecoin:') ||
                          v.contains('bitcoincash:') ||
                          v.contains('usdcoint:') ||
                          v.contains('dai:') ||
                          v.contains('apecoin:') ||
                          v.contains('shibainu:') ||
                          v.contains('terther:')) {
                        if (await canLaunchUrl(Uri.parse(v))) {
                          launchUrl(Uri.parse(v));
                        } else {
                          _staticVar.showToastMessage(
                              message:
                                  "we couldn't  find a wallet , \nyou can use address to complete the payment");
                        }
                      }
                      //     pressIndcatorDialog(context);
                    },
                    onPageFinished: (url) {
                      //      Navigator.of(context).pop();
                      readJS(url);
                    },
                  ),
                ),
              ),
            );
          case 200:
            return _buildCompletedPaymentUI(data.getCoinPaymentStatus['message']);
          case 302:
            hideTimer = true;
            Future.delayed(const Duration(seconds: 1), () {
              if (!mounted) return;
              context.read<PrebookController>().setStopCountDownTimer(true);
              setState(() {});
            });
            return _buildDelayedPaymentUI(data.getCoinPaymentStatus['message']);
          case 406:
            hideTimer = true;
            Future.delayed(const Duration(seconds: 1), () {
              if (!mounted) return;
              context.read<PrebookController>().setStopCountDownTimer(true);
              setState(() {});
            });
            return _buildDelayedPaymentUI(data.getCoinPaymentStatus['message']);
          case 206:
            hideTimer = true;

            Future.delayed(const Duration(seconds: 1), () {
              if (!mounted) return;
              context.read<PrebookController>().setStopCountDownTimer(true);
              setState(() {});
            });
            return _buildPendingPaymentUI(data.getCoinPaymentStatus['message']);
          case 402:
            return _buildCancelledPaymentUI(data.getCoinPaymentStatus['message']);
          default:
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Opacity(
                  opacity: showWebView,
                  child: WebView(
                    key: Keyz.riKey2,
                    gestureRecognizers: gestureRecognizers,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: widget.url,
                    onWebViewCreated: (controller) {
                      this.controller = controller;
                    },
                    onProgress: (i) {},
                    onPageStarted: (v) async {
                      if (v.contains('ethereum:') ||
                          v.contains('bitcoin:') ||
                          v.contains('dogecoin:') ||
                          v.contains('litecoin:') ||
                          v.contains('bitcoincash:') ||
                          v.contains('usdcoint:') ||
                          v.contains('dai:') ||
                          v.contains('apecoin:') ||
                          v.contains('shibainu:') ||
                          v.contains('terther:')) {
                        if (await canLaunchUrl(Uri.parse(v))) {
                          launchUrl(Uri.parse(v));
                        } else {
                          _staticVar.showToastMessage(
                              message:
                                  "we couldn't  find a wallet , \nyou can ues address to complete the payment");
                        }
                      }
                      //     pressIndcatorDialog(context);
                    },
                    onPageFinished: (url) {
                      //      Navigator.of(context).pop();
                      readJS(url);
                    },
                  ),
                ),
              ),
            );
        }
      }),
    );
  }

  Widget _buildCompletedPaymentUI(String message) {
    hideTimer = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      context.read<PrebookController>().setStopCountDownTimer(true);
      setState(() {});
    });
    return Column(
      children: [
        Lottie.asset('assets/animation/done.json', fit: BoxFit.contain, repeat: false),
        Text(
          '$message \n\n\n',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: _staticVar.greenColor),
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
    );
  }

  readJS(String url) async {
    if (url.contains('transaction/cancelled')) {
      showWebView = 0.0;
      setState(() {});
      final result = await context.read<PrebookController>().getCoinPaymentResult(url);
      if (!mounted) return;
      context.read<PrebookController>().setStopCountDownTimer(true);
      _buildResultDialog(title: result, msg: '', lottie: 'assets/animation/failed.json', actions: [
        CustomBTN(
          onTap: () {
            Navigator.of(context)
              ..pop()
              ..pop()
              ..pop();
          },
          title: AppLocalizations.of(context)?.cancel ?? "Cancel",
          color: _staticVar.primaryColor,
        ),
      ]);
    } else if (url.contains('transaction/completed')) {
      showWebView = 0.0;
      setState(() {});
      final result = await context.read<PrebookController>().getCoinPaymentResult(url);
      if (!mounted) return;
      context.read<PrebookController>().setStopCountDownTimer(true);
      _buildResultDialog(title: result, msg: '', lottie: 'assets/animation/done.json', actions: [
        CustomBTN(
          onTap: () async {
            final result = await context.read<UserController>().getUserBookingList();
            if (!mounted) return;
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Lottie.asset('assets/animation/pending.json', fit: BoxFit.contain, repeat: true),
        ),
        Text(
          '$message \n\n\n',
          style:
              TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: _staticVar.yellowColor),
        ),
      ],
    );
  }

  Widget _buildCancelledPaymentUI(String message) {
    hideTimer = true;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      context.read<PrebookController>().setStopCountDownTimer(true);
      setState(() {});
    });
    return Column(
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
    );
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
}
