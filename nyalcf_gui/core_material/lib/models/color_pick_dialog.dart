// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

Widget colorPickDialog(
  BuildContext context, {
    required Color pickerColor,
  Function(Color)? onPrimaryChanged,
  required Function(Color) onColorChanged,
}) {
  return AlertDialog(
    title: const Text('选取一个颜色'),
    content: SizedBox(
      width: 400.0,
      child: Container(
        margin: EdgeInsets.only(left: 25, right: 20),
        child: MaterialPicker(
          pickerColor: pickerColor,
          portraitOnly: true,
          enableLabel: true,
          onPrimaryChanged: onPrimaryChanged,
          onColorChanged: onColorChanged,
        ),
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () => Get.close(0),
        child: Text('完成'),
      ),
    ],
  );
}
