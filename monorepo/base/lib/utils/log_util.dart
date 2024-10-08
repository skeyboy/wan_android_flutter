library base;

import 'package:base/constants/constants.dart';
import 'package:logger/logger.dart';


class WanLog {
  static const String tag = "WanLog";

  static Logger logger = Logger();

  static void i(String msg, {String tag = tag}) {
    if (Constant.debug) {
      logger.i(msg);
    }
  }

  static void d(String msg, {String tag = tag}) {
    if (Constant.debug) {
      logger.d(msg);
    }
  }

  static void w(String msg, {String tag = tag}) {
    if (Constant.debug) {
      logger.w(msg);
    }
  }

  static void e(String msg, {String tag = tag}) {
    if (Constant.debug) {
      logger.e(msg);
    }
  }
}
