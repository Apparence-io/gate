import 'dart:async';
import 'package:build/build.dart';
import 'package:gate_generator/src/generator/graph_reader.dart';
import 'package:gate_generator/src/models/class_model.dart';

import 'json_generator.dart';

class GateCodeGenerator extends GeneratorForJson<ClassSchema> {
  GateGraphReader gateReader;
  AssetId? assetId;

  GateCodeGenerator(this.gateReader) : super();

  @override
  Future<String> generate(BuildStep buildStep) async {
    if (gateReader.graph == null) {
      await gateReader.build(buildStep);
    }
    for (var injectable in gateReader.graph!.injectables) {
      for (var dependency in injectable.dependencies) {
        gateReader.graph!.checkDependency(dependency);
      }
    }
    gateReader.graph!.injectDependencies();
    gateReader.graph!.checkCyclicDependency();

    return gateReader.graph!.appProviderFactory.toString();
  }
}
