// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:nyalcf_core/network/client/common/github/frp_client.dart';
import 'package:nyalcf_core/utils/cpu_arch.dart';
import 'package:nyalcf_core/utils/frpc/arch.dart';
import 'package:nyalcf_core/utils/frpc/archive.dart';
import 'package:nyalcf_core/utils/logger.dart';

// Project imports:
import 'package:nyalcf/state.dart';
import 'package:nyalcf/templates/command.dart';

class Download implements Command {
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
        if (verbose) {
          Logger.verbose('Provide info: $_provideArch, $_providePlatform');
        }
        final systemArch = await CPUArch.getCPUArchitecture();
        if (verbose) {
          Logger.verbose('CPU arch: $systemArch');
        }

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

          await FrpClient().download(
            architecture: _selectedArch,
            platform: platform,
            version: '0.51.3-6',
            name: 'LoCyanFrp-0.51.3-6 #2024100301',
            cancelToken: _cancelToken,
            onReceiveProgress: callback,
            onFailed: onFailed,
            useMirror: false,
          );
          Logger.write('Please wait, extracting frpc...');
          await FrpcArchive.extract(
              platform: platform, arch: _selectedArch, version: '0.51.3-6');
          Logger.info('Success!');
        } else {
          Logger.error(
            'Unsupported system! If you believe this is wrong,'
            ' please provide arch manually in command.',
          );
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
    Logger.write('Progress: ${(downloaded / all * 100).toStringAsFixed(2)}%');
  }

  void onFailed(Object e) {
    Logger.error('Download failed: $e, check your internet connection.');
  }
}
