import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/storages/configurations/autostart_proxies_storage.dart';
import 'package:nyalcf_core/storages/configurations/proxies_configuration_storage.dart';
import 'package:nyalcf_core/storages/stores/proxies_storage.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core_ui/utils/frpc/process_manager.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/proxies/proxies.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_ui/models/frpc_configuration_editor_dialog.dart';

/// 代理 GetX 状态控制器
class ProxiesController extends GetxController {
  ProxiesController({required this.context});

  final BuildContext context;
  final aps = AutostartProxiesStorage();

  final UserController _uCtr = Get.find();

  // var proxiesListWidgets = <DataRow>[
  //   const DataRow(cells: <DataCell>[
  //     DataCell(SizedBox(
  //       height: 22.0,
  //       width: 22.0,
  //       child: CircularProgressIndicator(
  //         strokeWidth: 2,
  //       ),
  //     )),
  //     DataCell(Text('-')),
  //     DataCell(Text('-')),
  //     DataCell(Text('-')),
  //     DataCell(Text('-')),
  //     DataCell(Text('-')),
  //     DataCell(Text('-')),
  //   ])
  // ].obs;

  static final proxiesStatus = <int, bool?>{};

  var proxiesWidgets = <Widget>[
    const SizedBox(
      height: 22.0,
      width: 22.0,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    ),
  ].obs;

