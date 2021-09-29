import 'package:code_builder/code_builder.dart';

abstract class ProviderFactory {
  String get constructor;

  String get name;

  String get method;

  String get parameters;

  String build();
}
