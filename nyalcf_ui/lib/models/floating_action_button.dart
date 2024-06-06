import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_ui/models/tool_dialog.dart';

class FloatingActionButtonX {
  Builder button() {
    return Builder(builder: (BuildContext context) {
      return FloatingActionButton(
        // foregroundColor: Colors.white,
        onPressed: () => Get.dialog(ToolDialogX(context: context).build()),
        elevation: 7.0,
        highlightElevation: 14.0,
        mini: false,
        shape: const CircleBorder(),
        isExtended: false,
        child: const Icon(Icons.add),
      );
    });
  }
}
