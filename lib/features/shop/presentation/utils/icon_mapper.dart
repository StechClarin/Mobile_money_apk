import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'data':
        return Icons.signal_cellular_alt_rounded;
      case 'phone':
      case 'phone_android':
      case 'smartphone':
        return Icons.phone_android_rounded;
      case 'point_of_sale':
      case 'pos':
        return Icons.point_of_sale_rounded;
      case 'nfc':
      case 'contactless':
        return Icons.contactless_rounded;
      case 'wifi':
      case 'router':
        return Icons.wifi_rounded;
      case 'laptop':
      case 'computer':
        return Icons.laptop_mac_rounded;
      case 'headphones':
      case 'audio':
        return Icons.headphones_rounded;
      case 'watch':
      case 'smartwatch':
        return Icons.watch_rounded;
      case 'videocam':
      case 'camera':
      case 'security_cam':
        return Icons.videocam_rounded;
      case 'tablet':
        return Icons.tablet_mac_rounded;
      case 'speaker':
        return Icons.speaker_group_rounded;
      case 'memory':
      case 'microchip':
        return Icons.memory_rounded;
      case 'battery':
      case 'powerbank':
        return Icons.battery_charging_full_rounded;
      case 'cable':
      case 'usb':
        return Icons.cable_rounded;
      case 'security':
      case 'shield':
        return Icons.security_rounded;
      case 'printer':
        return Icons.print_rounded;
      case 'qr_scanner':
        return Icons.qr_code_scanner_rounded;
      case 'shopping_bag':
      default:
        return Icons.devices_other_rounded;
    }
  }
}

