import 'package:code_builder/code_builder.dart';
import 'package:gate_generator/src/models/class_model.dart';

import 'abstract_provider_factory.dart';

abstract class BaseProviderFactory implements ProviderFactory {
  final ClassSchema schema;

  BaseProviderFactory(this.schema);

  @override
  String get constructor => schema.constructor.isEmpty
      ? "${schema.className}($parameters)"
      : "${schema.className}.${schema.constructor}($parameters)";

  @override
  String get name => schema.constructor.isEmpty
      ? "${schema.className[0].toLowerCase()}${schema.className.substring(1)}"
      : "${schema.className[0].toLowerCase()}${schema.className.substring(1)}${schema.constructor[0].toUpperCase()}${schema.constructor.substring(1)}";

  @override
  String get getMethod {
    if (schema.constructor.isNotEmpty) {
      return "get${schema.className}${schema.constructor[0].toUpperCase()}${schema.constructor.substring(1)}";
    }
    return "get${schema.className}";
  }

  @override
  String get setMockMethod {
    if (schema.constructor.isNotEmpty) {
      return "set${schema.className}${schema.constructor[0].toUpperCase()}${schema.constructor.substring(1)}Mock";
    }
    return "set${schema.className}Mock";
  }

  @override
  String get parameters {
    var res = StringBuffer();
    for (var element in schema.dependencies) {
      if (element.classSchema == null) {
        throw "element cannot be created. ${element.type} must be Injectable.";
      }
      res.write("${element.classSchema!.providerFactory.getMethod}(),");
    }
    return res.toString();
  }

  Expression _generateConstructor() => schema.constructor.isEmpty
      ? refer(schema.className, 'package:${schema.path}')
          .call([refer(parameters)])
      : refer(schema.className, 'package:${schema.path}')
          .property(schema.constructor)
          .call([refer(parameters)]);

  Field _generateMockField() => Field((b) => b
    ..docs.add('// ${schema.className} mock')
    ..type = refer('${schema.className}?', 'package:${schema.path}')
    ..name = '_${name}Mock');

  Method _generateGetInjectedMethod(final Code body) => Method((b) => b
    ..docs.add('// injected ${schema.className}')
    ..lambda = true
    ..returns = refer(schema.className, 'package:${schema.path}')
    ..name = getMethod
    ..body = body);

  Method _generateSetMockMethod() => Method.returnsVoid(((b) => b
    ..docs.add('// Set ${schema.className} mock')
    ..lambda = true
    ..name = setMockMethod
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'mock'
      ..type = refer('${schema.className}?', 'package:${schema.path}')))
    ..body = Code('_${name}Mock = mock')));
}

class SingletonProviderFactory extends BaseProviderFactory {
  SingletonProviderFactory(ClassSchema schema) : super(schema);

  @override
  ProviderResult build() {
    final Field fieldSingleton = Field((b) => b
      ..docs.add('// ${schema.className} singleton')
      ..late = true
      ..modifier = FieldModifier.final$
      ..type = refer(schema.className, 'package:${schema.path}')
      ..name = '_$name'
      ..assignment = _generateConstructor().code);

    final Field mockedInjectedSingletonField = _generateMockField();

    final Method getInjectedSingletonMethod =
        _generateGetInjectedMethod(Code('_${name}Mock ?? _$name'));

    return ProviderResult(fieldSingleton, mockedInjectedSingletonField,
        getInjectedSingletonMethod, _generateSetMockMethod());
  }
}

class DynamicProviderFactory extends BaseProviderFactory {
  DynamicProviderFactory(ClassSchema schema) : super(schema);

  @override
  ProviderResult build() {
    final Field mockedFieldInjectedDynamicField = _generateMockField();

    final Method getInjectedDynamicMethod = _generateGetInjectedMethod(
        refer("_${name}Mock").ifNullThen(_generateConstructor()).code);

    return ProviderResult(null, mockedFieldInjectedDynamicField,
        getInjectedDynamicMethod, _generateSetMockMethod());
  }
}
