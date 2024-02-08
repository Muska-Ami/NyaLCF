import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/FrpcSettingController.dart';
import 'package:nyalcf/controllers/launcherSettingController.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';

import 'frpcSetting.dart';
import 'launcherSetting.dart';

class SettingInjector extends StatelessWidget {
  SettingInjector({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final FrpcSettingController dsf_c =
        Get.put(FrpcSettingController(context: context));
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
                LauncherSetting().widget(),
                FrpcSetting(context: context).widget()
              ],
            ),
            floatingActionButton: FloatingActionButtonX().button()));
  }
}
