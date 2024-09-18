import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';

class CustomSearchFormDebouncer extends StatefulWidget {
  const CustomSearchFormDebouncer(
      {super.key, required this.method, this.title, required this.controller});
  final Function(String c) method;
  final String? title;
  final TextEditingController controller;

  @override
  State<CustomSearchFormDebouncer> createState() => _CustomSearchFormDebouncerState();
}

class _CustomSearchFormDebouncerState extends State<CustomSearchFormDebouncer> {
  final _staticVar = StaticVar();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: widget.controller,
      cursorColor: _staticVar.primaryColor,
      onChanged: (value) {
        EasyDebounce.debounce(
            'Search', // <-- An ID for this particular debouncer
            const Duration(milliseconds: 500), // <-- The debounce duration
            () {
          widget.method(value);
        } // <-- The target method
            );
      },
      style: TextStyle(color: _staticVar.cardcolor),
      decoration: InputDecoration(
        hintText: widget.title,
        hintStyle: TextStyle(
          color: _staticVar.gray,
        ),
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );
  }
}
