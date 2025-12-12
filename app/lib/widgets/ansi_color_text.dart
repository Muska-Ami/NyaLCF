import 'package:flutter/material.dart';

// 定义一个 ANSI 颜色映射表
// 注意：终端颜色和标准 RGB 颜色可能略有不同，这里是近似映射
const Map<String, Color> _ansiColorMap = {
  // --- 标准 8 色 (Standard 8 Colors) ---
  // 前景色 (Foreground - 30-37)
  '30': Colors.black,            // Black
  '31': Colors.red,              // Red
  '32': Colors.green,            // Green
  '33': Colors.yellow,           // Yellow
  '34': Colors.blue,             // Blue
  '35': Colors.deepPurple,       // Magenta
  '36': Colors.cyan,             // Cyan
  '37': Colors.white,            // White

  // 背景色 (Background - 40-47)
  '40': Colors.black,
  '41': Colors.red,
  '42': Colors.green,
  '43': Colors.yellow,
  '44': Colors.blue,
  '45': Colors.deepPurple,       // Magenta
  '46': Colors.cyan,
  '47': Colors.white,

  // --- 亮 8 色 (Bright/High-Intensity Colors) ---
  // 这些颜色通常是标准颜色的更亮版本，有时也被称作“加强色”
  // 前景色 (Foreground - 90-97)
  '90': Colors.grey,             // Bright Black
  '91': Colors.redAccent,        // Bright Red
  '92': Colors.lightGreenAccent, // Bright Green
  '93': Colors.amber,            // Bright Yellow
  '94': Colors.lightBlueAccent,  // Bright Blue
  '95': Colors.pinkAccent,       // Bright Magenta
  '96': Colors.lightBlue,        // Bright Cyan
  '97': Colors.white,            // Bright White

  // 背景色 (Background - 100-107)
  '100': Colors.grey,
  '101': Colors.redAccent,
  '102': Colors.lightGreenAccent,
  '103': Colors.amber,
  '104': Colors.lightBlueAccent,
  '105': Colors.pinkAccent,
  '106': Colors.lightBlue,
  '107': Colors.white,
};

// 正则表达式来匹配 ANSI 转义码
final _ansiRegex = RegExp(r'\x1B\[([0-9;]*)m');

class AnsiColorText extends StatelessWidget {
  final String text;
  final TextStyle? baseTextStyle;
  final ScrollController? scrollController; // 可选的滚动控制器

  const AnsiColorText({
    super.key,
    required this.text,
    this.baseTextStyle,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // 解析带 ANSI 颜色的文本并生成 TextSpan
    final TextSpan richText = _parseAnsiColoredText(text, baseTextStyle);

    return SingleChildScrollView(
      controller: scrollController,
      child: Text.rich(
        richText,
        style: baseTextStyle ?? Theme.of(context).textTheme.bodyMedium, // 确保有默认样式
      ),
    );
  }

  // 核心解析逻辑
  TextSpan _parseAnsiColoredText(String text, TextStyle? baseStyle) {
    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    // 当前的样式状态
    TextStyle currentStyle = baseStyle ?? const TextStyle(color: Colors.white, fontFamily: 'monospace');
    Color? currentFgColor = (baseStyle?.color != null && baseStyle?.color != Colors.white) ? baseStyle?.color : null;
    Color? currentBgColor = baseStyle?.backgroundColor;
    FontWeight currentFontWeight = baseStyle?.fontWeight ?? FontWeight.normal;
    bool currentItalic = baseStyle?.fontStyle == FontStyle.italic;
    bool currentUnderline = baseStyle?.decoration == TextDecoration.underline;

    for (RegExpMatch match in _ansiRegex.allMatches(text)) {
      // 1. 添加当前匹配前的文本部分
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: currentStyle,
        ));
      }

      // 2. 解析 ANSI 码并更新样式
      final String codesString = match.group(1) ?? '';
      final List<String> codes = codesString.split(';');

      for (String code in codes) {
        switch (code) {
          case '0': // Reset
            currentFgColor = null;
            currentBgColor = null;
            currentFontWeight = FontWeight.normal;
            currentItalic = false;
            currentUnderline = false;
            currentStyle = baseStyle ?? const TextStyle(color: Colors.white, fontFamily: 'monospace');
            break;
          case '1': // Bold
            currentFontWeight = FontWeight.bold;
            break;
          case '3': // Italic (less common, but some terminals support)
            currentItalic = true;
            break;
          case '4': // Underline
            currentUnderline = true;
            break;
          default:
            // Check for foreground color
            if (_ansiColorMap.containsKey(code)) {
              if (int.tryParse(code)! >= 30 && int.tryParse(code)! <= 37 || int.tryParse(code)! >= 90 && int.tryParse(code)! <= 97) {
                currentFgColor = _ansiColorMap[code];
              }
            }
            // Check for background color
            if (_ansiColorMap.containsKey(code)) {
              if (int.tryParse(code)! >= 40 && int.tryParse(code)! <= 47 || int.tryParse(code)! >= 100 && int.tryParse(code)! <= 107) {
                 currentBgColor = _ansiColorMap[code];
              }
            }
            // Add more ANSI codes here if needed (e.g., bright colors, specific RGB codes if supported)
            break;
        }
      }

      // 根据更新后的状态创建新的 TextStyle
      currentStyle = (baseStyle ?? const TextStyle(fontFamily: 'monospace')).copyWith(
        color: currentFgColor,
        backgroundColor: currentBgColor,
        fontWeight: currentFontWeight,
        fontStyle: currentItalic ? FontStyle.italic : FontStyle.normal,
        decoration: currentUnderline ? TextDecoration.underline : TextDecoration.none,
      );

      lastMatchEnd = match.end; // 更新下一个匹配的起始位置
    }

    // 3. 添加最后一个匹配后的剩余文本部分
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: currentStyle, // 确保最后的文本也应用了正确的样式
      ));
    }

    return TextSpan(children: spans);
  }
}