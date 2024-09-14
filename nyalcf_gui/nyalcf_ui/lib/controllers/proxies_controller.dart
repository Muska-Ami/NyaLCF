// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/proxies/proxies.dart';
import 'package:nyalcf_core/storages/configurations/autostart_proxies_storage.dart';
import 'package:nyalcf_core/storages/configurations/proxies_configuration_storage.dart';
import 'package:nyalcf_core/storages/stores/proxies_storage.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/user_controller.dart';
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

  /// 隧道状态列表
  static final proxiesStatus = <int, bool?>{};

  /// <Rx>隧道列表组件
  var proxiesWidgets = <Widget>[
    const SizedBox(
      height: 22.0,
      width: 22.0,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    ),
  ].obs;

  /// 构建隧道列表
  /// [username] 用户名
  /// [token] 登录令牌
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
                    child: Builder(builder: (BuildContext context) {
                      ValueNotifier<bool> autostartNotifier =
                          ValueNotifier(_getIfAutostart(element.id));
                      return ValueListenableBuilder<bool>(
                        valueListenable: autostartNotifier,
                        builder: (context, isAutostart, child) {
                          return Checkbox(
                            value: isAutostart,
                            onChanged: (value) async {
                              _changeAutostart(element.id, value);
                              autostartNotifier.value =
                                  value ?? false; // 更新通知器的值
                            },
                          );
                        },
                      );
                    }),
                    // Checkbox(
                    //   value: _getIfAutostart(element.id),
                    //   onChanged: (value) async {
                    //     _changeAutostart(element.id, value);
                    //   },
                    // ),
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

  /// 获取隧道是否自动启动
  /// [proxyId] 隧道 ID
  _getIfAutostart(int proxyId) {
    final list = aps.getList();
    return list.contains(proxyId);
  }

  /// 改变隧道是否自动启动
  /// [proxyId] 隧道 ID
  /// [value] 是否自动启动
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
    // load(_uCtr.user, _uCtr.token);
  }

  /// 获取速度状态
  /// [proxy] 隧道模型
  @Deprecated('Low performance')
  _getProxiesStatus(ProxyInfoModel proxy) async {
    proxiesStatus[proxy.id] = null;
    // final res =
    //     await ProxiesStatus().getProxyStatus(proxy, _uCtr.frpToken.value);
    // Logger.debug(proxiesStatus);
    // if (res.status) {
    //   switch (res.data['proxy_status']) {
    //     case 'online':
    //       proxiesStatus[proxy.id] = true;
    //       break;
    //     case 'offline':
    //       proxiesStatus[proxy.id] = false;
    //     // break;
    //     // case null:
    //     //   proxiesStatus[proxy.id] = null;
    //   }
    // } else {
    //   proxiesStatus[proxy.id] = null;
    // }
  }

  /// 获取隧道状态对应颜色
  /// [input] 隧道在线状态
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

  /// 构建操作列表
  /// [element] 隧道模型
  _buildActions(element) async {
    final List<Widget> list = <Widget>[
      IconButton(
        icon: const Icon(Icons.play_circle),
        tooltip: '启动',
        onPressed: () async {
          final execPath = await FrpcPathProvider.frpcPath();
          if (execPath != null) {
            FrpcProcessManager().newProcess(
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
          void showDialog(text, {firstEdit = false}) {
            Get.dialog(
              frpcConfigurationEditorDialog(
                context,
                text,
                proxyId: element.id,
                firstEdit: firstEdit,
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
            showDialog(text);
          } else {
            /// 配置不存在，获取写入
            if (context.mounted) {
              Get.dialog(
                frpcConfigurationEditorLoadingDialog(),
                barrierDismissible: false,
              );
            } else {
              Logger.error(
                  'Context not mounted while executing a async function!');
            }
            final res = await ProxiesConfiguration.get(
                _uCtr.frpToken.value, element.id);
            if (res is String) {
              Logger.info('Successfully get config ini');
              text = res;
              ProxiesConfigurationStorage.setConfig(element.id, res);
              Get.close(0);
              showDialog(text, firstEdit: true);
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
  /// [username] 用户名
  /// [token] 登录令牌
  /// [request] 是否重新请求
  load(username, token, {bool request = false}) async {
    loading.value = true;
    if (request) {
      final list = await ProxiesGet.get(username, token);
      if (list.status) {
        list as ProxiesResponse;
        ProxiesStorage.clear();
        ProxiesStorage.addAll(list.proxies);
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
