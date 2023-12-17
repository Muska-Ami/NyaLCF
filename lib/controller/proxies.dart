import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProxiesController extends GetxController {
  var proxiesListWidgets = <DataRow>[
    DataRow(cells: <DataCell>[
      DataCell(Text("加载中喵喵喵？")),
      DataCell(Text("加载中喵喵喵？")),
      DataCell(Text("加载中喵喵喵？"))
    ])
  ].obs;

  load() {

  }
}