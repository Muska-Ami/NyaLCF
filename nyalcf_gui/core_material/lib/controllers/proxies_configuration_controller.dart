// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/proxies_configuration_storage.dart';

// Project imports:
import 'package:nyalcf_ui/models/proxy_configuration_options_dialog.dart';

class ProxiesConfigurationController extends GetxController {
  List<int>? proxies;

  var configListWidget = ListView().obs;

  load() async {
    proxies = await ProxiesConfigurationStorage.getConfigList();
    _build();
  }

  _build() {
    final noConfig = ListView(
      children: <Widget>[
        Center(
            child: Container(
          margin: const EdgeInsets.all(20),
          child: const Text('没有已保存的配置文件呐~'),
        )),
      ],
    );
    if (proxies != null) {
      configListWidget.value = proxies!.isNotEmpty
          ? ListView.builder(
              itemCount: proxies!.length,
              itemBuilder: (BuildContext context, int index) {
                final proxy = proxies![index];

                // exist方法是异步的，用 FutureBuilder 获取返回
                return FutureBuilder(
                    future: ProxiesConfigurationStorage.getConfigPath(proxy),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return InkWell(
                          onTap: () async {
                            Get.dialog(proxyConfigurationOptionsDialog(
                                context, proxy));
                          },
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                const Icon(Icons.fiber_manual_record),
                                Text('ID: $proxy'),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    });
              },
            )
          : noConfig;
    } else {
      configListWidget.value = noConfig;
    }
  }
}
