import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:gate_generator/src/factories/abstract_provider_factory.dart';
import 'package:gate_generator/src/models/class_model.dart';
import 'package:gate_generator/src/models/gate_provider_graph.dart';

class GateProviderFactory {
  final GateProviderGraph graph;

  GateProviderFactory(this.graph);

  @override
  String toString() {
    final List<Field> singletons = [];
    final List<Method> injectedElements = [];

    for (var el in graph.injectables) {
      final ProviderResult result = el.providerFactory.build();
      injectedElements.add(result.method);
      if (result.field != null) {
        singletons.add(result.field!);
      }
    }

    final provider = Class((b) => b
      ..docs.addAll([
        '',
        '// ********************************',
        '// Gate AppProvider generated file',
        '// Do not modify by hand',
        '// ********************************'
      ])
      ..name = 'AppProvider'
      ..fields.add(Field((b) => b
        ..name = 'instance'
        ..static = true
        ..modifier = FieldModifier.final$
        ..type = refer('AppProvider')
        ..assignment = const Code('AppProvider._()')))
      ..fields.addAll(singletons)
      ..constructors.add(Constructor((b) => b..name = '_'))
      ..methods.addAll(injectedElements));

    final providerLibrary = Library((b) => b..body.add(provider));

    final emitter = DartEmitter.scoped();

    return DartFormatter().format('${providerLibrary.accept(emitter)}');
  }
}
