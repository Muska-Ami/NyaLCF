import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/dio/proxies/get.dart';
import 'package:nyalcf/model/ProxyInfo.dart';

import 'frpc.dart';

class ProxiesController extends GetxController {
  final FrpcController f_c = Get.find();
  var proxiesListWidgets = <DataRow>[
    DataRow(cells: <DataCell>[
      DataCell(Text('加载中喵喵喵？')),
      DataCell(Text('-')),
      DataCell(Text('-')),
      DataCell(Text('-')),
      DataCell(Text('-')),
      DataCell(Text('-')),
      DataCell(Text('-')),
    ])
  ].obs;

  load(username, token) async {
    var proxies = await ProxiesGetDio().get(username, token);
    if (proxies is List<ProxyInfo>) {
      List<DataRow> widgets = <DataRow>[];
      proxies.forEach((element) => widgets.add(DataRow(cells: <DataCell>[
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
              SelectableText('${element.local_port} -> ${element.remote_port}'),
            ),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.play_circle),
                    onPressed: () {
                      Process.run('cmd.exe', ['start', 'cmd.exe']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Get.snackbar('谁让你点了？', '还没写，爬去面板编辑喵喵喵！');
                    },
                  ),
                ],
              ),
            ),
          ])));
      proxiesListWidgets.value = widgets;
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
}
