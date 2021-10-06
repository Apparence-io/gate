import 'package:code_builder/code_builder.dart';

abstract class ProviderFactory {
  Code get constructor;

  String get name;

  String get method;

  String get parameters;

  ProviderResult build();
}

class ProviderResult {
  final Field? field;
  final Method method;

  ProviderResult(this.field, this.method);
}
