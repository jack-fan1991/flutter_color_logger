import 'dart:io';

import 'dart:developer' as developer;

import 'package:color_logging/src/color_logger.dart';

class AnsiColor {
  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  static const ansiEsc = '\x1B[';

  /// Reset all colors and options for current SGRs to terminal defaults.
  static const ansiDefault = '${ansiEsc}0m';

  static showColor({int start = 0, int end = 255}) {
    // List.generate(80, (i) => print(AnsiColor.fg(i)("[$i]=>s")));
    for (var i = start; i < end; i++) {
      if (ColorLogger.kIsWeb) {
        print(AnsiColor.fg(i)("[$i] => Test"));
      } else if (Platform.isIOS) {
        developer.log(AnsiColor.fg(i)("[$i] => Test"));
      } else {
        print(AnsiColor.fg(i)("[$i] => Test"));
      }
    }
  }

  final int? fg;
  final int? bg;
  final bool color;

  AnsiColor.none()
      : fg = null,
        bg = null,
        color = false;

  AnsiColor.fg(this.fg)
      : bg = null,
        color = true;

  AnsiColor.bg(this.bg)
      : fg = null,
        color = true;

  @override
  String toString() {
    if (fg != null) {
      return '${ansiEsc}38;5;${fg}m';
    } else if (bg != null) {
      return '${ansiEsc}48;5;${bg}m';
    } else {
      return '';
    }
  }

  /// Resets all pen attributes in the terminal.
  String get up => "[0m";

  /// Write the [msg.toString()] with the pen's current settings and then
  /// reset all attributes.
  String write(Object msg) => '${this}$msg$up';

  String call(String msg) {
    if (color) {
      return '${this}$msg$ansiDefault';
    } else {
      return msg;
    }
  }

  AnsiColor toFg() => AnsiColor.fg(bg);

  AnsiColor toBg() => AnsiColor.bg(fg);

  /// Defaults the terminal's foreground color without altering the background.
  String get resetForeground => color ? '${ansiEsc}39m' : '';

  /// Defaults the terminal's background color without altering the foreground.
  String get resetBackground => color ? '${ansiEsc}49m' : '';

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}
