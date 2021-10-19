import 'dart:async';

import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:gate/gate.dart';
import 'package:gate_generator/src/generator/graph_reader.dart';
import 'package:gate_generator/src/models/class_model.dart';
import 'package:gate_generator/src/models/gate_provider_graph.dart';
import 'package:gate_generator/src/models/injected_model.dart';
import 'package:source_gen/source_gen.dart';

import 'gate_imports_generator.dart';

class GateInjectGenerator extends GeneratorForAnnotation<Inject> {
  final GateGraphReader gateReader;
  late GateProviderGraph graph;

  GateInjectGenerator(this.gateReader) : super();

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    if (gateReader.graph == null) {
      await gateReader.build(buildStep);
    }
    graph = gateReader.graph!;
    try {
      return super.generate(library, buildStep);
    } catch (e, d) {
      log.severe(e, d);
    }
    return "";
  }

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    var res = StringBuffer();
    var children = annotation.peek("children")!.listValue;
    // create imports in userFile automatically
    try {
      var gateImportsGenerator = GateImportsGenerator(graph);
      await gateImportsGenerator.generate(buildStep);
    } catch (e, details) {
      log.severe(e, details);
    }

    //create file
    res.writeln();
    res.writeln("part of '${buildStep.inputId.uri.pathSegments.last}';");
    res.writeln();
    res.writeln("extension ${element.name}Injection on ${element.name} {");
    for (var child in children) {
      var injected = Injected.fromDartObject(child);
      res.writeln();
      res.writeln(injected.getter);
    }
    res.writeln("}");
    return res.toString();
  }
}
