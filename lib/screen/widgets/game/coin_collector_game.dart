// import 'dart:math';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'package:flutter/material.dart';
// import 'package:umrah_by_lamar/common/static_var.dart';
// import 'package:umrah_by_lamar/controller/user_controller.dart';
// import 'package:umrah_by_lamar/screen/widgets/custom_loading_with_game.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// import '../../../controller/home_controller.dart';

// class CoinCollectorGame extends StatefulWidget {
//   const CoinCollectorGame({super.key});

//   @override
//   State<CoinCollectorGame> createState() => _CoinCollectorGameState();
// }

// class _CoinCollectorGameState extends State<CoinCollectorGame> {
//   bool _isStartPlaying = true;


//   int lifePoint = 3;
//   int playerScore = 0;

//   final birdKey = GlobalKey();
//   Offset globalBirdOffset = Offset.zero;


//   double birdLeft = 180;
//   double birdTop = 500;


//   final _staticVar = StaticVar();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _staticVar.primaryblue.withAlpha(130),
//       body: Stack(
//         children: [
//           _isStartPlaying
//               ? Positioned(
//                   top: kToolbarHeight,
//                   left: 10,
//                   child: Row(
//                     children: [
//                       for (var k = 0; k < lifePoint; k++)
//                         const Icon(Icons.favorite, color: Colors.red),
//                     ],
//                   ))
//               : const SizedBox(),
//           _isStartPlaying
//               ? Positioned(
//                   top: kToolbarHeight,
//                   right: 10,
//                   child: Text(AppLocalizations.of(context)!.coins + playerScore.toString(),
//                       style: TextStyle(
//                           fontSize: _staticVar.titleFontSize.sp, fontWeight: FontWeight.bold)))
//               : const SizedBox(),

//   Positioned(
//                     top: birdTop,
//                     left: birdLeft,
//                     child: IgnorePointer(
//                       ignoring: (context.read<HomeController>().homeDataModel?.data?.isGameControlActive ??
//                               false) ==
//                           false,
//                       child: Draggable<int>(
//                         data: 0,
//                         feedback: SizedBox(),
//                         onDragUpdate: (d) {
//                           globalBirdOffset = d.globalPosition;

//                           setState(() {
//                             _isDraging = true;
//                             birdTop =
//                                 d.globalPosition.dy - birdKey.globalPaintBounds!.size.height / 1.5;
//                             birdLeft = d.globalPosition.dx - birdKey.globalPaintBounds!.size.width / 2;
//                           });
//                           if (isGameOver) return;
//                           isStartPlaying = true;

//                           _onGetCoin();
//                           //      _onTouchTheCloud();
//                         },
//                         onDraggableCanceled: (v, o) {
//                           _isOnScreen = false;
//                           print('pan cancel');
//                           if (!mounted) return;
//                           setState(() {
//                             _isDraging = false;
//                             _animationControllerBird.forward();
//                           });
//                         },
//                         onDragStarted: () {
//                           _isOnScreen = true;
//                           Provider.of<AppData>(context, listen: false)
//                               .gundletheDisountDialog(false);
//                           _animationControllerBird.stop();
//                         },
//                         child: SlideTransition(
//                           position: _animationBird,
//                           child: Container(
//                             key: birdKey,
//                             alignment: Alignment.center,
//                             child: Center(
//                                 child: Image.asset(
//                               "assets/images/loading/loading_bird.png",
//                               scale: 4,
//                             )),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

              
//         ],
//       ),
//     );
//   }
// }

// class CloudTarget extends StatefulWidget {
//   const CloudTarget(
//       {super.key,
//       required this.top,
//       required this.left,
//       required this.scale,
//       required this.onHitCloud,
//       required this.target});
//   final double top;
//   final double left;
//   final double scale;
//   final VoidCallback onHitCloud;
//   final bool target;

//   @override
//   State<CloudTarget> createState() => _CloudTargetState();
// }

// class _CloudTargetState extends State<CloudTarget> with SingleTickerProviderStateMixin {
//   late AnimationController _animationControllerCloud;
//   late Animation<Offset> _animationCloud;
//   bool istarget = true;
//   final _random = Random();

//   _cloudLoadingAnimation() {
//     _animationControllerCloud =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));

//     _animationCloud = Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 25.0))
//         .animate(_animationControllerCloud);

//     _animationCloud.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animationControllerCloud.reset();
//         setState(() {
//           istarget = _random.nextBool();
//         });
//         _animationControllerCloud.forward();
//       } else if (status == AnimationStatus.dismissed) {
//         _animationControllerCloud.forward();
//       }
//     });
//     Future.delayed(const Duration(seconds: 1), () {
//       if (!mounted) return;
//       _animationControllerCloud.forward();
//     });
//   }

//   @override
//   void initState() {
//     istarget = widget.target;
//     _cloudLoadingAnimation();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _animationControllerCloud.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: widget.top,
//       left: widget.left,
//       child: SlideTransition(
//         position: _animationCloud,
//         child: DragTarget<int>(
//           // onLeave: (data) {
//           //   if (!istarget) return;
//           //   widget.onHitCloud();
//           // },
//           onMove: (data) {
//             if (!istarget) return;
//             widget.onHitCloud();
//           },
//           // onWillAccept: (data){
//           //
//           //   if (!istarget) return false;
//           //   print('will');
//           //   widget.onHitCloud();
//           //   return true;
//           // },
//           builder:
//               (BuildContext context, List<Object?> candidateData, List<dynamic> rejectedData) =>
//                   Opacity(
//             opacity: 0.5,
//             child: Image.asset(
//               'assets/images/loading/cloud.png',
//               scale: widget.scale,
//               color: istarget ? Colors.grey : Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
