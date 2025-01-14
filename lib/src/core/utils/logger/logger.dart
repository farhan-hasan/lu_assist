import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

debug(dynamic data) {
  if (kDebugMode) {
    var logger = Logger();
    logger.i(data);
  } else {}
}
