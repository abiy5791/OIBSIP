import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundComponents extends StatelessWidget {
  const BackgroundComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment(1, -1),
          child: Container(
            width: 200,
            height: 200,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
          ),
        ),
        Align(
          alignment: Alignment(1, 1),
          child: Container(
            width: 200,
            height: 200,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          ),
        ),
        Align(
          alignment: Alignment(-3, 0),
          child: Container(
            width: 320,
            height: 320,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
