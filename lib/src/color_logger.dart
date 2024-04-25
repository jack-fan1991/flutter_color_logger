import 'dart:io';
import 'package:color_logging/color_logging.dart';
import 'package:color_logging/src/config/default_config.dart';
import 'package:logging/logging.dart';

import 'dart:developer' as developer;

final loggerHelperFormatter = LoggerHelperFormatter();

class ColorLogger {
  static const verticalLine = ' │ ';
  static const head =
      '┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────';
  static const tail =
      '└──────────────────────────────────────────────────────────────────────────────────────────────────────────────';
  static Filter filter = Filter.allPass();
  static bool _stackTracking = true;
  static bool get stackTracking => _stackTracking;
  static bool kIsWeb = false;
  static set stackTracking(bool value) {
    _stackTracking = value;
  }

  static Level _highLightLevel = Level.SEVERE;

  static set highLightLevel(Level? value) {
    _highLightLevel = value ?? Level.SEVERE;
  }

  static final Map<Level, int> defaultMethodCounts = {
    Level.SEVERE: 8,
    Level.FINE: 2,
  };

  static void updateMethodCounts(Map<Level, int>? methodCounts) {
    if (methodCounts == null) return;
    for (final element in methodCounts.entries) {
      defaultMethodCounts[element.key] = element.value;
    }
  }

  static void updateLevelColors(Map<Level, AnsiColor>? levelColors) {
    if (levelColors == null) return;
    for (final element in levelColors.entries) {
      defaultLevelColors[element.key] = element.value;
    }
  }

  static bool canLog(LogRecord logRecord) {
    if (filter.name.isEmpty) {
      return true;
    } else if (filter is ShowWhenFilter) {
      return filter.name.contains(logRecord.loggerName);
    } else if (filter is HideWhenFilter) {
      return !filter.name.contains(logRecord.loggerName);
    } else {
      return true;
    }
  }

  static output(LogRecord record) {
    // methodCount = methodCounts[level];
    if (!canLog(record)) return;
    AnsiColor color = defaultLevelColors[record.level] ?? AnsiColor.none();
    List<String> msg = loggerHelperFormatter.format(record);
    if (record.level >= _highLightLevel) {
      msg = [head, ...msg, tail];
    }
    for (var s in msg) {
      final lines = s.split('\n');
      final firstLine = msg.firstWhere((element) => element.contains('│'));
      String prefix = firstLine.split('│').sublist(0, 2).join('│') + '│';
      String _s = s;
      if (lines.length > 1) {
        _s = lines.map((e) {
          final idx = lines.indexOf(e);
          String _prefix = '';
          if (idx == 0) {
            _prefix = "";
          } else {
            _prefix = "  " + prefix;
          }
          return color('$_prefix${e}');
        }).join('\n');
      }

      // List.generate(80, (i) => print(AnsiColor.fg(i)("[$i]=>s")));
      if (ColorLogger.kIsWeb) {
        print('  ${color(_s)}');
      } else if (Platform.isIOS) {
        developer.log('  ${color(_s)}');
      } else {
        print('  ${color(_s)}');
      }
    }
  }
}

class LoggerHelperFormatter {
  static const verticalLine = ' │ ';

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
    // var timeSinceStart = now.difference(_startTime).toString();
    // return '$h:$min:$sec.$ms (+$timeSinceStart)';
    return '$formattedDate $h:$min:$sec.$ms';
  }

  List<String> format(LogRecord record, {int? methodCount}) {
    // methodCount = methodCounts[level];
    String? stackTraceStr;
    if (ColorLogger.stackTracking) {
      stackTraceStr = formatStackTrace(
        StackTrace.current,
        methodCount ?? ColorLogger.defaultMethodCounts[record.level] ?? 3,
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
    final timeTitle =
        '│ [${record.loggerName}]$verticalLine${record.level.name}$verticalLine$time';
    final msg =
        '│ [${record.loggerName}]$verticalLine${record.level.name}$verticalLine${record.message}';
    if (stacktrace != null) {
      lines = stacktrace.split('\n');
      for (var line in lines) {
        buffer.add(
            "│ [${record.loggerName}]$verticalLine${record.level.name}$verticalLine$line");
      }
    }
    final result = [timeTitle, ...buffer.reversed.toList(), msg];

    return buffer.isEmpty
        ? ["$timeTitle$verticalLine${record.message}"]
        : result;
  }

  String? formatStackTrace(StackTrace stackTrace, int? methodCount) {
    var lines = stackTrace.toString().split('\n');
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      if (_discardDeviceStacktraceLine(line) ||
          skipFileIfNeed(line, skipFileName) ||
          line == "") {
        continue;
      }
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}()');
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
