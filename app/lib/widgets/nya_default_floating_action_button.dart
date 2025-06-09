// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf/models/tool_dialog.dart';

// Project imports:

class NyaDefaultFloatingActionButton extends StatelessWidget {
  const NyaDefaultFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
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

}
