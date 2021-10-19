import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/type.dart';

class Injected {
  final DartType type;
  final String? factoryName, attrName;

  const Injected(this.type, {this.factoryName, this.attrName});

  factory Injected.fromDartObject(DartObject obj) => Injected(
        obj.getField("type")!.toTypeValue()!,
        factoryName: obj.getField("factoryName")?.toStringValue(),
        attrName: obj.getField("attrName")?.toStringValue(),
      );

  String get className => type.element!.displayName;

  String get attribute {
    return attrName ?? "${className[0].toLowerCase()}${className.substring(1)}";
  }

  String get method {
    if (factoryName != null) {
      return "get$className${factoryName![0].toUpperCase()}${factoryName!.substring(1)}";
    }
    return "get$className";
  }

  String get getter =>
      "  $className get $attribute => AppProvider.instance.$method();";
}
