import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:logger/logger.dart' as Logger2;
import 'package:logging/logging.dart';

final Logger logger = Logger("UtilsTest");

class UtilsTest {
  static error() {
    try {
      throw Exception("Simulate error");
    } catch (e, stackTrace) {
      final logger = Logger("UtilsTest");
      logger.severe("UtilsTest.error\n$stackTrace");
    }
  }

  static loggerError() {
    var logger2 = Logger2.Logger(
      printer: Logger2.PrettyPrinter(
        methodCount: 8, // Number of method calls to be displayed
        errorMethodCount: 8, // Number of method calls if stacktrace is provided
        lineLength: 120, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        // Should each log print contain a timestamp
        dateTimeFormat: Logger2.DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );

    try {
      final list = <int>[];
      print(list.first); // 空 list，會觸發 dart:core 錯誤
    } catch (e, stackTrace) {
      logger2.e("Logger is working!", stackTrace: stackTrace);
      logger.severe(e, null, stackTrace);
      rethrow;
    }
  }

  static dartEvalError() {
    var logger2 = Logger2.Logger(
      printer: Logger2.PrettyPrinter(
        methodCount: 2, // Number of method calls to be displayed
        errorMethodCount: 8, // Number of method calls if stacktrace is provided
        lineLength: 120, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        // Should each log print contain a timestamp
        dateTimeFormat: Logger2.DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
    final Logger logger = Logger("dartEvalError");
    final compiler = Compiler();
    try {
      final program = compiler.compile({
        'my_package': {
          'main.dart': '''
          void main() {
            final list = <int>[];
            print(list.first);  // 空 list，會觸發 dart:core 錯誤
          }
        ''',
        },
      });

      final runtime = Runtime.ofProgram(program);
      print(runtime.executeLib('package:my_package/main.dart', 'main'));
    } catch (e, stackTrace) {
      logger2.e("dartEvalError!", stackTrace: stackTrace);
      logger.severe("dartEvalError!", null, stackTrace);
    }
  }
}
