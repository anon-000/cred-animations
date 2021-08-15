import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

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
  double val = 0;
  double _translateProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(),
        Stack(
          children: [
            CustomPaint(
              painter: ShapePainter(
                logoWidth: _logoWidth,
                logoHeight: _logoHeight,
              ),
              child: Container(),
            ),
            CustomPaint(
              painter: Line1Painter(
                logoWidth: _logoWidth,
                logoHeight: _logoHeight,
                progress: val,
                translateProgress: _translateProgress,
              ),
              child: Container(),
            ),
            CustomPaint(
              painter: Line2Painter(
                logoWidth: _logoWidth,
                logoHeight: _logoHeight,
                progress: val,
                translateProgress: _translateProgress,
              ),
              child: Container(),
            ),
            CustomPaint(
              painter: Line3Painter(
                logoWidth: _logoWidth,
                logoHeight: _logoHeight,
                progress: val,
                translateProgress: _translateProgress,
              ),
              child: Container(),
            ),
          ],
        ),
        Text(
          "$val : $_translateProgress",
          style: TextStyle(color: Colors.white),
        ),
        Slider(
            value: val,
            min: 0,
            max: 1,
            onChanged: (v) {
              setState(() {
                val = v;
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

// FOR PAINTING POLYGONS
class ShapePainter extends CustomPainter {
  final double logoWidth;
  final double logoHeight;

  ShapePainter({this.logoWidth = 0, this.logoHeight = 0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
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
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Line1Painter extends CustomPainter {
  final double logoWidth;
  final double logoHeight;
  final double progress;
  final double? translateProgress;

  Line1Painter(
      {this.logoWidth = 0,
      this.logoHeight = 0,
      this.progress = 0,
      this.translateProgress});

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
    // path.moveTo(line1X1, line1Y1);
    // path.lineTo(line1X2, line1Y2);
    // path.lineTo(line1X3, line1Y3);
    if (progress == 0 && translateProgress != 0) {
      path.moveTo(line1X1, line1Y1);
      path.lineTo(center.dx, center.dy);
    } else {
      path.moveTo(line1X1, line1Y1);
      path.lineTo(line1X2, line1Y2);
      path.lineTo(line1X3, line1Y3);
    }
    // path.close();

    /// trace path animation
    PathMetric pathMetric = path.computeMetrics().first;
    print("$pathMetric");
    // Path extractPath =
    //     pathMetric.extractPath(0.0, pathMetric.length * progress);
    //print("----$extractPath");
    if (progress == 0 && translateProgress != 0) {
      try {
        Path extractPath =
            pathMetric.extractPath(0.0, pathMetric.length * translateProgress!);
        var metric = extractPath.computeMetrics().first;
        print("--- circle draw");
        final offset = metric.getTangentForOffset(metric.length)!.position;
        canvas.drawCircle(offset, 3, paint..style = PaintingStyle.fill);
      } catch (e) {
        print("error $e");
      }
    } else {
      Path extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * progress);
      canvas.drawPath(extractPath, paint);
    }
    //canvas.drawPath(extractPath, paint);
    //canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(Line1Painter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.translateProgress != translateProgress;
  }
}

class Line2Painter extends CustomPainter {
  final double logoWidth;
  final double logoHeight;
  final double progress;
  final double translateProgress;

  Line2Painter({
    this.logoWidth = 0,
    this.logoHeight = 0,
    this.progress = 0,
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

    /// helpers ----------------------------------------
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
    if (progress == 0 && translateProgress != 0) {
      path.moveTo(line2X1, line2Y1);
      path.lineTo(center.dx, center.dy);
    } else {
      path.moveTo(line2X1, line2Y1);
      path.lineTo(line2X2, line2Y2);
      path.lineTo(line2X3, line2Y3);
      path.lineTo(line2X4, line2Y4);
      path.lineTo(line2X5, line2Y5);
      path.lineTo(line2X6, line2Y6);
    }

    /// trace path animation
    PathMetric pathMetric = path.computeMetrics().first;
    if (progress == 0 && translateProgress != 0) {
      try {
        Path extractPath =
            pathMetric.extractPath(0.0, pathMetric.length * translateProgress!);
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)!.position;
        canvas.drawCircle(offset, 3, paint..style = PaintingStyle.fill);
      } catch (e) {
        print("error $e");
      }
    } else {
      Path extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * progress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(Line2Painter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.translateProgress != translateProgress;
  }
}

class Line3Painter extends CustomPainter {
  final double logoWidth;
  final double logoHeight;
  final double progress;
  final double translateProgress;

  Line3Painter(
      {this.logoWidth = 0,
      this.logoHeight = 0,
      this.progress = 0,
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

    /// helpers ----------------------------------------
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

    if (progress == 0 && translateProgress != 0) {
      path.moveTo(line3X5, line3Y5);
      path.lineTo(center.dx, center.dy);
    } else {
      path.moveTo(line3X5, line3Y5);
      path.lineTo(line3X4, line3Y4);
      path.lineTo(line3X2, line3Y3);
      path.lineTo(line3X1, line3Y1);
    }

    /// trace path animation
    PathMetric pathMetric = path.computeMetrics().first;
    if (progress == 0 && translateProgress != 0) {
      try {
        Path extractPath =
            pathMetric.extractPath(0.0, pathMetric.length * translateProgress!);
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)!.position;
        canvas.drawCircle(offset, 3, paint..style = PaintingStyle.fill);
      } catch (e) {
        print("error $e");
      }
    } else {
      Path extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * progress);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(Line3Painter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.translateProgress != translateProgress;
  }
}
