import 'dart:async';
import 'dart:convert';
import 'package:build/build.dart';
import 'package:gate_generator/src/models/class_model.dart';

import 'gate_provider_helper.dart';
import 'json_generator.dart';

class GateCodeGenerator extends GeneratorForJson<ClassSchema> {
  AssetId? assetId;
  List<ClassSchema> clazz = [];

  GateCodeGenerator() : super();

  @override
  Future<String> generate() async {
    final providerGraph = GateProviderGraph(clazz);
    for (var element in clazz) {
      log.info("ClassSchema generateForJson ${element.className}");
    }
    return providerGraph.toString();
  }

  @override
  void parse(String json) {
    List<dynamic> _clazzList = jsonDecode(json);
    clazz.addAll(_clazzList.map((e) => ClassSchema.fromJson(e)).toList());
  }
}
