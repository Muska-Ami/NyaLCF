// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/frpc_setting_controller.dart';
import 'package:nyalcf_ui/controllers/launcher_setting_controller.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/views/setting/frpc_setting.dart';
import 'package:nyalcf_ui/views/setting/launcher_setting.dart';
import 'package:nyalcf_ui/widgets/nya_scaffold.dart';

class SettingInjectorUI extends StatelessWidget {
  const SettingInjectorUI({super.key});

  @override
  Widget build(BuildContext context) {
    final FrpcSettingController fsctr =
        Get.put(FrpcSettingController(context: context));
    final LauncherSettingLauncherController dslCtr =
        Get.put(LauncherSettingLauncherController());
    fsctr.load();
    dslCtr.load();

    return DefaultTabController(
      length: 2,
      child: NyaScaffold(
        name: '设置',
        appbarActions: AppbarActions(context: context, setting: false),
        appbarBottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.launch),
                child: Text(
                  '启动器',
                ),
              ),
              Tab(
                icon: Icon(Icons.support),
                child: Text(
                  'FRPC',
                ),
              )
            ],
          ),
        body: TabBarView(
          children: <Widget>[
            LauncherSetting(context: context).widget(),
            FrpcSetting(context: context).widget()
          ],
        ),
      ),
    );
  }
}
