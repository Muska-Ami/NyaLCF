// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:nyalcf_core_extend/utils/widget/after_layout.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/widgets/nya_default_floating_action_button.dart';

class NyaScaffold extends StatelessWidget {
  const NyaScaffold({
    super.key,
    required this.name,
    this.appbarActions,
    this.appbarBottom,
    this.appbarAutoImplyLeading = true,
    this.body,
    this.drawer,
    this.floatingActionButton = const NyaDefaultFloatingActionButton(),
    this.afterLayout,
  });

  final String name;
  final AppbarActions? appbarActions;
  final PreferredSizeWidget? appbarBottom;
  final Widget? body;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final AfterLayoutCallback? afterLayout;

  final bool appbarAutoImplyLeading;

  @override
  Widget build(BuildContext context) {
    return afterLayout != null
        ? AfterLayout(
            callback: afterLayout!,
            child: _scaffold(context),
          )
        : _scaffold(context);
  }

  Widget _scaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title - $name'),
        actions: appbarActions != null
            ? appbarActions!.actions()
            : AppbarActions().actions(),
        iconTheme: Theme.of(context).iconTheme,
        bottom: appbarBottom,
        automaticallyImplyLeading: appbarAutoImplyLeading,
      ),
      body: body,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
    );
  }
}
