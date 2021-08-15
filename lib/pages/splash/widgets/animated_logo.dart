import 'dart:ui';

import 'package:flutter/material.dart';

///
/// Created by Auro (auro@smarttersstudio.com) on 13/08/21 at 11:11 pm
///

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key? key}) : super(key: key);

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  var _logoWidth = 130.0;
  var _logoHeight = 180.0;
  double _transformProgress = 0;
  double _translateProgress = 0;
  double _centerDotRadius = 25;
  double _strokeWidth = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(),
        Stack(
          children: [
            CustomPaint(
              painter: LogoOutlinePainter(
                logoWidth: _logoWidth,
                logoHeight: _logoHeight,
                strokeWidth: _translateProgress == 1 ? 1 : _strokeWidth,
              ),
              child: Container(),
            ),
            CustomPaint(
              painter: Line1Painter(
                logoWidth: _logoWidth,
                logoHeight: _logoHeight,
                transformProgress: _transformProgress,
                translateProgress: _translateProgress,
              ),
              child: Container(),
            ),
            CustomPaint(
              painter: Line2Painter(
                logoWidth: _logoWidth,
                logoHeight: _logoHeight,
                transformProgress: _transformProgress,
                translateProgress: _translateProgress,
              ),
              child: Container(),
            ),
            CustomPaint(
              painter: Line3Painter(
                logoWidth: _logoWidth,
                logoHeight: _logoHeight,
                transformProgress: _transformProgress,
                translateProgress: _translateProgress,
              ),
              child: Container(),
            ),
            CustomPaint(
              painter: CenterDotPainter(
                logoWidth: _logoWidth,
                logoHeight: _logoHeight,
                radius: _centerDotRadius,
                transformProgress: _transformProgress,
                translateProgress: _translateProgress,
              ),
              child: Container(),
            ),
          ],
        ),
        Text(
          "$_transformProgress : $_translateProgress",
          style: TextStyle(color: Colors.white),
        ),
        Slider(
            value: _transformProgress,
            min: 0,
            max: 1,
            onChanged: (v) {
              setState(() {
                _transformProgress = v;
              });
            }),
        Slider(
            value: _translateProgress,
            min: 0,
            max: 1,
            onChanged: (v) {
              setState(() {
                _translateProgress = v;
              });
            })
      ],
    );
  }
}

class LogoOutlinePainter extends CustomPainter {
  final double logoWidth;
  final double logoHeight;
  final double strokeWidth;

  LogoOutlinePainter({
    this.logoWidth = 0,
    this.logoHeight = 0,
    this.strokeWidth = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    var path = Path();
    Offset center = Offset(size.width / 2, size.height / 2);

    /// logo outline ----------------------------------------
    double outLineX1 = center.dx - logoWidth / 2;
    double outLineY1 = center.dy - logoWidth / 2;
    double outLineX2 = center.dx + logoWidth / 2;
    double outLineY2 = center.dy - logoWidth / 2;
    double outLineX3 = center.dx + logoWidth / 2;
    double outLineY3 = center.dy - logoWidth / 2 + logoHeight * 1.6 / 3;
    double outLineX4 = center.dx;
    double outLineY4 = center.dy - logoWidth / 2 + logoHeight * 0.8;
    double outLineX5 = center.dx - logoWidth / 2;
    double outLineY5 = center.dy - logoWidth / 2 + logoHeight * 1.6 / 3;
    double outLineX6 = center.dx - logoWidth / 2;
    double outLineY6 = center.dy - logoWidth / 2;
    path.moveTo(outLineX1, outLineY1);
    path.lineTo(outLineX2, outLineY2);
    path.lineTo(outLineX3, outLineY3);
    path.lineTo(outLineX4, outLineY4);
    path.lineTo(outLineX5, outLineY5);
    path.lineTo(outLineX6, outLineY6);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LogoOutlinePainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth;
  }
}

class Line1Painter extends CustomPainter {
  final double logoWidth;
  final double logoHeight;
  final double transformProgress;
  final double translateProgress;

