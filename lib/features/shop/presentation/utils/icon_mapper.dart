import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'data':
        return Icons.signal_cellular_alt;
      case 'phone':
      case 'phone_android':
      case 'smartphone':
        return Icons.phone_android;
      case 'point_of_sale':
      case 'pos':
        return Icons.point_of_sale_rounded;
      case 'nfc':
      case 'contactless':
        return Icons.contactless_rounded;
      case 'wifi':
      case 'router':
        return Icons.wifi_rounded;
      case 'shopping_bag':
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}
