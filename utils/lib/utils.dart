import 'package:logging/logging.dart';
export 'package:utils_test/utils_test.dart';

class Utils {
  static error() {
    final Logger logger = Logger("Utils");
    logger.severe("Utils.error");
  }
}
