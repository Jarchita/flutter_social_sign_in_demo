// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:core';

import 'package:flutter/foundation.dart';

class Logger {
  static String tagLogger = 'Logger';

  static void d(String tag, message) {
    if (kReleaseMode) {
      return;
    }
    try {
      debugPrint('$tagLogger : $tag : $message');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void e(String tag, message) {
    if (kReleaseMode) {
      return;
    }
    try {
      debugPrint('$tagLogger : $tag : ERROR : ${message.toString()}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
