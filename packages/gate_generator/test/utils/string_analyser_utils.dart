import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

class AnalyzedClass {
  List<AnalyzedMethod> getters;
  List<AnalyzedAttr> attrs;

  AnalyzedClass()
      : getters = [],
        attrs = [];
}

class AnalyzedMethod {
  String name;
  String returnType;

  AnalyzedMethod(this.name, this.returnType);
}

class AnalyzedAttr {
  String name;
  String type;

  AnalyzedAttr(this.name, this.type);
}

class StringClassTestUtils {
  /// input is a dart class as a string
  static AnalyzedClass parse(String input) {
    var result =
        parseString(content: input, path: '', throwIfDiagnostics: false);
    var rootUnit = result.unit.root;
    AnalyzedClass analyzedClass = AnalyzedClass();

    _parseNode(rootUnit, analyzedClass);
    return analyzedClass;
  }

  static _parseNode(AstNode rootUnit, AnalyzedClass analyzedClass) {
    for (final node in rootUnit.childEntities) {
      // print("node : ${node.runtimeType}");
      if (node is MethodDeclaration) {
        analyzedClass.getters.add(AnalyzedMethod(
          node.name.toString(),
          node.returnType.toString(),
        ));
        _parseNode(node, analyzedClass);
      } else if (node is FieldDeclaration) {
        final attrType =
            node.fields.childEntities.whereType<VariableDeclaration>();
        if (attrType.isNotEmpty) {
          analyzedClass.attrs.add(AnalyzedAttr(
            attrType.first.name.toString(),
            node.fields.childEntities
                .firstWhere((element) => element is NamedType)
                .toString(),
          ));
        }
        _parseNode(node, analyzedClass);
      } else if (node is AstNode) {
        _parseNode(node, analyzedClass);
      }
    }
  }
}
