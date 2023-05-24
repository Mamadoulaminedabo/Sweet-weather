import 'package:flutter/material.dart';
import 'dart:math';

class ParallaxRain extends StatefulWidget {
  ParallaxRain(
      {this.key,
        this.numberOfDrops = 25,
        this.dropFallSpeed = 2,
        this.numberOfLayers = 3,
        this.dropHeight = 20,
        this.dropWidth = 1,
        this.dropColors = const [Colors.greenAccent],
        this.trailStartFraction = 0.3,
        this.distanceBetweenLayers = 1,
        this.child,
        this.rainIsInBackground = true,
        this.trail = false})
      : assert(numberOfLayers >= 1, "The minimum number of layers is 1"),
        assert(dropColors.isNotEmpty, "The drop colors list cannot be empty"),
        assert(distanceBetweenLayers > 0,
        "The distance between layers cannot be 0, try setting the number of layers to 1 instead"),
        super(key: key);

  @override
  // ignore: overridden_fields
  final Key? key;

  final int numberOfDrops;

  final double dropFallSpeed;

  final int numberOfLayers;

  final double dropHeight;

  final double dropWidth;

  final List<Color> dropColors;

  final double trailStartFraction;

  final bool trail;

  final double distanceBetweenLayers;

  final bool rainIsInBackground;

  final Widget? child;

  @override
  State<StatefulWidget> createState() {
    return ParallaxRainState();
  }
}

class ParallaxRainState extends State<ParallaxRain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late final ParallaxRainPainter parallaxRainPainter;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    parallaxRainPainter = ParallaxRainPainter(
      numberOfDrops: widget.numberOfDrops,
      dropFallSpeed: widget.dropFallSpeed,
      numberOfLayers: widget.numberOfLayers,
      trail: widget.trail,
      dropHeight: widget.dropHeight,
      dropWidth: widget.dropWidth,
      dropColors: widget.dropColors,
      trailStartFraction: widget.trailStartFraction,
      distanceBetweenLayers: widget.distanceBetweenLayers,
      animationController: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: null,
        foregroundPainter: parallaxRainPainter,
        child: Container(
          // decoration: const BoxDecoration(
          //   // gradient: LinearGradient(
          //   //   begin: Alignment.bottomCenter,
          //   //   end: Alignment.topCenter,
          //   //   stops: [0.2, 0.9],
          //   //   colors: [
          //   //     Color(0xff955cd1),
          //   //     Color(0xff3fa2fa),
          //   //   ],
          //   // ),
          // ),
          child: widget.child,
        ),
      ),
    );
  }
}

class ParallaxRainPainter extends CustomPainter {
  final int numberOfDrops;
  List<Drop> dropList = <Drop>[];
  late Paint paintObject;
  late Size dropSize;
  final double dropFallSpeed;
  final double dropHeight;
  final double dropWidth;
  final int numberOfLayers;
  final bool trail;
  final List<Color> dropColors;
  final double trailStartFraction;
  final double distanceBetweenLayers;
  late final AnimationController animationController;
  Random random = Random();

  ParallaxRainPainter({
    required this.numberOfDrops,
    required this.dropFallSpeed,
    required this.numberOfLayers,
    required this.trail,
    required this.dropHeight,
    required this.dropWidth,
    required this.dropColors,
    required this.trailStartFraction,
    required this.distanceBetweenLayers,
    required this.animationController,
  }) : super(repaint: animationController);

  void initialize(Canvas canvas, Size size) {
    paintObject = Paint()
      ..color = dropColors[0]
      ..style = PaintingStyle.fill;
    double effectiveLayer;
    for (int i = 0; i < numberOfDrops; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      int layerNumber = random.nextInt(numberOfLayers);
      effectiveLayer = layerNumber * distanceBetweenLayers;
      dropSize = Size(dropWidth, dropHeight);
      dropList.add(
        Drop(
            drop: Offset(x, y) &
            Size(
              dropSize.width + (dropSize.width * effectiveLayer),
              dropSize.height + (dropSize.height * effectiveLayer),
            ),
            dropSpeed:
            dropFallSpeed + (dropFallSpeed * effectiveLayer),
            dropLayer: layerNumber,
            dropColor: dropColors[random.nextInt(dropColors.length)]),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (dropList.isEmpty) {
      initialize(canvas, size);
    }
    double effectiveLayer;
    for (int i = 0; i < numberOfDrops; i++) {
      if (dropList[i].drop.top + dropList[i].dropSpeed < size.height) {
        dropList[i].drop = Offset(dropList[i].drop.left,
            dropList[i].drop.top + dropList[i].dropSpeed) &
        dropList[i].drop.size;
      } else {
        int layer = random.nextInt(numberOfLayers);
        effectiveLayer = layer * distanceBetweenLayers;
        dropList[i].drop = Offset(random.nextDouble() * size.width,
            -(dropSize.height + (dropSize.height * effectiveLayer))) &
        Size(dropSize.width + (dropSize.width * effectiveLayer),
            dropSize.height + (dropSize.height * effectiveLayer));
        dropList[i].dropSpeed =
            dropFallSpeed + (dropFallSpeed * effectiveLayer);
        dropList[i].dropLayer = layer;
        dropList[i].dropColor = dropColors[random.nextInt(dropColors.length)];
      }

      paintObject.color = dropList[i]
          .dropColor
          .withOpacity(((dropList[i].dropLayer + 1) / numberOfLayers));

      canvas.drawRect(
        dropList[i].drop,
        (trail)
            ? (Paint()
          ..shader = LinearGradient(
            stops: [trailStartFraction, 1.0],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [paintObject.color, Colors.transparent],
          ).createShader(
            dropList[i].drop,
          ))
            : paintObject,
      );
    }
  }

  @override
  bool shouldRepaint(ParallaxRainPainter oldDelegate) => true;
}

class Drop {
  Rect drop;
  double dropSpeed;
  int dropLayer;
  Color dropColor;

  Drop({
    required this.drop,
    required this.dropSpeed,
    required this.dropLayer,
    required this.dropColor,
  });
}
