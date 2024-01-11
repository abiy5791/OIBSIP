// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  final double size;
  const ClockView({super.key, required this.size});

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startContinuousUpdate();
  }

  void startContinuousUpdate() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer in the dispose() method
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 2,
      child: Container(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    var CenterX = size.width / 2;
    var CenterY = size.height / 2;
    var Center = Offset(CenterX, CenterY);

    var radius = min(CenterX, CenterY);

    var fillCircle = Paint()..color = Colors.transparent;

    var circleOutline = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 65;

    var centerFill = Paint()..color = Color(0xFFEAECFF);

    var second = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 70;

    var minute = Paint()
      ..shader = RadialGradient(colors: [Color(0xFF088395), Color(0xFF191717)])
          .createShader(Rect.fromCircle(center: Center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 45;
    var hour = Paint()
      ..shader = RadialGradient(colors: [Color(0xFF39B5E0), Color(0xFF3D1766)])
          .createShader(Rect.fromCircle(center: Center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 30;
    canvas.drawCircle(Center, radius * 0.75, fillCircle);
    canvas.drawCircle(Center, radius * 0.75, circleOutline);
    var hourX = CenterX +
        radius *
            0.4 *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourY = CenterX +
        radius *
            0.4 *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(Center, Offset(hourX, hourY), hour);

    var minuteX = CenterX + radius * 0.6 * cos(dateTime.minute * 6 * pi / 180);
    var minuteY = CenterX + radius * 0.6 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(Center, Offset(minuteX, minuteY), minute);

    var secondX = CenterX + radius * 0.6 * cos(dateTime.second * 6 * pi / 180);
    var secondY = CenterX + radius * 0.6 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(Center, Offset(secondX, secondY), second);

    canvas.drawCircle(Center, radius * 0.10, centerFill);

    var outerCircleRadius = radius;
    var innerCircleRadius = radius * 0.9;
    for (double i = 0; i < 360; i += 12) {
      var x1 = CenterX + outerCircleRadius * cos(i * pi / 180);
      var y1 = CenterX + outerCircleRadius * sin(i * pi / 180);

      var x2 = CenterX + innerCircleRadius * cos(i * pi / 180);
      var y2 = CenterX + innerCircleRadius * sin(i * pi / 180);

      var dashs = Paint()..color = Color(0xFF190482);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashs);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
