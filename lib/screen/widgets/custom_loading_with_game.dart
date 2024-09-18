// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:umrah_by_lamar/controller/home_controller.dart';
import 'package:umrah_by_lamar/controller/search_controller.dart';
import 'package:umrah_by_lamar/controller/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingWidgetMain extends StatefulWidget {
  const LoadingWidgetMain({super.key});

  @override
  State<LoadingWidgetMain> createState() => _LoadingWidgetMainState();
}

class _LoadingWidgetMainState extends State<LoadingWidgetMain> with TickerProviderStateMixin {
  final coinKey = GlobalKey();
  final birdKey = GlobalKey();
  final cloudKey = GlobalKey();
  late AnimationController _animationControllerBird;
  late Animation<Offset> _animationBird;

  late AnimationController _animationControllerCoin;
  late Animation<Offset> _animationCoin;

  double dragtop = 500;
  double dragleft = 210;

  String bottomText = 'Catch the coins to unlock your Discount!';

  int hiting = 0;
  int lifePoint = 3;

  int playerScore = 0;

  Timer? scoreManager;

  int playerLifePoint = 3;
  int random = 200;

  bool isStartPlaying = false;

  bool isPlayerFingerLeftTheScreen = true;

  bool isOnCandelmode = false;

  bool _isDraging = false;

  Offset globalCoinOffset = Offset.zero;
  Offset globalBirdOffset = Offset.zero;
  Offset globalCloudOffset = Offset.zero;

  @override
  void initState() {
    _birdLoadingAnimation();
    _coinAnimation();
    // _cloudLoadingAnimation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      birdBox = birdKey.currentContext!.findRenderObject() as RenderBox;
      context.read<PackSearchController>().userCollectedCoinFromGame(0);
      bottomText = AppLocalizations.of(context)!.catchTheCoins;
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationControllerBird.dispose();
    // _animationControllerCloud.dispose();
    _animationControllerCoin.dispose();

    scoreManager?.cancel();
    super.dispose();
  }

  RenderBox? birdBox;

  void _onGetCoin() async {
    RenderBox box1 = coinKey.currentContext!.findRenderObject() as RenderBox;

    final size1 = box1.size;
    final size2 = birdBox!.size;

    final position1 = box1.localToGlobal(globalCoinOffset);
    final position2 = birdBox!.localToGlobal(Offset.zero);

    final collide = (position1.dx < position2.dx + size2.width &&
        position1.dx + size1.width > position2.dx &&
        position1.dy < position2.dy + size2.height &&
        position1.dy + size1.height > position2.dy);

    if (collide) {
      if (_isOnScreen) {
        onHit();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.blue.withAlpha(130),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              _buildLoadingContent(),
              isStartPlaying
                  ? Positioned(
                      top: kToolbarHeight,
                      right: 20,
                      child: Text(
                        AppLocalizations.of(context)!.coins + playerScore.toString(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ))
                  : const SizedBox(),
              isStartPlaying
                  ? Positioned(
                      top: kToolbarHeight,
                      left: 20,
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.lifePoint,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          for (int k = 0; k < lifePoint; k++)
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                        ],
                      ))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  _birdLoadingAnimation() {
    _animationControllerBird =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    _animationBird = Tween<Offset>(begin: const Offset(0.1, 0.0), end: const Offset(0.0, 0.05))
        .animate(_animationControllerBird);

    _animationBird.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationControllerBird.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationControllerBird.forward();
      }
    });

