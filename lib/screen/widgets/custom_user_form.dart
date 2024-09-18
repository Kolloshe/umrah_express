import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:sizer/sizer.dart';

class CustomUserForm extends StatelessWidget {
  CustomUserForm(
      {super.key,
      this.controller,
      required this.hintText,
      this.validator,
      this.withShadow,
      this.prefix,
      this.readOnly,
      this.onTap,
      this.maxLine,
      this.isPassword,
      this.onSaved});

  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? withShadow;
  final Widget? prefix;
  final bool? readOnly;
  final void Function()? onTap;
  final int? maxLine;
  final bool? isPassword;
  final void Function(String?)? onSaved;

  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      padding: EdgeInsets.symmetric(
        horizontal: _staticVar.defaultPadding * 2,
        //  vertical: _staticVar.defaultPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        //  color: Colors.grey.shade200,
      ),
      child: TextFormField(
        onTap: (readOnly ?? false) ? onTap : null,
        readOnly: readOnly ?? false,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        cursorColor: _staticVar.primaryColor,
        controller: controller,
        validator: validator,
        obscureText: isPassword ?? false,
        maxLines: maxLine,
        style: TextStyle(fontSize: _staticVar.titleFontSize.sp, color: _staticVar.blackColor),
        decoration: InputDecoration(
            label: Text(
              hintText,
              style:
                  TextStyle(fontSize: _staticVar.subTitleFontSize.sp, color: _staticVar.blackColor),
            ),
            prefix: prefix,
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: _staticVar.subTitleFontSize.sp)),
        onSaved: onSaved,
      ),
    ).asGlass(clipBorderRadius: BorderRadius.circular(_staticVar.defaultInnerRadius));
  }
}
