import 'dart:convert';

import 'package:build/build.dart';
import 'package:gate_generator/src/models/class_model.dart';
import 'package:gate_generator/src/models/gate_provider_graph.dart';
import 'package:glob/glob.dart';
import 'dart:async';

class GateGraphReader {
  final Glob inputFiles;
  final bool allowSyntaxErrors = true;
  GateProviderGraph? graph;

  static final GateGraphReader instance = GateGraphReader(folder: 'lib');

  GateGraphReader({required String folder})
      : inputFiles = Glob('$folder/**.gate_schema.json');

  Future<void> build(BuildStep buildStep) async {
    log.info("**************************");
    log.info("-- GateGraphReader build ");
    List<ClassSchema> classList = [];
    await for (final input in buildStep.findAssets(inputFiles)) {
      classList.addAll(_parse(await buildStep.readAsString(input)));
    }
    graph = GateProviderGraph(classList);
    log.info("-- ${graph!.injectables.length} injectables found");
    log.info("**************************");
  }

  List<ClassSchema> _parse(String json) {
    List<dynamic> _clazzList = jsonDecode(json);
    return _clazzList.map((e) => ClassSchema.fromJson(e)).toList();
  }
}