    _animationControllerBird.forward();
  }

  Random coinRandom = Random();

  List<Curve> canvs = [
    Curves.fastOutSlowIn,
    Curves.easeInOutQuad,
    Curves.fastOutSlowIn,
    Curves.easeInOutQuart
  ];

  _coinAnimation() {
    ////// For coin curve style////////
    int i = coinRandom.nextInt(3);
    //////////////////////////////////

    _animationControllerCoin =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 3500));

    _animationCoin = Tween<Offset>(begin: const Offset(0, -4), end: const Offset(0.0, 25.0))
        .animate(CurvedAnimation(parent: _animationControllerCoin, curve: canvs[i]));
    _animationCoin.addListener(() {
      globalCoinOffset = Offset(_animationCoin.value.dx, _animationCoin.value.dy / 2 * 100);

      if (_isDraging == false) {
        if (!isStartPlaying) return;
        _onGetCoin();
      }
    });

    _animationCoin.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //cloudTargetList=List.generate(8, (index) => coinRandom.nextBool());
        if (!mounted) return;
        setState(() {
          if (_isOnScreen) {
            hideTheCoint = false;
          } else {
            hideTheCoint = true;
          }
        });
        if (isGameOver) {
          if (!mounted) return;
          _animationControllerCoin.stop();
          return;
        }
        _animationCoin = Tween<Offset>(begin: const Offset(0, -4), end: const Offset(0, 24))
            .animate(CurvedAnimation(parent: _animationControllerCoin, curve: canvs[i]));

        random = Random().nextInt(32).toInt() * 10;

        _animationControllerCoin.reset();
        _animationControllerCoin.forward();
      } else if (status == AnimationStatus.dismissed) {
        if (!mounted) return;
        _animationControllerCoin.forward();
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _animationControllerCoin.forward();
    });
  }

  Widget _buildcoin(
      {double? top, double? bottom, double? left, double? right, double? scale, double? imageW}) {
    return Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: SlideTransition(
          key: coinKey,
          position: _animationCoin,
          child: SizedBox(
            width: !hideTheCoint ? 50 : 0,
            height: !hideTheCoint ? 50 : 0,
            child: Image.asset(
              'assets/images/loader-aiwa.png',
              scale: scale,
              width: !hideTheCoint ? imageW : 0,
            ),
          ),
        ));
  }

  double left = 180;
  double top = 500;

  bool _isOnScreen = false;

  Widget _buildLoadingContent() {
    double deviceWidth = MediaQuery.of(context).size.width / 2;

    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white.withAlpha(130),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Visibility(
            visible: true,
            child: Stack(
              children: [
                Positioned(
                  top: top,
                  left: left,
                  child: IgnorePointer(
                    ignoring: false,
                    // (context.read<HomeController>().homeDataModel?.data?.isGameControlActive ??
                    //         false) ==
                    //     true,
                    child: Draggable<int>(
                      data: 0,
                      feedback: const SizedBox(),
                      onDragUpdate: (d) {
                        globalBirdOffset = d.globalPosition;

                        setState(() {
                          _isDraging = true;
                          top = d.globalPosition.dy - birdKey.globalPaintBounds!.size.height / 1.5;
                          left = d.globalPosition.dx - birdKey.globalPaintBounds!.size.width / 2;
                        });
                        if (isGameOver) return;
                        isStartPlaying = true;

                        _onGetCoin();
                        //      _onTouchTheCloud();
                      },
                      onDraggableCanceled: (v, o) {
                        _isOnScreen = false;
                        if (!mounted) return;
                        setState(() {
                          _isDraging = false;
                          _animationControllerBird.forward();
                        });
                      },
                      onDragStarted: () {
                        _isOnScreen = true;
                        context.read<PackSearchController>().handleTheDisountDialog(false);
                        _animationControllerBird.stop();
                      },
                      child: SlideTransition(
                        position: _animationBird,
                        child: Container(
                          key: birdKey,
                          alignment: Alignment.center,
                          child: Center(
                              child: Image.asset(
                            "assets/images/loading_bird.png",
                            scale: 4,
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
                //_buildcoin(),
                _buildcoin(top: 12.0, right: random.toDouble(), scale: 1.0, imageW: 10),
                CloudTarget(
                  top: -100.0,
                  left: deviceWidth - 25,
                  scale: 5.0,
                  onHitCloud: onHitCloud,
                  target: true,
                ),
                CloudTarget(
                  top: -400.0,
                  left: deviceWidth - 30,
                  scale: 5.0,
                  onHitCloud: onHitCloud,
                  target: false,
                ),
                CloudTarget(
                  top: -800.0,
                  left: deviceWidth - 5,
                  scale: 3.0,
                  onHitCloud: onHitCloud,
                  target: true,
                ),

                CloudTarget(
                  top: -1600.0,
                  left: deviceWidth - (deviceWidth / 1.5),
                  scale: 5.0,
                  onHitCloud: onHitCloud,
                  target: true,
                ),
                CloudTarget(
                  top: -1200.0,
                  left: deviceWidth + 25,
                  scale: 5.0,
                  onHitCloud: onHitCloud,
                  target: false,
                ),
                CloudTarget(
                  top: -140.0,
                  left: deviceWidth - (deviceWidth / 1.3),
                  scale: 3.0,
                  onHitCloud: onHitCloud,
                  target: true,
                ),
                CloudTarget(
                  top: -1600.0,
                  left: deviceWidth - 5,
                  scale: 3.0,
                  onHitCloud: onHitCloud,
                  target: true,
                ),

                isStartPlaying
                    ? Container()
                    : isGameOver
                        ? Container()
                        : (context
                                        .read<HomeController>()
                                        .homeDataModel
                                        ?.data
                                        ?.isGameControlActive ??
                                    false) ==
                                false
                            ? Container()
                            : Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  width: deviceWidth * 2,
                                  padding: const EdgeInsets.all(20),
                                  color: Colors.black12,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.catchTheCoins,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: context.read<UserController>().locale ==
                                                  const Locale('en')
                                              ? 'TV'
                                              : 'Bhaijaan'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool hideTheCoint = false;

  void onHit() async {
    if (!mounted) return;

    if (mounted) {
      setState(() {
        var r = Random();
        var n1 = r.nextInt(32);
        random = n1.toInt() * 10;
      });
    }

    HapticFeedback.selectionClick();
    playerScore += 1;
    context.read<PackSearchController>().userCollectedCoinFromGame(playerScore);

    // _animationControllerCoin.reset();
    random = Random().nextInt(32) * 10;
    _animationControllerCoin.reset();
    _animationControllerCoin.stop();

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    _animationControllerCoin.forward();
  }

  void resetTheGame() {
    isStartPlaying = false;
    playerLifePoint = 3;
    isPlayerFingerLeftTheScreen = true;
    playerScore = 0;
    scoreManager!.cancel();
  }

  void onHitCloud() {
    if (!mounted) return;
    HapticFeedback.vibrate();
    if (isGameOver) return;
    if (lifePoint > 0) {
      if (isOnCandelmode == false) {
        setState(() {
          lifePoint -= 1;
          isOnCandelmode = true;
        });
      }
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) {
          return;
        } else {
          setState(() {
            isOnCandelmode = false;
          });
        }
      });
    } else {
      gameOver();
    }
  }

  bool isGameOver = false;

  void gameOver() {
    showToast(AppLocalizations.of(context)!.hardLuck,
        backgroundColor: Colors.black26,
        context: context,
        animation: StyledToastAnimation.fadeScale,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.center,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 6),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
        textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily:
                context.read<UserController>().locale == const Locale('en') ? 'TV' : 'Bhaijaan'));
    //displayTostmessage(context, false, messeage: 'Hard Luck.. May be next time..');
    setState(() {
      bottomText = AppLocalizations.of(context)!.hardLuck;
      isGameOver = true;
      isStartPlaying = false;
      playerScore = 0;
      context.read<PackSearchController>().userCollectedCoinFromGame(0);
      context.read<PackSearchController>().handelTheloading(true);
    });
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject!.paintBounds.shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}

class CloudTarget extends StatefulWidget {
  const CloudTarget(
      {super.key,
      required this.top,
      required this.left,
      required this.scale,
      required this.onHitCloud,
      required this.target});
  final double top;
  final double left;
  final double scale;
  final VoidCallback onHitCloud;
  final bool target;

  @override
  State<CloudTarget> createState() => _CloudTargetState();
}

class _CloudTargetState extends State<CloudTarget> with SingleTickerProviderStateMixin {
  late AnimationController _animationControllerCloud;
  late Animation<Offset> _animationCloud;
  bool istarget = true;
  final _random = Random();

  _cloudLoadingAnimation() {
    _animationControllerCloud =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));

    _animationCloud = Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 25.0))
        .animate(_animationControllerCloud);

    _animationCloud.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationControllerCloud.reset();
        setState(() {
          istarget = _random.nextBool();
        });
        _animationControllerCloud.forward();
      } else if (status == AnimationStatus.dismissed) {
        _animationControllerCloud.forward();
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      _animationControllerCloud.forward();
    });
  }

  @override
  void initState() {
    istarget = widget.target;
    _cloudLoadingAnimation();

    super.initState();
  }

  @override
  void dispose() {
    _animationControllerCloud.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      child: SlideTransition(
        position: _animationCloud,
        child: DragTarget<int>(
          // onLeave: (data) {
          //   if (!istarget) return;
          //   widget.onHitCloud();
          // },
          onMove: (data) {
            if (!istarget) return;
            widget.onHitCloud();
          },
          // onWillAccept: (data){
          //
          //   if (!istarget) return false;
          //   print('will');
          //   widget.onHitCloud();
          //   return true;
          // },
          builder:
              (BuildContext context, List<Object?> candidateData, List<dynamic> rejectedData) =>
                  Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/cloud.png',
              scale: widget.scale,
              color: istarget ? Colors.grey : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
