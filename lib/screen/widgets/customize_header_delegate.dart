
import 'package:flutter/material.dart';

class CustmizeHederDelegate extends SliverPersistentHeaderDelegate {
  final double max;
  final double min;
  final Widget Function(double percent) builder;

  CustmizeHederDelegate({
    required this.max,
    required this.min,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(shrinkOffset / max);
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
