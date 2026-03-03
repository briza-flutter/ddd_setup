/// 基础 Failure 类
abstract class Failure {
  final String message;
  Failure({required this.message});
}

/// 值对象验证失败
class ValueFailure extends Failure {
  ValueFailure({super.message = "Invalid value"});
}

/// 服务器错误
class ServerFailure extends Failure {
  ServerFailure({super.message = 'Server error'});
}

/// 网络错误
class NetworkFailure extends Failure {
  NetworkFailure({super.message = 'Network error'});
}

/// 验证错误
class ValidationFailure extends Failure {
  ValidationFailure({super.message = 'Validation failed'});
}

/// 未认证错误
class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({super.message = 'Unauthorized'});
}

/// 业务逻辑错误
class BusinessFailure extends Failure {
  BusinessFailure({super.message = 'Business rule violated'});
}

/// 未知错误
class UnknownFailure extends Failure {
  UnknownFailure({super.message = 'Unknown error occurred'});
}
