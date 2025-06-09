// Flutter imports:
import 'package:flutter/material.dart';
import 'package:nyalcf/global_state.dart';
import 'package:nyalcf/models/appbar_actions.dart';

// Package imports:
import 'package:nyalcf/widgets/after_layout.dart';

// Project imports:
import 'nya_default_floating_action_button.dart';

class NyaScaffold extends StatelessWidget {
  NyaScaffold({
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
        title: Text('${GlobalState.title} - $name'),
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
