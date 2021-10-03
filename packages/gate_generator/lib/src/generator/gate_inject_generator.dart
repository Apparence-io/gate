import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:gate/gate.dart';
import 'package:gate_generator/src/generator/graph_reader.dart';
import 'package:gate_generator/src/models/class_model.dart';
import 'package:gate_generator/src/models/gate_provider_graph.dart';
import 'package:source_gen/source_gen.dart';

import 'json_generator.dart';

class GateInjectGenerator extends GeneratorForAnnotation<Inject> {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    var gateReader = GateGraphReader.instance;
    if (gateReader.graph == null) {
      await GateGraphReader.instance.build(buildStep);
    }
    return super.generate(library, buildStep);
  }

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    var res = StringBuffer();
    var children = annotation.peek("children")!.listValue;
    // res.writeln("import 'package:${buildStep.inputId.package}:lib/gate/gate_provider.dart';");
    res.writeln();
    res.writeln("part of '${buildStep.inputId.uri.pathSegments.last}';");
    res.writeln();
    res.writeln("extension ${element.name}Injection on CoffeePage {");
    for (var child in children) {
      final String type = child.getField("type")!.toStringValue()!;
      final String? factoryName = child.getField("factoryName")?.toStringValue();
      final String? name = child.getField("attrName")?.toStringValue();
      res.writeln();
      res.writeln("  $type get ${_getAttrName(type, name)} => AppProvider.instance.${_getMethod(type, factoryName)}();");
    }
    res.writeln("}");
    return res.toString();
  }

  String _getAttrName(String type, String? name) {
    return name ?? "${type.toString()[0].toLowerCase()}${type.toString().substring(1)}";
  }

  String _getMethod(String type, String? factoryName) {
    if (factoryName != null) {
      return "get$type${factoryName.toString()[0].toUpperCase()}${factoryName.substring(1)}";
    }
    return "get$type";
  }
}
