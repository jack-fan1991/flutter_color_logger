import 'package:logging/logging.dart';

class UtilsTest {
  static error() {
    final Logger logger = Logger("UtilsTest2");
    logger.severe("UtilsTest2.error");
  }
}
