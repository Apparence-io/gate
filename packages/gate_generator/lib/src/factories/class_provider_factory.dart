import 'package:gate_generator/src/models/class_model.dart';

import 'abstract_provider_factory.dart';

abstract class BaseProviderFactory implements ProviderFactory {
  final ClassSchema schema;

  BaseProviderFactory(this.schema);

  @override
  String get constructor => schema.constructor.isEmpty ? "${schema.className}($parameters)" : "${schema.className}.${schema.constructor}($parameters)";

  @override
  String get name => "${schema.className[0].toLowerCase()}${schema.className.substring(1)}";

  @override
  String get method {
    if (schema.constructor.isNotEmpty) {
      return "get${schema.className}${schema.constructor[0].toUpperCase()}${schema.constructor.substring(1)}";
    }
    return "get${schema.className}";
  }

  @override
  String get parameters {
    // var res = StringBuffer();
    // for (var element in schema.dependencies) {
    //   res.write("get${element.type}()");
    // }
    // return res.toString();
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
  String build() {
    var res = StringBuffer();
    res.writeln("  late final ${schema.className} _$name = $constructor;");
    res.writeln("  ");
    res.writeln("  ${schema.className} $method() => _$name;");
    res.writeln("  ");
    return res.toString();
  }
}

class DynamicProviderFactory extends BaseProviderFactory {
  DynamicProviderFactory(ClassSchema schema) : super(schema);

  @override
  String build() {
    var res = StringBuffer();
    res.writeln("  ${schema.className} $method() => $constructor;");
    res.writeln("  ");
    return res.toString();
  }
}
