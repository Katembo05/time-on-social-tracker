import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class SocialMediaIcon extends StatelessWidget {
  final String appName;
  final double size;
  final Color? color;

  const SocialMediaIcon({
    Key? key,
    required this.appName,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  IconData _getIconData() {
    switch (appName.toLowerCase()) {
      case 'instagram':
        return FontAwesome.instagram;
      case 'tiktok':
        return FontAwesome5Brands.tiktok;
      case 'facebook':
        return FontAwesome.facebook;
      case 'whatsapp':
        return FontAwesome.whatsapp;
      case 'twitter':
      case 'x':
        return FontAwesome.twitter;
      case 'youtube':
        return FontAwesome.youtube;
      case 'snapchat':
        return FontAwesome.snapchat;
      case 'linkedin':
        return FontAwesome.linkedin;
      default:
        return FontAwesome.globe; // Default icon for unknown apps
    }
  }

  Color _getIconColor() {
    if (color != null) return color!;
    
    switch (appName.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'twitter':
      case 'x':
        return const Color(0xFF1DA1F2);
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'snapchat':
        return const Color(0xFFFFFC00);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconData(),
      size: size,
      color: _getIconColor(),
    );
  }
} 