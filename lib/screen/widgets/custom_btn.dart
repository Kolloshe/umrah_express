import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:umrah_by_lamar/common/static_var.dart';

class CustomBTN extends StatelessWidget {
  CustomBTN({super.key, required this.onTap, required this.title, this.color});
  final String title;

  final VoidCallback? onTap;

  final Color? color;

  final staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? staticVar.primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(staticVar.defaultInnerRadius))),
      ),
      child: Text(
        title,
        style: TextStyle(color: staticVar.cardcolor, fontSize: staticVar.subTitleFontSize.sp),
      ),
    );
  }
}
