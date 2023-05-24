// ignore_for_file: file_names

import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart'; // Importation pour LinearGradient
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sweet_weather/pages/rain.dart';
import 'dart:async';

import 'Loading_Page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final Color _backgroundColor = const Color.fromARGB(255, 2, 135, 235);
  final Color _shadowColor = const Color.fromARGB(255, 120, 187, 249);
  late Timer _timer;
  final Key parallaxOne = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 5.0, end: 19.0).animate(_animationController);

    // _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
    //   setState(() {
    //     _shadowColor = Color.fromARGB(
    //       255,
    //       Random().nextInt(100),
    //       135,
    //       248,
    //     );
    //   });
    // });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel(); // Annuler le Timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.2, 0.9],
            colors: [
              Color(0xff955cd1),
              Color(0xff3fa2fa),
            ],
          ),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ParallaxRain(
                key: parallaxOne,
                dropColors: const [
                  Colors.white,
                ],
                trail: true,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() =>  LoadingView());
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: _backgroundColor,
                  elevation: 10.0,
                  padding: const EdgeInsets.all(0),
                ),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: _shadowColor,
                              blurRadius: _animation.value,
                              spreadRadius: _animation.value,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: const [
                            RiveAnimation.asset('assets/rive/cloud.riv'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
