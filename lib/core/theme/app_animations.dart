import 'package:flutter/material.dart';

class AppAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Curves
  static const Curve standardCurve = Curves.easeInOut;
  static const Curve entranceCurve = Curves.easeOutQuart;
  static const Curve exitCurve = Curves.easeInQuart;
  static const Curve fluidCurve = Curves.fastOutSlowIn;
  static const Curve sharpCurve = Curves.easeInCubic;

  // Spacing/Offsets for transitions
  static const Offset slideUpStart = Offset(0.0, 0.05);
  static const Offset slideDownStart = Offset(0.0, -0.05);
}
