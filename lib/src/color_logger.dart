import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'dart:developer' as developer;

part './ansi_color.dart';

final levelColors = {
  Level.FINE: AnsiColor.fg(75),
  Level.SEVERE: AnsiColor.fg(196),
};

final Map<Level, int> methodCounts = {
  Level.SEVERE: 8,
  Level.FINE: 2,
};

final levelEmojis = {
  Level.FINE: '💡 ',
  Level.SEVERE: '⛔ ',
};

class ColorLogger {
  static const verticalLine = ' │ ';
  static const head =
      '┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────';
  static const tail =
      '└──────────────────────────────────────────────────────────────────────────────────────────────────────────────';

  static bool _logStack = true;
  static bool get logStack => _logStack;
  static set logStack(bool value) {
    if (kIsWeb && value == true) {
      developer.log(AnsiColor.fg(196)(
          "ColorObserverLogger.logStack tracking is not supported on web platform"));
      return;
    }
    _logStack = value;
  }

  static output(LogRecord record) {
    // methodCount = methodCounts[level];
    AnsiColor color = levelColors[record.level] ?? AnsiColor.none();
    List<String> msg = AnsiColor.loggerHelperFormatter.format(record);
    if (record.level >= Level.SEVERE) {
      msg = [head, ...msg, tail];
    }
    for (var s in msg) {
      // List.generate(80, (i) => print(AnsiColor.fg(i)("[$i]=>s")));
      if (kIsWeb) {
        print('  ${color(s)}');
      } else if (Platform.isIOS) {
        developer.log('  ${color(s)}');
      } else {
        print('  ${color(s)}');
      }
    }
  }
}

class LoggerHelperFormatter {
  static const verticalLine = ' │ ';
  static List<String> skipFileName = [
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
    "package:color_logger"
  ];

  /// Matches a stacktrace line as generated on Android/iOS devices.
  /// For example:
  /// #1      Logger.log (package:logger/src/logger.dart:115:29)
  static final _deviceStackTraceRegex =
      RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  static String cleanTrackInfo(String stackInfo) {
    return stackInfo.replaceFirst(RegExp(r'^#\d+\s+'), '# ');
  }

  late DateTime _startTime;

  final int methodCount;
  final int errorMethodCount;
  final bool colors;
  final bool printEmojis;
  final bool printTime;
  final String title;

  LoggerHelperFormatter({
    this.title = "",
    this.methodCount = 5,
    this.errorMethodCount = 8,
    this.colors = true,
    this.printEmojis = true,
    this.printTime = true,
  }) {
    _startTime = DateTime.now();
  }

  String getTime() {
    String _threeDigits(int n) {
      if (n >= 100) return '$n';
      if (n >= 10) return '0$n';
      return '00$n';
    }

    String _twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    var now = DateTime.now();
    String formattedDate =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    var h = _twoDigits(now.hour);
    var min = _twoDigits(now.minute);
    var sec = _twoDigits(now.second);
    var ms = _threeDigits(now.millisecond);
    var timeSinceStart = now.difference(_startTime).toString();
    // return '$h:$min:$sec.$ms (+$timeSinceStart)';
    return '$formattedDate $h:$min:$sec.$ms';
  }

  List<String> format(LogRecord record, {int? methodCount}) {
    // methodCount = methodCounts[level];
    String? stackTraceStr;
    if (ColorLogger.logStack) {
      stackTraceStr = formatStackTrace(
        StackTrace.current,
        methodCount ?? methodCounts[record.level] ?? 3,
      );
    }

    String timeStr = getTime();

    List<String> list = _formatAndPrint(
      record,
      timeStr,
      stackTraceStr,
    );
    return list;
  }

  List<String> _formatAndPrint(
    LogRecord record,
    String time,
    String? stacktrace,
  ) {
    List<String> buffer = [];
    List<String> lines = [];
    final msg =
        '[${record.loggerName}]$verticalLine${record.level.name}$verticalLine$time$verticalLine${record.message}';
    if (stacktrace != null) {
      lines = stacktrace.split('\n');
      for (var line in lines) {
        buffer.add(
            "[${record.loggerName}]$verticalLine${record.level.name}$verticalLine$line");
      }
    }
    final result = [...buffer.reversed.toList(), msg];

    return result;
  }

  String? formatStackTrace(StackTrace stackTrace, int? methodCount) {
    var lines = stackTrace.toString().split('\n');
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      if (_discardDeviceStacktraceLine(line) ||
          skipFileIfNeed(line, skipFileName) ||
          line.contains("<asynchronous suspension>") ||
          line == "") {
        continue;
      }
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
      count++;
      if (count >= methodCount!) {
        if (methodCount == 0) {
          formatted.clear();
        }
        break;
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(2)!.startsWith('package:logger');
  }

  bool skipFileIfNeed(String line, List<String> skipFiles) {
    for (final skipFile in skipFiles) {
      if (line.contains(skipFile)) {
        return true;
      }
    }
    return false;
  }
}
