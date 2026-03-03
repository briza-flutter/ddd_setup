import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class AppLogger {
  final Logger _logger = Logger();
  void d(String message) {
    _logger.d(message);
  }
}
