import 'package:flutter/material.dart';
import 'app_animations.dart';
import 'app_theme.dart';

class AppTransitions {
  /// Standardized Dialog with Scale + Fade entrance
  static Future<T?> showAppDialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'AppDialog',
      barrierColor: Colors.black54,
      transitionDuration: AppAnimations.normal,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: AppAnimations.entranceCurve),
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Standardized Bottom Sheet with enhanced curve
  static Future<T?> showAppBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.cardRadius)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: AppAnimations.slow,
      )..forward(), // Note: Standard bottom sheet handles its own controller, 
                     // but we specify duration/curve where possible or use custom wrapper if needed.
      builder: (context) => child,
    );
  }
}
