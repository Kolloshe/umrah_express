import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/screen/widgets/image_spinning.dart';
import 'package:lottie/lottie.dart';

class CustomImage extends StatelessWidget {
  CustomImage(
      {super.key,
      required this.url,
      this.boxFit,
      this.height,
      this.width,
      this.withHalfRadius,
      this.withRadius});
  final String url;
  final BoxFit? boxFit;
  final double? width;
  final double? height;
  final bool? withRadius;
  final bool? withHalfRadius;
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: (withRadius ?? false)
          ? BorderRadius.circular(_staticVar.defaultRadius)
          : (withHalfRadius ?? false)
              ? BorderRadius.only(
                  topLeft: Radius.circular(_staticVar.defaultRadius),
                  topRight: Radius.circular(_staticVar.defaultRadius),
                )
              : BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: boxFit,
        placeholder: (context, url) => ImageSpinning(
          withOpasity: true,
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/loader-aiwa.png',
          width: width,
          height: height,
          fit: boxFit,
        ),
        colorBlendMode: BlendMode.hardLight,
      ),
    );
  }
}
