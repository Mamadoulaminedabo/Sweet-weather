import 'package:flutter/material.dart';
import 'dart:math';

class ParallaxSnow extends StatefulWidget {
  ParallaxSnow({
    // Key? key,
    this.numberOfSnowflakes = 25,
    this.snowflakeFallSpeed = 2,
    this.numberOfLayers = 3,
    this.snowflakeSize = 10,
    this.snowflakeColors = const [Colors.white],
    this.distanceBetweenLayers = 1,
    this.child,
    this.snowIsInBackground = true, this.key,
  })  : assert(numberOfLayers >= 1, "The minimum number of layers is 1"),
        assert(
        snowflakeColors.isNotEmpty, "The snowflake colors list cannot be empty"),
        assert(
        distanceBetweenLayers > 0,
        "The distance between layers cannot be 0, try setting the number of layers to 1 instead"),
        super(key: key);

  @override
  // ignore: overridden_fields
  final Key? key;

  final int numberOfSnowflakes;
  final double snowflakeFallSpeed;
  final int numberOfLayers;
  final double snowflakeSize;
  final List<Color> snowflakeColors;
  final double distanceBetweenLayers;
  final Widget? child;
  final bool snowIsInBackground;

  @override
  State<StatefulWidget> createState() {
    return ParallaxSnowState();
  }
}

class ParallaxSnowState extends State<ParallaxSnow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final ParallaxSnowPainter parallaxSnowPainter;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    parallaxSnowPainter = ParallaxSnowPainter(
      numberOfSnowflakes: widget.numberOfSnowflakes,
      snowflakeFallSpeed: widget.snowflakeFallSpeed,
      numberOfLayers: widget.numberOfLayers,
      snowflakeSize: widget.snowflakeSize,
      snowflakeColors: widget.snowflakeColors,
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
        painter: widget.snowIsInBackground ? parallaxSnowPainter : null,
        foregroundPainter: !widget.snowIsInBackground ? parallaxSnowPainter : null,
        child: Container(
          child: widget.child,
        ),
      ),
    );
  }
}

class ParallaxSnowPainter extends CustomPainter {
  final int numberOfSnowflakes;
  List<Snowflake> snowflakeList = <Snowflake>[];
  late Paint paintObject;
  final double snowflakeFallSpeed;
  final double snowflakeSize;
  final int numberOfLayers;
  final List<Color> snowflakeColors;
  final double distanceBetweenLayers;
  late final AnimationController animationController;
  Random random = Random();

  ParallaxSnowPainter({
    required this.numberOfSnowflakes,
    required this.snowflakeFallSpeed,
    required this.numberOfLayers,
    required this.snowflakeSize,
    required this.snowflakeColors,
    required this.distanceBetweenLayers,
    required this.animationController,
  }) : super(repaint: animationController);

  void initialize(Canvas canvas, Size size) {
    paintObject = Paint()
      ..style = PaintingStyle.fill;
    double effectiveLayer;
    for (int i = 0; i < numberOfSnowflakes; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      int layerNumber = random.nextInt(numberOfLayers);
      effectiveLayer = layerNumber * distanceBetweenLayers;
      snowflakeList.add(
        Snowflake(
          position: Offset(x, y),
          size: snowflakeSize + (snowflakeSize * effectiveLayer),
          fallSpeed: snowflakeFallSpeed + (snowflakeFallSpeed * effectiveLayer),
          layer: layerNumber,
          color: snowflakeColors[random.nextInt(snowflakeColors.length)],
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (snowflakeList.isEmpty) {
      initialize(canvas, size);
    }
    double effectiveLayer;
    for (int i = 0; i < numberOfSnowflakes; i++) {
      if (snowflakeList[i].position.dy + snowflakeList[i].fallSpeed < size.height) {
        snowflakeList[i].position = Offset(snowflakeList[i].position.dx,
            snowflakeList[i].position.dy + snowflakeList[i].fallSpeed);
      } else {
        int layer = random.nextInt(numberOfLayers);
        effectiveLayer = layer * distanceBetweenLayers;
        snowflakeList[i].position = Offset(
          random.nextDouble() * size.width,
          -(snowflakeList[i].size + (snowflakeList[i].size * effectiveLayer)),
        );
        snowflakeList[i].fallSpeed =
            snowflakeFallSpeed + (snowflakeFallSpeed * effectiveLayer);
        snowflakeList[i].layer = layer;
        snowflakeList[i].color = snowflakeColors[random.nextInt(snowflakeColors.length)];
      }

      paintObject.color = snowflakeList[i]
          .color
          .withOpacity(((snowflakeList[i].layer + 1) / numberOfLayers));

      canvas.drawCircle(
        snowflakeList[i].position,
        snowflakeList[i].size / 2,
        paintObject,
      );
    }
  }

  @override
  bool shouldRepaint(ParallaxSnowPainter oldDelegate) => true;
}

class Snowflake {
  Offset position;
  double size;
  double fallSpeed;
  int layer;
  Color color;

  Snowflake({
    required this.position,
    required this.size,
    required this.fallSpeed,
    required this.layer,
    required this.color,
  });
}
