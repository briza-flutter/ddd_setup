abstract class ValueObject<T> {
  T get value;
  const ValueObject();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

sealed class ValueObjectResult<T extends ValueObject> {
  const ValueObjectResult();

  T? valueOrNull() {
    if (this is ValueObjectSuccess<T>) {
      return (this as ValueObjectSuccess<T>).value;
    } else {
      return null;
    }
  }

  Object? failureOrNull() {
    if (this is ValueObjectFailure<T>) {
      return (this as ValueObjectFailure<T>).failure;
    } else {
      return null;
    }
  }
}

class ValueObjectSuccess<T extends ValueObject> extends ValueObjectResult<T> {
  final T value;
  const ValueObjectSuccess(this.value);
}

class ValueObjectFailure<T extends ValueObject> extends ValueObjectResult<T> {
  final Object failure;
  const ValueObjectFailure(this.failure);
}
