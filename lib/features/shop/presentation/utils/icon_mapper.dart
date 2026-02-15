import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'data':
        return Icons.signal_cellular_alt;
      case 'phone':
      case 'airtime':
        return Icons.phone_android;
      case 'fiber':
      case 'home':
        return Icons.router;
      case 'shopping_bag':
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}
