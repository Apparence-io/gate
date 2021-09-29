// ignore_for_file: constant_identifier_names

import 'package:analyzer/dart/element/element.dart';
import 'package:gate_generator/src/factories/abstract_provider_factory.dart';
import 'package:gate_generator/src/factories/class_provider_factory.dart';

enum InjectionType {
  SINGLETON,
  DYNAMIC,
}

class ClassSchema {
  String path;
  String className;
  String constructor;
  InjectionType injectionType;

  List<Dependency> dependencies;

  ClassSchema({
    required this.path,
    required this.className,
    required this.constructor,
    required this.dependencies,
    required this.injectionType,
  });

  factory ClassSchema.singleton(
    ClassElement classElement,
    ConstructorElement element,
    String path,
  ) =>
      ClassSchema(
        path: path, // classElement.source!.fullName
        className: classElement.displayName,
        constructor: element.displayName,
        dependencies: element.parameters.map((param) => Dependency.fromParameter(param)).toList(),
        injectionType: InjectionType.SINGLETON,
      );

  factory ClassSchema.builder(
    ClassElement classElement,
    ConstructorElement element,
    String path,
  ) =>
      ClassSchema(
        path: path,
        className: classElement.displayName,
        constructor: element.displayName,
        dependencies: element.parameters.map((param) => Dependency.fromParameter(param)).toList(),
        injectionType: InjectionType.DYNAMIC,
      );

  ProviderFactory get providerFactory {
    switch (injectionType) {
      case InjectionType.SINGLETON:
        return SingletonProviderFactory(this);
      case InjectionType.DYNAMIC:
        return DynamicProviderFactory(this);
    }
  }
}

class Dependency {
  String type;

  Dependency({required this.type});

  factory Dependency.fromParameter(
    ParameterElement typeElement,
  ) =>
      Dependency(
        type: typeElement.toString().split(" ")[0],
      );
}
