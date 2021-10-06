import 'package:code_builder/code_builder.dart';
import 'package:gate_generator/src/models/class_model.dart';

import 'abstract_provider_factory.dart';

abstract class BaseProviderFactory implements ProviderFactory {
  final ClassSchema schema;

  BaseProviderFactory(this.schema);

  @override
  Code get constructor => schema.constructor.isEmpty
      ? refer(schema.className, 'package:${schema.path}')
          .call([refer(parameters)]).code
      : refer(schema.className, 'package:${schema.path}')
          .property(schema.constructor)
          .call([refer(parameters)]).code;

  @override
  String get name =>
      "${schema.className[0].toLowerCase()}${schema.className.substring(1)}";

  @override
  String get method {
    if (schema.constructor.isNotEmpty) {
      return "get${schema.className}${schema.constructor[0].toUpperCase()}${schema.constructor.substring(1)}";
    }
    return "get${schema.className}";
  }

  @override
  String get parameters {
    var res = StringBuffer();
    for (var element in schema.dependencies) {
      if (element.classSchema == null) {
        throw "element cannot be created. ${element.type} must be Injectable.";
      }
      res.write("${element.classSchema!.providerFactory.method}(),");
    }
    return res.toString();
  }
}

class SingletonProviderFactory extends BaseProviderFactory {
  SingletonProviderFactory(ClassSchema schema) : super(schema);

  @override
  ProviderResult build() {
    final Field field = Field((b) => b
      ..docs.add('// ${schema.className} singleton')
      ..late = true
      ..modifier = FieldModifier.final$
      ..type = refer(schema.className, 'package:${schema.path}')
      ..name = '_$name'
      ..assignment = constructor);

    final Method method = Method((b) => b
      ..docs.add('// injected ${schema.className}')
      ..lambda = true
      ..returns = refer(schema.className, 'package:${schema.path}')
      ..name = this.method
      ..body = Code('_$name'));

    return ProviderResult(field, method);
  }
}

class DynamicProviderFactory extends BaseProviderFactory {
  DynamicProviderFactory(ClassSchema schema) : super(schema);

  @override
  ProviderResult build() {
    final Method method = Method((b) => b
      ..docs.add('// injected ${schema.className}')
      ..returns = refer(schema.className, 'package:${schema.path}')
      ..name = this.method
      ..lambda = true
      ..body = constructor);

    return ProviderResult(null, method);
  }
}
