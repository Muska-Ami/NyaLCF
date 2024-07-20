import 'dart:io';

import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_inject/path_provider.dart';

bool verbose = false;

Future<UserInfoModel?> get userInfo async =>
    await File('$appSupportPath/session.json').exists()
        ? await UserInfoStorage.read()
        : null;
