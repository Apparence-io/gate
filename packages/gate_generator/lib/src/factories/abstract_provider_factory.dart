import 'package:code_builder/code_builder.dart';

abstract class ProviderFactory {
  String get constructor;

  String get name;

  String get getMethod;

  String get parameters;

  String get setMockMethod;

  ProviderResult build();
}

class ProviderResult {
  final Field? field;
  final Field mockedField;
  final Method getInjectedMethod;
  final Method setMockInjectedMethod;

  ProviderResult(this.field, this.mockedField, this.getInjectedMethod,
      this.setMockInjectedMethod);
}
