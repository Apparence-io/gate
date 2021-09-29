import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

TypeChecker getTypeChecker<T>() => TypeChecker.fromRuntime(T);

/// read an annotation
/// get annotation parameter given: annotation.read("given").stringValue
DartObject? getAnnotation<T>(Element element) {
  var annotations = getTypeChecker<T>().annotationsOf(element);
  if (annotations.isEmpty) {
    return null;
  }
  if (annotations.length > 1) {
    throw Exception("You tried to add multiple @$T() annotations to the "
        "same element but that's not possible.");
  }
  return annotations.single;
}
