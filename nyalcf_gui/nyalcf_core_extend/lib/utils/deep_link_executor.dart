// Package imports:
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/logger.dart';

// Project imports:
import 'frpc/process_manager.dart';

class DeepLinkExecutor {
  DeepLinkExecutor({
    required this.uri,
  });

  final String uri;

  Future<List<dynamic>> execute() async {
    final content = uri.replaceFirst('locyanfrp://', '');
    final data = content.split('/');
    final frpToken = data[0], proxyId = int.parse(data[1]);
    final frpcPath = await FrpcPathProvider.frpcPath();
    if (frpcPath != null) {
      FrpcProcessManager().newProcess(
        frpToken: frpToken,
        proxyId: proxyId,
        frpcPath: frpcPath,
      );
      return [true, frpToken];
    } else {
      Logger.error(
          'Could not implement proxy fast startup, no frpc has installed!');
    }
    return [false];
  }
}
