// Dart imports:
import 'dart:io';

// Package imports:
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

bool verbose = false;

Future<UserInfoModel?> get userInfo async =>
    await File('$appSupportPath/session.json').exists()
        ? await UserInfoStorage.read()
        : null;
