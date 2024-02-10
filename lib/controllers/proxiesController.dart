import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/userController.dart';
import 'package:nyalcf/storages/configurations/ProxiesConfigurationStorage.dart';
import 'package:nyalcf/utils/network/dio/proxies/configuration.dart';
import 'package:nyalcf/utils/network/dio/proxies/get.dart';
import 'package:nyalcf/storages/configurations/FrpcConfigurationStorage.dart';
import 'package:nyalcf/models/ProxyInfoModel.dart';
import 'package:nyalcf/ui/models/FrpcConfigurationEditorDialog.dart';
import 'package:nyalcf/utils/Logger.dart';
import 'package:nyalcf/utils/frpc/ProcessManager.dart';

import 'frpcController.dart';

/**
 * 代理 GetX 状态控制器
 */
class ProxiesController extends GetxController {
  ProxiesController({required this.context});

  final context;
  final fcs = FrpcConfigurationStorage();

  final FrpcController f_c = Get.find();
  final UserController c = Get.find();

  var proxiesListWidgets = <DataRow>[
    DataRow(cells: <DataCell>[
      DataCell(SizedBox(
        height: 22.0,
        width: 22.0,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      )),
      DataCell(Text('-')),
      DataCell(Text('-')),
      DataCell(Text('-')),
      DataCell(Text('-')),
      DataCell(Text('-')),
      DataCell(Text('-')),
    ])
  ].obs;

  /**
   * 加载代理列表
   */
  load(username, token) async {
    var proxies = await ProxiesGetDio().get(username, token);
    if (proxies is List<ProxyInfoModel>) {
      proxiesListWidgets.value = <DataRow>[];
      proxies.forEach(
        (element) async => proxiesListWidgets.add(
          DataRow(
            cells: <DataCell>[
              DataCell(
                Container(
                  width: 150.0,
                  height: 30.0,
                  child: SelectableText(element.proxy_name),
                ),
              ),
              DataCell(SelectableText(element.id.toString())),
              DataCell(SelectableText(element.node.toString())),
              DataCell(SelectableText(element.proxy_type)),
              DataCell(SelectableText(element.local_ip)),
              DataCell(
                SelectableText(
                    '${element.local_port} -> ${element.remote_port}'),
              ),
              DataCell(
                Row(children: await _buildActions(element)),
              ),
            ],
          ),
        ),
      );
      proxiesListWidgets.refresh();
    } else {
      proxiesListWidgets.value = <DataRow>[
        DataRow(cells: <DataCell>[
          DataCell(Text('获取失败，请尝试刷新一下~')),
          DataCell(Text('-')),
          DataCell(Text('-')),
          DataCell(Text('-')),
          DataCell(Text('-')),
          DataCell(Text('-')),
          DataCell(Text('-')),
        ])
      ];
      Get.snackbar(
        '发生错误',
        '无法获取隧道列表信息： ${proxies}',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: Duration(milliseconds: 300),
      );
    }
  }

  _buildActions(element) async {
    final List<Widget> list = <Widget>[
      IconButton(
        icon: Icon(Icons.play_circle),
        tooltip: '启动',
        onPressed: () async {
          if (fcs.getInstalledVersions().isNotEmpty) {
            FrpcProcessManager()
                .nwprcs(frp_token: c.frp_token.value, proxy_id: element.id);
            Get.snackbar(
              '启动命令已发出',
              '请查看控制台确认是否启动成功',
              snackPosition: SnackPosition.BOTTOM,
              animationDuration: Duration(milliseconds: 300),
            );
          } else {
            Get.snackbar(
              '笨..笨蛋！',
              '你还没有安装Frpc！请先到 设置->FRPC 安装Frpc才能启动喵！',
              snackPosition: SnackPosition.BOTTOM,
              animationDuration: Duration(milliseconds: 300),
            );
          }
        },
      ),
      IconButton(
        icon: Icon(Icons.edit),
        tooltip: '编辑配置文件',
        onPressed: () async {
          /// 展示编辑框
          void showDialogX(text) {
            Get.dialog(
              FrpcConfigEditorDialogX(context: context).dialog(
                text,
                proxy_id: element.id,
              ),
              barrierDismissible: false,
            );
          }

          final fp = await ProxiesConfigurationStorage.getConfigPath(element.id);
          String text = '';

          /// 判空
          if (fp != null) {
            /// 配置已存在
            final f = File(fp);
            text = await f.readAsString();
            showDialogX(text);
          } else {
            /// 配置不存在，获取写入
            Get.dialog(FrpcConfigEditorDialogX(context: context).loading(),
                barrierDismissible: false);
            final res = await ProxiesConfigurationDio()
                .get(c.frp_token.value, element.id);
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
                animationDuration: Duration(milliseconds: 300),
              );
              Get.close(0);
            } else {
              Logger.debug(res);
              Get.snackbar(
                '获取配置文件失败',
                res.toString(),
                snackPosition: SnackPosition.BOTTOM,
                animationDuration: Duration(milliseconds: 300),
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
        icon: Icon(Icons.copy),
        tooltip: '复制绑定域名：${element.domain}',
        onPressed: () {
          Clipboard.setData(
            ClipboardData(
              text: element.domain,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('已复制'),
          ));
        },
      ));
    }

    final fcsp = await ProxiesConfigurationStorage.getConfigPath(element.id);

    if (fcsp != null)
      list.add(
        IconButton(
          icon: Icon(Icons.remove),
          tooltip: '移除自定义配置文件',
          onPressed: () async {
            File(fcsp).delete();
            reload(c.user, c.token);
          },
        ),
      );

    return list;
  }

  /**
   * 重新加载代理列表
   */
  reload(username, token) {
    proxiesListWidgets.value = <DataRow>[
      DataRow(cells: <DataCell>[
        DataCell(SizedBox(
          height: 22.0,
          width: 22.0,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )),
        DataCell(Text('-')),
        DataCell(Text('-')),
        DataCell(Text('-')),
        DataCell(Text('-')),
        DataCell(Text('-')),
        DataCell(Text('-')),
      ])
    ];
    load(username, token);
  }
}
