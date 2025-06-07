// Flutter imports:
import 'package:flutter/material.dart';

class ColorUtils {
  /// 将 Color 转为 HexCode
  static String colorToHex(Color color) => color.value.toRadixString(16).padLeft(8, '0').toUpperCase();

  /// 将 HexCode 转为 Color
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
