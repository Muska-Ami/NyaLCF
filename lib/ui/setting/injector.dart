import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dsettingfrpc.dart';
import 'package:nyalcf/controller/dsettinglauncher.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';

import 'frpcmanager.dart';
import 'launcher.dart';

class SettingInjector extends StatelessWidget {
  SettingInjector({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final DSettingFrpcController dsf_c =
        Get.put(DSettingFrpcController(context: context));
    final DSettingLauncherController dsc_c =
        Get.put(DSettingLauncherController());
    dsf_c.load();
    dsc_c.load();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('$title - 设置',
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Get.theme.primaryColor,
              actions:
                  AppbarActionsX(context: context, setting: false).actions(),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.launch, color: Colors.white),
                    child: Text(
                      '启动器',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Tab(
                    icon: Icon(Icons.support, color: Colors.white),
                    child: Text(
                      'FRPC',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                LauncherSX().widget(),
                FrpcManagerSX().widget()
              ],
            ),
            floatingActionButton: FloatingActionButtonX().button()));
  }
}
