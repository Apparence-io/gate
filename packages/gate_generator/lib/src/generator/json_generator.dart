import 'dart:async';

abstract class GeneratorForJson<T> {
  GeneratorForJson();

  Future<String> generate();

  void parse(String json);
}
