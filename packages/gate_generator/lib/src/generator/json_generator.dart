import 'dart:async';

import 'package:build/build.dart';

abstract class GeneratorForJson<T> {
  GeneratorForJson();

  Future<String> generate(BuildStep buildStep);
}
