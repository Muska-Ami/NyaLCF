// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/client/api/proxy/all.dart' as api_proxy_all;
import 'package:nyalcf_core/network/client/api/proxy/config.dart' as api_proxy_config;
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/storages/configurations/autostart_proxies_storage.dart';
import 'package:nyalcf_core/storages/configurations/proxies_configuration_storage.dart';
import 'package:nyalcf_core/storages/stores/proxies_storage.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_info_prefs.dart';
import 'package:nyalcf_core_extend/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/frpc_configuration_editor_dialog.dart';
import 'package:nyalcf_ui/widgets/nya_loading_circle.dart';

/// 代理 GetX 状态控制器
class ProxiesController extends GetxController {
  ProxiesController({required this.context});

  final BuildContext context;
  final aps = AutostartProxiesStorage();

  final UserController _uCtr = Get.find();

  /// 隧道状态列表
  static final proxiesStatus = <int, bool?>{};

  /// <Rx>隧道列表组件
  var proxiesWidgets = <Widget>[
    const NyaLoadingCircle(height: 22.0, width: 22.0),
  ].obs;

  /// 构建隧道列表
  build() async {
    var proxies = ProxiesStorage.getAll();
    proxiesWidgets.value = [
      const NyaLoadingCircle(height: 22.0, width: 22.0),
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
                    child: SelectableText(element.name),
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
            final ApiClient api = ApiClient(accessToken: await TokenInfoPrefs.getAccessToken());
            final UserInfoModel userInfo = await UserInfoPrefs.getInfo();
            final rs = await api.get(api_proxy_config.GetConfig(userId: userInfo.id, proxyId: element.id));
            if (rs == null) {
              Get.snackbar(
                '获取配置文件失败',
                '请求失败',
                snackPosition: SnackPosition.BOTTOM,
                animationDuration: const Duration(milliseconds: 300),
              );
              Get.close(0);
              return;
            }
            if (rs.statusCode == 200) {
              Logger.debug('Successfully get config ini');
              text = rs.data['data']['config'];
              ProxiesConfigurationStorage.setConfig(element.id, text);
              Get.close(0);
              showDialog(text, firstEdit: true);
            } else {
              Get.snackbar(
                '获取配置文件失败',
                rs.data['data']['message'],
                snackPosition: SnackPosition.BOTTOM,
                animationDuration: const Duration(milliseconds: 300),
              );
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

    final pcsPath = await ProxiesConfigurationStorage.getConfigPath(element.id);

    if (pcsPath != null) {
      list.add(
        IconButton(
          icon: const Icon(Icons.remove),
          tooltip: '移除自定义配置文件',
          onPressed: () async {
            File(pcsPath).delete();
            load();
          },
        ),
      );
    }

    return list;
  }

  /// 重新加载代理列表
  /// [request] 是否重新请求
  load({bool request = false}) async {
    loading.value = true;
    final UserInfoModel userInfo = await UserInfoPrefs.getInfo();
    if (request) {
      final ApiClient api = ApiClient(accessToken: await TokenInfoPrefs.getAccessToken());
      final rs = await api.get(api_proxy_all.GetAll(userId: userInfo.id));
      if (rs == null) {
        Get.snackbar(
          '坏！',
          '请求隧道列表失败了，再试一次或许能正常响应...',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 300),
        );
        return;
      }
      if (rs.statusCode == 200) {
        final List<dynamic> list = rs.data['data']['list'];

        final List<ProxyInfoModel> proxies = [];
        for (Map<String, dynamic> proxy in list) {
          final model = ProxyInfoModel(
            id: proxy['id'],
            name: proxy['proxy_name'],
            node: proxy['node_id'],
            localIP: proxy['local_ip'],
            localPort: proxy['local_port'],
            remotePort: proxy['remote_port'],
            proxyType: proxy['proxy_type'],
            useEncryption: proxy['use_encryption'],
            useCompression: proxy['use_compression'],
            domain: proxy['domain'],
            secretKey: proxy['secret_key'],
            status: proxy['status'],
          );
          proxies.add(model);
        }

        ProxiesStorage.clear();
        ProxiesStorage.addAll(proxies);
      } else {
        Get.snackbar(
          '坏！',
          '请求隧道列表失败了，后端返回: ${rs.data['message']}.',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 300),
        );
      }
    }
    build();
    loading.value = false;
  }
}
