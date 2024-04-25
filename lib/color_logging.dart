import 'dart:convert';

import 'package:color_logging/src/color_logger.dart';
import 'package:logging/logging.dart';

import 'color_logging.dart';
export 'src/ansi_color.dart';
export 'src/logger_filter.dart';

extension ColorLoggerHelper on Logger {
  ///
  ///```dart
  ///   AnsiColor.showColor();
  ///   final Map<Level, AnsiColor> levelColors = {
  ///     Level.FINE: AnsiColor.fg(75),
  ///     Level.SEVERE: AnsiColor.fg(196),
  ///    };
  ///
  ///   final Map<Level, int> methodCounts = {
  ///     Level.SEVERE: 8,
  ///     Level.FINE: 2,
  ///    };
  ///
  ///
  ///```
  void listenOnColorLogger({
    bool stackTracking = true,
    Map<Level, AnsiColor>? levelColors,
    Map<Level, int>? methodCounts,
    Filter? filter,
    Level? highLightLevel = Level.ALL,
    required kIsWeb,
  }) {
    ColorLogger.stackTracking = stackTracking;
    ColorLogger.highLightLevel = highLightLevel;
    ColorLogger.kIsWeb = kIsWeb;
    ColorLogger.updateLevelColors(levelColors);
    ColorLogger.updateMethodCounts(methodCounts);
    ColorLogger.filter = filter ?? Filter.allPass();
    Logger.root.onRecord.listen(ColorLogger.output);
  }

  void logPrettyMap(Object arguments, {Level level = Level.INFO}) {
    assert(
      () {
        if (arguments is! Map) {
          throw ArgumentError('arguments must be a Map');
        }
        return true;
      }(),
    );
    log(level, prettyFormat(arguments));
  }
}

String prettyFormat(Object arguments) =>
    const JsonEncoder.withIndent('  ').convert(arguments as Map);
