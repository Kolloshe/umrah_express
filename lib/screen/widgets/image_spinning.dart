import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class ImageSpinning extends StatefulWidget {
  const ImageSpinning({super.key, required this.withOpasity});

  final bool withOpasity;

  @override
  State<ImageSpinning> createState() => _ImageSpinningState();
}

class _ImageSpinningState extends State<ImageSpinning> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return SizedBox(
            width: 15.w,
            height: 10.h,
            child: Transform.rotate(
              angle: _controller.value * 6 * math.pi,
              child: SizedBox(
                width: 15.w,
                height: 10.h,
                child: Opacity(
                    opacity: widget.withOpasity ? 0.5 : 1,
                    child: SizedBox(
                      width: 15.w,
                      height: 10.h,
                      child: Image.asset(
                        'assets/images/lamarlogo/logo.png',
                        width: 15.w,
                        height: 15.w,
                      ),
                    )),
              ),
            ),
          );
        },
        child: Image.asset(
          'assets/images/loader-aiwa.png',
          width: 15.w,
          height: 15.w,
        ),
      ),
    );
  }
}
