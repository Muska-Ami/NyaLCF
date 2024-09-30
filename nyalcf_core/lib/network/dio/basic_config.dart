// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

BaseOptions options = BaseOptions(
  headers: {
    'User-Agent':
        'Nya/LoCyanFrp $appendInfo host=${Platform.operatingSystem}/${Platform.operatingSystemVersion}',
  },
);
const apiV2Url = 'https://api-v2.locyanfrp.cn/api/v2';
// const apiV2Url = 'http://localhost:18080/api/v2';
const githubApiUrl = 'https://api-gh.1l1.icu';
const githubMainUrl = 'https://github.com';

BaseOptions optionsWithToken(String token) {
  Map<String, dynamic> optionsMap = {};
  optionsMap['Authorization'] = 'Bearer $token';
  return options.copyWith(headers: optionsMap);
}

// const githubMirrorsUrl = 'https://proxy-gh.1l1.icu/https://github.com';
// const locyanMirrorsFrpcFormat = 'https://mirrors.locyan.cn/github-releases/' +
//     '{owner}/{repo}/{release_name}/frp_LoCyanFrp-{version_pure}_{platform}' +
//     '_{architecture}.{suffix}';
