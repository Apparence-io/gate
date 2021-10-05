// ignore_for_file: constant_identifier_names

import 'package:analyzer/dart/element/element.dart';
import 'package:gate_generator/src/factories/abstract_provider_factory.dart';
import 'package:gate_generator/src/factories/class_provider_factory.dart';
import 'dart:convert';

enum InjectionType {
  SINGLETON,
  DYNAMIC,
}

InjectionType injectTypefromJson(String value) => InjectionType.values.firstWhere((element) => element.toString() == value);

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

  factory ClassSchema.fromJson(Map<String, dynamic> json) => ClassSchema(
        path: json["path"],
        className: json["className"],
        constructor: json["constructor"],
        injectionType: injectTypefromJson(json["injectionType"]),
        dependencies: List.from(json["dependencies"]).map((x) => Dependency.fromJson(x)).toList(),
        // dependencies: List<Dependency>.from(json["dependencies"].map((x) => x)),
      );

  factory ClassSchema.fromRawJson(String str) => ClassSchema.fromJson(json.decode(str));

  ProviderFactory get providerFactory {
    switch (injectionType) {
      case InjectionType.SINGLETON:
        return SingletonProviderFactory(this);
      case InjectionType.DYNAMIC:
        return DynamicProviderFactory(this);
    }
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "path": path,
        "className": className,
        "constructor": constructor,
        "injectionType": injectionType.toString(),
        "dependencies": dependencies,
      };

  ClassSchema copyWith({
    required String path,
    required String className,
    required String constructor,
    required InjectionType injectionType,
    required List<Dependency> dependencies,
  }) =>
      ClassSchema(
        path: path,
        className: className,
        constructor: constructor,
        injectionType: injectionType,
        dependencies: dependencies,
      );

  @override
  bool operator ==(dynamic other) => other is ClassSchema && other.constructor == constructor && other.className == className && other.path == path;

  @override
  int get hashCode => constructor.hashCode ^ className.hashCode ^ path.hashCode;
}

class Dependency {
  String type;
  ClassSchema? classSchema;

  Dependency({required this.type});

  factory Dependency.fromParameter(
    ParameterElement typeElement,
  ) =>
      Dependency(
        type: typeElement.toString().split(" ")[0],
      );

  String toRawJson() => json.encode(toJson());

  factory Dependency.fromJson(Map<String, dynamic> json) => Dependency(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}
