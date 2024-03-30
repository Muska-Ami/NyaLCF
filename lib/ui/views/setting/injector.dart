import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/frpc_setting_controller.dart';
import 'package:nyalcf/controllers/launcher_setting_controller.dart';
import 'package:nyalcf/main.dart';
import 'package:nyalcf/ui/models/appbar_actions.dart';
import 'package:nyalcf/ui/models/floating_action_button.dart';
import 'package:nyalcf/ui/views/setting/frpc_setting.dart';
import 'package:nyalcf/ui/views/setting/launcher_setting.dart';

class SettingInjector extends StatelessWidget {
  const SettingInjector({super.key});

  @override
  Widget build(BuildContext context) {
    final FrpcSettingController fsctr =
        Get.put(FrpcSettingController(context: context));
    final DSettingLauncherController dslctr =
        Get.put(DSettingLauncherController());
    fsctr.load();
    dslctr.load();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('$title - 设置',
                  style: TextStyle(color: Colors.white)),
              actions:
                  AppbarActionsX(context: context, setting: false).actions(),
              bottom: const TabBar(
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
