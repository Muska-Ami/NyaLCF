import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

BaseOptions options = BaseOptions(
  headers: {
    'User-Agent':
        'Nya/LoCyanFrp $appendInfo host=${Platform.operatingSystem}/${Platform.operatingSystemVersion}',
  },
);
const apiV1Url = 'https://api.locyanfrp.cn';
const apiV2Url = 'https://api-v2.locyanfrp.cn/api/v2';
const frpcConfigUrl = 'https://lcf-frps-api.locyanfrp.cn/api';
const githubApiUrl = 'https://api-gh.1l1.icu';
const githubMainUrl = 'https://github.com';

// const githubMirrorsUrl = 'https://proxy-gh.1l1.icu/https://github.com';
// const locyanMirrorsFrpcFormat = 'https://mirrors.locyan.cn/github-releases/' +
//     '{owner}/{repo}/{release_name}/frp_LoCyanFrp-{version_pure}_{platform}' +
//     '_{architecture}.{suffix}';
