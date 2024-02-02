import 'package:flutter/services.dart';

class ProtocolActivation {
  static Future<void> registerProtocolActivation(Function callback) async {
    // 创建一个MethodChannel
    const platform = MethodChannel('deep_link_channel');

    // 监听原生代码发送的深度链接
    platform.setMethodCallHandler((call) async {
      if (call.method == 'handleDeepLink') {
        String deepLink = call.arguments;
        callback(deepLink);
      }
    });
  }
}
