import 'dart:io';

import 'package:dio/dio.dart';

import 'package:nyalcf/templates/command_implement.dart';
import 'package:nyalcf_core/network/dio/frpc/download_frpc.dart';
import 'package:nyalcf_core/utils/cpu_arch.dart';
import 'package:nyalcf_core/utils/frpc/arch.dart';
import 'package:nyalcf_core/utils/frpc/archive.dart';
import 'package:nyalcf_core/utils/logger.dart';

class Download implements CommandImplement {
  List<Map<String, String>> arch = [];
  late String platform;

  String _selectedArch = '';
  String? _provideArch;
  String? _providePlatform;
  bool _provide = false;

  late CancelToken _cancelToken;

  @override
  void main(List<String> args) async {
    switch (args.length) {
      case 0:
      case 2:
        if (args.length == 2) {
          _provideArch = args[0];
          _providePlatform = args[1];
          _provide = true;
        }
        Logger.verbose('Provide info: $_provideArch, $_providePlatform');
        final systemArch = await CPUArch.getCPUArchitecture();
        Logger.verbose('CPU arch: $systemArch');

        bool supportedSystem = false;

        if (!_provide) {
          getPlatformFrpcArchList();
          for (var val in arch) {
            Logger.debug(val['arch']);
            if (val['name']!.contains(systemArch!)) {
              supportedSystem = true;
              _selectedArch = val['arch']!;
            }
          }
          Logger.info('Automatic selected arch: $_selectedArch');
        } else {
          _selectedArch = _provideArch!;
          platform = _providePlatform!;
          Logger.info('Selected: $_selectedArch $_providePlatform');
        }

        if (supportedSystem || _provide) {
          _cancelToken = CancelToken();
          Logger.info('Starting frpc download...');

          await DownloadFrpc.download(
            arch: _selectedArch,
            platform: platform,
            version: '0.51.3-4',
            releaseName: 'LoCyanFrp-0.51.3-4 #2024082401',
            progressCallback: callback,
            cancelToken: _cancelToken,
            useMirror: false,
          );
          stdout.write('\rPlease wait, extracting frpc...\n');
          await FrpcArchive.extract(
              platform: platform, arch: _selectedArch, version: '0.51.3-4');
        } else {
          Logger.error(
              'Unsupported system! If you believe this is wrong, please provide arch manually in command.');
        }
      default:
        Logger.error('No valid arguments provided.');
    }
  }

  void getPlatformFrpcArchList() {
    if (Platform.isWindows) {
      platform = 'windows';
      arch = Arch.windows;
    }
    if (Platform.isLinux) {
      platform = 'linux';
      arch = Arch.linux;
    }
    if (Platform.isMacOS) {
      platform = 'darwin';
      arch = Arch.macos;
    }
  }

  void callback(downloaded, all) {
    stdout.write('\r${' ' * 30}');
    stdout.write('\rProgress: ${(downloaded / all * 100).toStringAsFixed(2)}%');
  }
}
