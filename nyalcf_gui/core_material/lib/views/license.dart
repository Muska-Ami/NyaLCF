// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:nyalcf_core_extend/utils/universe.dart';

// Project imports:
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/widgets/nya_scaffold.dart';

class LicenseUI extends StatelessWidget {
  const LicenseUI({super.key});

  @override
  Widget build(BuildContext context) {
    return NyaScaffold(
      name: 'License',
      appbarActions: AppbarActions(setting: false, context: context),
      // 构建首页内容区域
      body: Transform.translate(
        offset: const Offset(0, -40),
        child: LicensePage(
          applicationVersion: Universe.appVersion,
          applicationIcon: SizedBox(
            width: 48,
            child: Image.asset('icon.ico'),
          ),
        ),
      ),
    );
  }
}
