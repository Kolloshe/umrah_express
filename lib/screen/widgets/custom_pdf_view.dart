import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key, required this.url, required this.title, required this.isPDF});

  final String url;
  final String title;
  final bool isPDF;

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  final _staticVar = StaticVar();

  late WebViewController controller;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  @override
  void initState() {
    if (widget.isPDF) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {});

      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
          ),
        ),
        backgroundColor: _staticVar.cardcolor,
        foregroundColor: _staticVar.primaryColor,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(_staticVar.defaultPadding),
        child: widget.isPDF
            ? SfPdfViewer.network(
                widget.url,
              )
            : WebView(
                gestureRecognizers: gestureRecognizers,
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,

                // onPageFinished: (s) async {
                //   Navigator.of(context).pop();
                //   await injectJS();
                //   print('on Finish ' + s);
                //   //injectJS();
                // },
                // onPageStarted: (s) {
                //   showDialog(
                //       context: context,
                //       barrierDismissible: false,
                //       builder: (context) => PressIndcator());
                //   print('onStart' + s);
                // },
                onWebViewCreated: (con) {
                  controller = con;
                },
              ),
      )),
    );
  }
}
