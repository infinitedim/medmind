sealed class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class MLFailure extends Failure {
  const MLFailure(super.message);
}

class EncryptionFailure extends Failure {
  const EncryptionFailure(super.message);
}
