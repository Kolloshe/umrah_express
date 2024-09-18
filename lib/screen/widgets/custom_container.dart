import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer(
      {super.key, required this.child, this.margin, this.padding, this.radius, this.withShadow});

  final Widget child;

  final double? margin;

  final bool? padding;

  final bool? withShadow;

  final double? radius;

  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin != null ? margin! : _staticVar.defaultPadding),
      padding: EdgeInsets.all((padding ?? false) ? _staticVar.defaultPadding : 0),
      decoration: BoxDecoration(
          color: _staticVar.cardcolor,
          boxShadow: (withShadow ?? false)
              ? [
                  BoxShadow(
                      color: _staticVar.blackColor.withAlpha(5),
                      offset: const Offset(0, 0),
                      blurRadius: 3,
                      spreadRadius: 3),
                ]
              : null,
          borderRadius: BorderRadius.circular(radius ?? 0)),
      child: child,
    );
  }
}
