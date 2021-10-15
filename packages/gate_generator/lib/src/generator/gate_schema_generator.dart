import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:gate/gate.dart';
import 'package:gate_generator/src/models/class_model.dart';
import 'package:source_gen/source_gen.dart';

class GateSchemaGenerator extends GeneratorForAnnotation<Injectable> {
  final List<ClassSchema> classList = [];

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    classList.clear();
    for (var annotatedElement in library.annotatedWith(typeChecker)) {
      generateForAnnotatedElement(annotatedElement.element, annotatedElement.annotation, buildStep);
    }
    if (classList.isEmpty) return '';
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(classList);
  }

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@Injectable()` can only be used on classes.',
        element: element,
      );
    }
    for (var el in element.constructors) {
      if (!el.isFactory) {
        continue;
      }
      var absPath = buildStep.inputId.path.replaceFirst('lib/', '');
      var packageName = buildStep.inputId.package;
      String path = "$packageName/$absPath";
      if (isProvider(el)) {
        classList.add(ClassSchema.builder(element, el, path));
      } else if (isSingleton(el)) {
        classList.add(ClassSchema.singleton(element, el, path));
      }
    }
  }

  @override
  String toString() => "";

  bool isProvider(Element element) => TypeChecker.fromRuntime(Provide).firstAnnotationOfExact(element) != null;

  bool isSingleton(Element element) => TypeChecker.fromRuntime(Singleton).firstAnnotationOfExact(element) != null;
}
