import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FrpcDialogX {
  const FrpcDialogX({required this.context});

  final context;

  Widget build() {
    return SimpleDialog(
      title: const Text('请选择一个合适的架构'),
      children: <Widget>[
        // DropdownMenu(dropdownMenuEntries: ),
      ],
    );
  }
}
