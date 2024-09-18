import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';

import '../custom_image.dart';

class ImagesMediaView extends StatefulWidget {
  const ImagesMediaView({super.key, required this.images});
  final List<String> images;

  @override
  State<ImagesMediaView> createState() => _ImagesMediaViewState();
}

class _ImagesMediaViewState extends State<ImagesMediaView> {
  int currentImageIndex = 0;

  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _staticVar.primaryColor,
        elevation: 0.1,
        title: Text(
          "معرض الصور",
          style: TextStyle(
            fontSize: _staticVar.titleFontSize.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: CarouselSlider(
                  items: widget.images
                      .map((e) => CustomImage(
                            url: e,
                          ))
                      .toList(),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 50.h,
                    onPageChanged: (index, reason) {
                      currentImageIndex = index + 1;
                      setState(() {});
                    },
                  ),
                ),
              ),
              Positioned(
                  bottom: 5,
                  left: 10,
                  right: 0,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 20.w,
                      child: Text(
                        "$currentImageIndex من ${widget.images.length}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: _staticVar.titleFontSize.sp, color: _staticVar.cardcolor),
                      ),
                    ).asGlass(
                        clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius),
                        tintColor: _staticVar.blackColor),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
