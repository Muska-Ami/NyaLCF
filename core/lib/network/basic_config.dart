// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:core/init.dart';
import 'package:core_env/env.dart';

BaseOptions baseOptions = BaseOptions(
  headers: {
    'User-Agent': 'Nya LoCyanFrp/${Init.getVersion().version}+${Init.getVersion().buildNumber}'
        ' (CORE; '
        '${Platform.operatingSystem})',
  },
);
final apiUrl = Env.universal.apiUrl ?? 'https://api.locyanfrp.cn/v3';
