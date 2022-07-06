import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:gate_generator/src/factories/abstract_provider_factory.dart';
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
      injectedElements.add(result.getInjectedMethod);
      injectedElements.add(result.setMockInjectedMethod);
      if (result.field != null) {
        singletons.add(result.field!);
      }
      singletons.add(result.mockedField);
    }

    final provider = Class((b) => b
      ..docs.addAll([
        '// coverage:ignore-file ',
        '// ********************************',
        '// Gate generated file',
        '// Do not modify by hand',
        '// ********************************',
        '// ignore_for_file: type=lint',
        '// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target'
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

    final getProviderMethod = Field((b) => b
      ..modifier = FieldModifier.final$
      ..type = refer('AppProvider')
      ..name = 'appProvider'
      ..assignment = Code("AppProvider.instance"));

    final providerLibrary =
        Library((b) => b..body.addAll([provider, getProviderMethod]));

    final emitter = DartEmitter.scoped();

    return DartFormatter().format('${providerLibrary.accept(emitter)}');
  }
}
