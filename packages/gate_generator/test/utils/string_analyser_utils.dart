import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

class AnalyzedClass {
  List<AnalyzedMethod> getters;

  AnalyzedClass() : getters = [];
}

class AnalyzedMethod {
  String name;
  String returnType;

  AnalyzedMethod(this.name, this.returnType);
}

class StringClassTestUtils {
  /// input is a dart class as a string
  static AnalyzedClass parse(String input) {
    var result = parseString(content: input, path: '', throwIfDiagnostics: false);
    var rootUnit = result.unit.root;
    AnalyzedClass analyzedClass = AnalyzedClass();

    _parseNode(rootUnit, analyzedClass);
    return analyzedClass;
  }

  static _parseNode(AstNode rootUnit, AnalyzedClass analyzedClass) {
    for (final node in rootUnit.childEntities) {
      if (node is MethodDeclaration) {
        analyzedClass.getters.add(AnalyzedMethod(
          node.name.name,
          node.returnType.toString(),
        ));
        _parseNode(node, analyzedClass);
      } else if (node is AstNode) {
        _parseNode(node, analyzedClass);
      }
    }
  }
}
