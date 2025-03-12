// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class OAuth {
  static final Router app = Router();
  static HttpServer? _server;

  static void initRoute({
    required OAuthResponseBody response,
    required Function({
      String? refreshToken,
      String? error,
    }) callback,
  }) {
    app.get('/oauth/callback', (Request request) {
      String? error = request.requestedUri.queryParameters['error'];
      String? refreshToken =
          request.requestedUri.queryParameters['refresh_token'];

      if (error != null) {
        callback(error: error);
        return Response.unauthorized(
          response.error,
          headers: {'Content-Type': 'text/html'},
          encoding: utf8,
        );
      } else {
        callback(refreshToken: refreshToken);
        return Response.ok(
          response.success,
          headers: {'Content-Type': 'text/html'},
          encoding: utf8,
        );
      }
    });
  }

  static Future<int> start() async {
    _server = await io.serve(app.call, '127.0.0.1', 0);
    return _server!.port;
  }

  static close() {
    if (_server != null) {
      _server!.close();
      _server == null;
    }
  }
}

class OAuthResponseBody {
  OAuthResponseBody({
    required this.success,
    required this.error,
  });

  String success;
  String error;
}
