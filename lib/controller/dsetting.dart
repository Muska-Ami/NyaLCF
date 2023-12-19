import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DSettingController extends GetxController {
  var _frpc_version = "".obs;
  var frpc_version_widgets = <DropdownMenuItem>[].obs;
  var frpc_version_value = 0.obs;

  load() {
    frpc_version_widgets.value = <DropdownMenuItem>[
      DropdownMenuItem(
        child: Text("0.51.3"),
        value: 0,
      ),
      DropdownMenuItem(
        child: Text("0.51.0"),
        value: 1,
      ),
      DropdownMenuItem(
        child: Text("0.48.1"),
        value: 2,
      ),
    ];
  }

  //Future<FrpcList> _getList() async {
  //final ct = CancelToken();
  //await FrpcDownloadDio()(arch: 'amd64', platform: 'windows', progressCallback: () {}, cancelToken: ct);
  //}

  DropdownMenuItem _buildDMIWidget(
      {required String version, required int value}) {
    return DropdownMenuItem(
      child: Text(version),
      value: value,
    );
  }
}
