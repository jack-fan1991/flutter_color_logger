import 'package:color_logging/color_logging.dart';
import 'package:logging/logging.dart';

final Map<Level, AnsiColor> defaultLevelColors = {
  Level.ALL: AnsiColor.fg(8),
  Level.FINEST: AnsiColor.fg(244),
  Level.FINER: AnsiColor.fg(7),
  Level.FINE: AnsiColor.fg(75),
  Level.INFO: AnsiColor.fg(112),
  Level.WARNING: AnsiColor.fg(214),
  Level.SEVERE: AnsiColor.fg(196),
};

const List<String> skipFileName = [
  "logger_helper",
  "package:bloc",
  "stream.dart",
  "zone.dart",
  "async_cast.dart",
  "stream_impl.dart",
  "dart:async",
  "flutter_bloc",
  "abstract_exception.dart",
  "base_bloc_widget.dart",
  "package:flutter/src/widgets/framework.dart",
  "package:flutter/src/scheduler/binding.dart",
  "dart:ui",
  "LoggerHelperFormatter",
  "ColorLoggerFormatter",
  "package:logging",
  "package:color_logging",
  "<asynchronous suspension>",
  "package:test_api",
  "dart-sdk/lib/_internal/js_dev_runtime",
  "packages/color_logging",
  "dart-sdk/lib",
  "packages/logging"
];
