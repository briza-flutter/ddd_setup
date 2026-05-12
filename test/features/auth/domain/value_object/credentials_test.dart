import 'package:ddd_setup/core/error/failures.dart';
import 'package:ddd_setup/features/auth/domain/value_object/credentials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneNumber', () {
    test('11 位以 1 开头的合法手机号通过', () {
      final r = PhoneNumber.create('13800138000');
      expect(r.valueOrNull(), isNotNull);
      expect(r.valueOrNull()!.value, '13800138000');
      expect(r.failureOrNull(), isNull);
    });

    test('位数不足返回 ValueFailure', () {
      final r = PhoneNumber.create('12345');
      expect(r.valueOrNull(), isNull);
      expect(r.failureOrNull(), isA<ValueFailure>());
    });

    test('首位非 1 返回 ValueFailure', () {
      final r = PhoneNumber.create('23800138000');
      expect(r.valueOrNull(), isNull);
      expect(r.failureOrNull(), isA<ValueFailure>());
    });

    test('包含字母返回 ValueFailure', () {
      final r = PhoneNumber.create('1380013800a');
      expect(r.valueOrNull(), isNull);
      expect(r.failureOrNull(), isA<ValueFailure>());
    });

    test('相同 value 的两个实例相等（ValueObject 语义）', () {
      final a = PhoneNumber.create('13800138000').valueOrNull()!;
      final b = PhoneNumber.create('13800138000').valueOrNull()!;
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
  });

  group('Password', () {
    test('恰好 6 位通过', () {
      expect(Password.create('123456').valueOrNull(), isNotNull);
    });

    test('多于 6 位通过', () {
      expect(Password.create('abcdefg').valueOrNull(), isNotNull);
    });

    test('少于 6 位失败', () {
      final r = Password.create('12345');
      expect(r.valueOrNull(), isNull);
      expect(r.failureOrNull(), isA<ValueFailure>());
    });

    test('空字符串失败', () {
      expect(Password.create('').valueOrNull(), isNull);
    });
  });
}