  Line1Painter({
    this.logoWidth = 0,
    this.logoHeight = 0,
    this.transformProgress = 0,
    this.translateProgress = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    Offset center = Offset(size.width / 2, size.height / 2);

    /// Drawing Line 1 ----------------------------------------
    double line1X1 = center.dx - logoWidth / 2 + 20;
    double line1Y1 = center.dy - logoWidth / 2 + 15;
    double line1X2 = center.dx + logoWidth / 2 - 15;
    double line1Y2 = center.dy - logoWidth / 2 + 15;
    double line1X3 = center.dx + logoWidth / 2 - 15;
    double line1Y3 = center.dy - logoWidth / 2 + 15 + logoHeight * 0.18;

    if (transformProgress == 0 && translateProgress != 0) {
      /// creating path to center (for tracing wala animation)
      path.moveTo(line1X1, line1Y1);
      path.lineTo(center.dx, center.dy);
    } else {
      /// creating line 1 path
      path.moveTo(line1X1, line1Y1);
      path.lineTo(line1X2, line1Y2);
      path.lineTo(line1X3, line1Y3);
    }

    /// trace path animation
    PathMetric pathMetric = path.computeMetrics().first;

    if (transformProgress == 0 && translateProgress != 0) {
      /// tracing path to center animation
      try {
        Path extractPath =
            pathMetric.extractPath(0.0, pathMetric.length * translateProgress);
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)!.position;
        canvas.drawCircle(offset, 3, paint..style = PaintingStyle.fill);
      } catch (e) {
        print("error $e");
      }
    } else {
      /// drawing line 1 wrt transform progress
      Path extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * transformProgress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(Line1Painter oldDelegate) {
    return oldDelegate.transformProgress != transformProgress ||
        oldDelegate.translateProgress != translateProgress;
  }
}

class Line2Painter extends CustomPainter {
  final double logoWidth;
  final double logoHeight;
  final double transformProgress;
  final double translateProgress;

  Line2Painter({
    this.logoWidth = 0,
    this.logoHeight = 0,
    this.transformProgress = 0,
    this.translateProgress = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    Offset center = Offset(size.width / 2, size.height / 2);

    /// helper coordinates ----------------------------------------
    double outLineX2 = center.dx + logoWidth / 2;
    double outLineY2 = center.dy - logoWidth / 2;
    double outLineY3 = center.dy - logoWidth / 2 + logoHeight * 1.6 / 3;
    double outLineX4 = center.dx;
    double outLineY4 = center.dy - logoWidth / 2 + logoHeight * 0.8;
    double outLineX5 = center.dx - logoWidth / 2;
    double outLineY5 = center.dy - logoWidth / 2 + logoHeight * 1.6 / 3;
    double line1X3 = center.dx + logoWidth / 2 - 15;
    double line1Y1 = center.dy - logoWidth / 2 + 15;

    /// Drawing Line 2 -------------------------------------------
    double line2X1 = outLineX2 - 15;
    double line2Y1 = outLineY2 + 15 + logoHeight * 0.28;
    double line2X2 = outLineX2 - 15;
    double line2Y2 = outLineY3 - 10;
    double line2X3 = outLineX4;
    double line2Y3 = outLineY4 - 20;
    double line2X4 = outLineX5 + 15;
    double line2Y4 = outLineY5 - 10;
    double line2X5 = outLineX5 + 15;
    double line2Y5 = line1Y1 + 15;
    double line2X6 = line1X3 - 30;
    double line2Y6 = line2Y5;
    if (transformProgress == 0 && translateProgress != 0) {
      /// creating path to center (for tracing wala animation)
      path.moveTo(line2X1, line2Y1);
      path.lineTo(center.dx, center.dy);
    } else {
      /// creating line 1 path
      path.moveTo(line2X1, line2Y1);
      path.lineTo(line2X2, line2Y2);
      path.lineTo(line2X3, line2Y3);
      path.lineTo(line2X4, line2Y4);
      path.lineTo(line2X5, line2Y5);
      path.lineTo(line2X6, line2Y6);
    }

    /// trace path animation
    PathMetric pathMetric = path.computeMetrics().first;

    if (transformProgress == 0 && translateProgress != 0) {
      /// tracing path to center animation
      try {
        Path extractPath =
            pathMetric.extractPath(0.0, pathMetric.length * translateProgress);
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)!.position;
        canvas.drawCircle(offset, 3, paint..style = PaintingStyle.fill);
      } catch (e) {
        print("error $e");
      }
    } else {
      /// drawing line 1 wrt transform progress
      Path extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * transformProgress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(Line2Painter oldDelegate) {
    return oldDelegate.transformProgress != transformProgress ||
        oldDelegate.translateProgress != translateProgress;
  }
}

class Line3Painter extends CustomPainter {
  final double logoWidth;
  final double logoHeight;
  final double transformProgress;
  final double translateProgress;

  Line3Painter(
      {this.logoWidth = 0,
      this.logoHeight = 0,
      this.transformProgress = 0,
      this.translateProgress = 0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    Offset center = Offset(size.width / 2, size.height / 2);

    /// helper coordinates ----------------------------------------
    double outLineX2 = center.dx + logoWidth / 2;
    double outLineY3 = center.dy - logoWidth / 2 + logoHeight * 1.6 / 3;
    double outLineX4 = center.dx;
    double outLineY4 = center.dy - logoWidth / 2 + logoHeight * 0.8;
    double outLineX5 = center.dx - logoWidth / 2;
    double outLineY5 = center.dy - logoWidth / 2 + logoHeight * 1.6 / 3;
    double line1Y1 = center.dy - logoWidth / 2 + 15;
    double line2X2 = outLineX2 - 15;
    double line2Y2 = outLineY3 - 10;
    double line2X3 = outLineX4;
    double line2Y3 = outLineY4 - 20;
    double line2X4 = outLineX5 + 15;
    double line2Y4 = outLineY5 - 10;
    double line2X5 = outLineX5 + 15;
    double line2Y5 = line1Y1 + 15;

    /// Drawing Line 3 -------------------------------------------
    double line3X1 = line2X2 - 15;
    double line3Y1 = line2Y2 - 10;
    double line3X2 = line2X3;
    double line3Y3 = line2Y3 - 20;
    double line3X4 = line2X4 + 15;
    double line3Y4 = line2Y4 - 10;
    double line3X5 = line2X5 + 15;
    double line3Y5 = line2Y5 + 25;

    if (transformProgress == 0 && translateProgress != 0) {
      /// creating path to center (for tracing wala animation)
      path.moveTo(line3X5, line3Y5);
      path.lineTo(center.dx, center.dy);
    } else {
      /// creating line 1 path
      path.moveTo(line3X5, line3Y5);
      path.lineTo(line3X4, line3Y4);
      path.lineTo(line3X2, line3Y3);
      path.lineTo(line3X1, line3Y1);
    }

    /// trace path animation
    PathMetric pathMetric = path.computeMetrics().first;

    if (transformProgress == 0 && translateProgress != 0) {
      /// tracing path to center animation
      try {
        Path extractPath =
            pathMetric.extractPath(0.0, pathMetric.length * translateProgress);
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)!.position;
        canvas.drawCircle(offset, 3, paint..style = PaintingStyle.fill);
      } catch (e) {
        print("error $e");
      }
    } else {
      /// drawing line 1 wrt transform progress
      Path extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * transformProgress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(Line3Painter oldDelegate) {
    return oldDelegate.transformProgress != transformProgress ||
        oldDelegate.translateProgress != translateProgress;
  }
}

class CenterDotPainter extends CustomPainter {
  final double logoWidth;
  final double logoHeight;
  final double transformProgress;
  final double translateProgress;
  final double radius;

  CenterDotPainter({
    this.logoWidth = 0,
    this.logoHeight = 0,
    this.transformProgress = 0,
    this.translateProgress = 0,
    this.radius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var paint_2 = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var paint_3 = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var paint_4 = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var paint_5 = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    /// helper coordinates -----------------------------------
    double outLineX1 = center.dx - logoWidth / 2;
    double outLineY1 = center.dy - logoWidth / 2;
    double outLineX2 = center.dx + logoWidth / 2;
    double outLineY2 = center.dy - logoWidth / 2;
    double outLineX3 = center.dx + logoWidth / 2;
    double outLineY3 = center.dy - logoWidth / 2 + logoHeight * 1.6 / 3;
    double outLineX4 = center.dx;
    double outLineY4 = center.dy - logoWidth / 2 + logoHeight * 0.8;
    double outLineX5 = center.dx - logoWidth / 2;
    double outLineY5 = center.dy - logoWidth / 2 + logoHeight * 1.6 / 3;

    /// Drawing Dot 1 ----------------------------------------
    double dot1X1 = center.dx;
    double dot1Y1 = center.dy;
    canvas.drawCircle(
        Offset(dot1X1, dot1Y1), radius, paint..style = PaintingStyle.stroke);

    double circleEdgePointX1 = center.dx;
    double circleEdgePointY1 = center.dy;
    double circleEdgePointX2 = center.dx;
    double circleEdgePointY2 = center.dy;
    double circleEdgePointX3 = center.dx;
    double circleEdgePointY3 = center.dy;
    double circleEdgePointX4 = center.dx;
    double circleEdgePointY4 = center.dy;
    double circleEdgePointX5 = center.dx;
    double circleEdgePointY5 = center.dy;

    var path_1 = Path();
    var path_2 = Path();
    var path_3 = Path();
    var path_4 = Path();
    var path_5 = Path();

    path_1.moveTo(circleEdgePointX1, circleEdgePointY1);
    path_1.lineTo(outLineX1, outLineY1);

    path_2.moveTo(circleEdgePointX2, circleEdgePointY2);
    path_2.lineTo(outLineX2, outLineY2);

    path_3.moveTo(circleEdgePointX3, circleEdgePointY3);
    path_3.lineTo(outLineX3, outLineY3);

    path_4.moveTo(circleEdgePointX4, circleEdgePointY4);
    path_4.lineTo(outLineX4, outLineY4);

    path_5.moveTo(circleEdgePointX5, circleEdgePointY5);
    path_5.lineTo(outLineX5, outLineY5);

    /// trace path animation
    PathMetric pathMetric_1 = path_1.computeMetrics().first;
    PathMetric pathMetric_2 = path_2.computeMetrics().first;
    PathMetric pathMetric_3 = path_3.computeMetrics().first;
    PathMetric pathMetric_4 = path_4.computeMetrics().first;
    PathMetric pathMetric_5 = path_5.computeMetrics().first;

    /// tracing path to center animation
    try {
      Path extractPath_1 = pathMetric_1.extractPath(
          0.0, pathMetric_1.length * translateProgress);
      Path extractPath_2 = pathMetric_2.extractPath(
          0.0, pathMetric_2.length * translateProgress);
      Path extractPath_3 = pathMetric_3.extractPath(
          0.0, pathMetric_3.length * translateProgress);
      Path extractPath_4 = pathMetric_4.extractPath(
          0.0, pathMetric_4.length * translateProgress);
      Path extractPath_5 = pathMetric_5.extractPath(
          0.0, pathMetric_5.length * translateProgress);
      var metric_1 = extractPath_1.computeMetrics().first;
      var metric_2 = extractPath_2.computeMetrics().first;
      var metric_3 = extractPath_3.computeMetrics().first;
      var metric_4 = extractPath_4.computeMetrics().first;
      var metric_5 = extractPath_5.computeMetrics().first;

      final offset_1 = metric_1.getTangentForOffset(metric_1.length)!.position;
      final offset_2 = metric_2.getTangentForOffset(metric_1.length)!.position;
      final offset_3 = metric_3.getTangentForOffset(metric_1.length)!.position;
      final offset_4 = metric_4.getTangentForOffset(metric_1.length)!.position;
      final offset_5 = metric_5.getTangentForOffset(metric_1.length)!.position;

      /// drawing line 1 to corner 1 with end point
      canvas.drawPath(extractPath_1, paint);
      canvas.drawCircle(offset_1, 3, paint..style = PaintingStyle.fill);

      /// drawing line 2 to corner 2 with end point
      canvas.drawPath(extractPath_2, paint_2);
      canvas.drawCircle(offset_2, 3, paint_2..style = PaintingStyle.fill);

      /// drawing line 3 to corner 3 with end point
      canvas.drawPath(extractPath_3, paint_3);
      canvas.drawCircle(offset_3, 3, paint_3..style = PaintingStyle.fill);

      /// drawing line 4 to corner 4 with end point
      canvas.drawPath(extractPath_4, paint_4);
      canvas.drawCircle(offset_4, 3, paint_4..style = PaintingStyle.fill);

      /// drawing line 5 to corner 5 with end point
      canvas.drawPath(extractPath_5, paint_5);
      canvas.drawCircle(offset_5, 3, paint_5..style = PaintingStyle.fill);
    } catch (e) {
      print("error $e");
    }
  }

  @override
  bool shouldRepaint(CenterDotPainter oldDelegate) {
    return oldDelegate.transformProgress != transformProgress ||
        oldDelegate.translateProgress != translateProgress;
  }
}
