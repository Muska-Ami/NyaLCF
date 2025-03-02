// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:nyalcf_env/nyalcf_env.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

BaseOptions baseOptions = BaseOptions(
  headers: {
    'User-Agent': 'Nya LoCyanFrp/$version'
        ' ($appendInfo; '
        '${Platform.operatingSystem})',
  },
);
final apiV2Url = ENV_UNIVERSAL_API_URL ?? 'https://api.locyanfrp.cn/v2';
// const apiV2Url = 'http://localhost:18080/api/v2';
const githubApiUrl = 'https://api-gh.1l1.icu';
const githubMainUrl = 'https://github.com';
