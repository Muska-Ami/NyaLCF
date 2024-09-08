// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:nyalcf_ui/models/tool_dialog.dart';

Builder floatingActionButton() {
  return Builder(builder: (BuildContext context) {
    return FloatingActionButton(
      // foregroundColor: Colors.white,
      onPressed: () => Get.dialog(toolDialog()),
      elevation: 7.0,
      highlightElevation: 14.0,
      mini: false,
      shape: const CircleBorder(),
      isExtended: false,
      child: const Icon(Icons.add),
    );
  });
}