  /// 加载代理列表
  build(username, token) async {
    var proxies = ProxiesStorage.get();
    proxiesWidgets.value = [
      const SizedBox(
        height: 22.0,
        width: 22.0,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      )
    ];
    // List<Widget> list = [];
    proxiesWidgets.clear();
    for (var i = 0; i < proxies.length; i++) {
      final element = proxies[i];
      // proxies.forEach((element) async {
      // 新UI
      // list.add(
      proxiesWidgets.add(
        SizedBox(
          width: 380,
          height: 230,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: SizedBox(
                    height: 40.0,
                    child: SelectableText(element.proxyName),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 5.0, right: 4.0),
                        margin: const EdgeInsets.only(right: 5.0),
                        decoration: BoxDecoration(color: Get.theme.focusColor),
                        child: Text(element.proxyType.toUpperCase()),
                      ),
                      Icon(
                        Icons.circle,
                        color: _getProxyStatusColor(proxiesStatus[element.id]),
                        size: 15.0,
                      ),
                      SelectableText('ID: ${element.id.toString()}'),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SelectableText('本地IP: ${element.localIP}'),
                      SelectableText(
                          '映射端口: ${element.localPort} -> ${element.remotePort}')
                    ],
                  ),
                ),
                Row(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    child: Checkbox(
                      value: _getIfAutostart(element.id),
                      onChanged: (value) async {
                        _changeAutostart(element.id, value);
                      },
                    ),
                  ),
                  const Text('跟随程序启动'),
                ]),
                Row(children: await _buildActions(element)),
              ],
            ),
          ),
        ),
      );
      _getProxiesStatus(element);
      // });
      proxiesWidgets.refresh();
    }
    // proxiesWidgets.value = list;
    // proxiesListWidgets.refresh();
  }

  _getIfAutostart(int proxyId) {
    final list = aps.getList();
    return list.contains(proxyId);
  }

  _changeAutostart(int proxyId, bool? value) async {
    Logger.debug(value);
    if (value == false) {
      Logger.debug('Remove autostart proxy from list: $proxyId');
      aps.removeFromList(proxyId);
      aps.save();
      Logger.debug(_getIfAutostart(proxyId));
    } else {
      Logger.debug('Add autostart proxy to list: $proxyId');
      aps.appendList(proxyId);
      aps.save();
      Logger.debug(_getIfAutostart(proxyId));
    }
    load(_uCtr.user, _uCtr.token);
  }

  _getProxiesStatus(ProxyInfoModel proxy) async {
    final res =
        await ProxiesStatus().getProxyStatus(proxy, _uCtr.frpToken.value);
    Logger.debug(proxiesStatus);
    if (res.status) {
      switch (res.data['proxy_status']) {
        case 'online':
          proxiesStatus[proxy.id] = true;
          break;
        case 'offline':
          proxiesStatus[proxy.id] = false;
        // break;
        // case null:
        //   proxiesStatus[proxy.id] = null;
      }
    } else {
      proxiesStatus[proxy.id] = null;
    }
  }

  Color _getProxyStatusColor(bool? input) {
    Logger.debug(input);
    if (input == null) {
      return Colors.grey;
    } else if (input) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  _buildActions(element) async {
    final List<Widget> list = <Widget>[
      IconButton(
        icon: const Icon(Icons.play_circle),
        tooltip: '启动',
        onPressed: () async {
          final execPath = await FrpcPathProvider().frpcPath;
          if (execPath != null) {
            FrpcProcessManager().nwprcs(
              frpToken: _uCtr.frpToken.value,
              proxyId: element.id,
              frpcPath: execPath,
            );
            Get.snackbar(
              '启动命令已发出',
              '请查看控制台确认是否启动成功',
              snackPosition: SnackPosition.BOTTOM,
              animationDuration: const Duration(milliseconds: 300),
            );
          } else {
            Get.snackbar(
              '笨..笨蛋！',
              '你还没有安装Frpc！请先到 设置->FRPC 安装Frpc才能启动喵！',
              snackPosition: SnackPosition.BOTTOM,
              animationDuration: const Duration(milliseconds: 300),
            );
          }
        },
      ),
      IconButton(
        icon: const Icon(Icons.edit),
        tooltip: '编辑配置文件',
        onPressed: () async {
          /// 展示编辑框
          void showDialogX(text) {
            Get.dialog(
              FrpcConfigEditorDialogX(context: context).dialog(
                text,
                proxyId: element.id,
              ),
              barrierDismissible: false,
            );
          }

          final fp =
              await ProxiesConfigurationStorage.getConfigPath(element.id);
          String text = '';

          /// 判空
          if (fp != null) {
            /// 配置已存在
            final f = File(fp);
            text = await f.readAsString();
            showDialogX(text);
          } else {
            /// 配置不存在，获取写入
            if (context.mounted) {
              Get.dialog(
                FrpcConfigEditorDialogX(context: context).loading(),
                barrierDismissible: false,
              );
            } else {
              Logger.error(
                  'Context not mounted while executing a async function!');
            }
            final res = await ProxiesConfiguration()
                .get(_uCtr.frpToken.value, element.id);
            if (res is String) {
              Logger.info('Successfully get config ini');
              text = res;
              ProxiesConfigurationStorage.setConfig(element.id, res);
              Get.close(0);
              showDialogX(text);
            } else if (res == null) {
              Get.snackbar(
                '获取配置文件失败',
                '返回值无效',
                snackPosition: SnackPosition.BOTTOM,
                animationDuration: const Duration(milliseconds: 300),
              );
              Get.close(0);
            } else {
              Logger.debug(res);
              Get.snackbar(
                '获取配置文件失败',
                res.toString(),
                snackPosition: SnackPosition.BOTTOM,
                animationDuration: const Duration(milliseconds: 300),
              );
              Get.close(0);
            }
            // Get.snackbar('谁让你点了？', '还没写，爬去面板编辑喵喵喵！');
          }
        },
      ),
    ];

    if (element.domain != null) {
      list.add(IconButton(
        icon: const Icon(Icons.copy),
        tooltip: '复制绑定域名：${element.domain}',
        onPressed: () {
          Clipboard.setData(
            ClipboardData(
              text: element.domain,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('已复制'),
          ));
        },
      ));
    }

    final pcs = await ProxiesConfigurationStorage.getConfigPath(element.id);

    if (pcs != null) {
      list.add(
        IconButton(
          icon: const Icon(Icons.remove),
          tooltip: '移除自定义配置文件',
          onPressed: () async {
            File(pcs).delete();
            load(_uCtr.user, _uCtr.token);
          },
        ),
      );
    }

    return list;
  }

  /// 重新加载代理列表
  load(username, token, {bool request = false}) async {
    loading.value = true;
    if (request) {
      final list = await ProxiesGet().get(username, token);
      if (list.status) {
        ProxiesStorage.clear();
        ProxiesStorage.addAll(list.data['proxies_list']);
      } else {
        // 我草我之前怎么没写这个
        Get.snackbar(
          '坏！',
          '请求隧道列表失败了，再试一次或许能正常响应...',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 300),
        );
      }
    }
    // proxiesListWidgets.value = <DataRow>[
    //   const DataRow(cells: <DataCell>[
    //     DataCell(SizedBox(
    //       height: 22.0,
    //       width: 22.0,
    //       child: CircularProgressIndicator(
    //         strokeWidth: 2,
    //       ),
    //     )),
    //     DataCell(Text('-')),
    //     DataCell(Text('-')),
    //     DataCell(Text('-')),
    //     DataCell(Text('-')),
    //     DataCell(Text('-')),
    //     DataCell(Text('-')),
    //   ])
    // ];
    build(username, token);
    loading.value = false;
  }
}
