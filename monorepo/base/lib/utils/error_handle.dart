library base;

import 'dart:async';

import 'package:flutter/foundation.dart';

void handleError(void Function() body) {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      print("Error:$details");
    }
    FlutterError.dumpErrorToConsole(details);
  };

  runZonedGuarded(body, (error, stack) async {
    await reportError(error, stack);
  });
}

Future<void> reportError(Object error, StackTrace stack) async {
  // 上传报错信息
}
