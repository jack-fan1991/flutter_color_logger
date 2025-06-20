import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:color_logging/color_logging.dart';

class LoggerManger {
  static void setup({Level level = Level.ALL}) {
    Logger.root.level = level;
    Logger.root.listenOnColorLogger(
      stackTracking: true,
      kIsWeb: kIsWeb,
      highLightLevel: level,
    );
  }
}
