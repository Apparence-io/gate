class CyclicDepencyException implements Exception {
  final String message;

  CyclicDepencyException(this.message);

  @override
  String toString() => '''CyclicDepencyException: $message
      -----------------------------------------------------
      You have a class making a cyclic dependency error
      Ex : - class A with dependency B,C
           - class B with dependency A''';
}
