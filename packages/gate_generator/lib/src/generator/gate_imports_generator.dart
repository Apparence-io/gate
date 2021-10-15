import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:build/build.dart';
import 'package:gate_generator/src/models/class_model.dart';
import 'package:gate_generator/src/models/gate_provider_graph.dart';
import 'package:universal_io/io.dart';

class GateImportsGenerator {
  GateProviderGraph graph;

  GateImportsGenerator(this.graph);

  generate(BuildStep buildStep, Set<ClassSchema> injectablesToAdd) async {
    var fileContent = await buildStep.readAsString(buildStep.inputId);
    var result = parseString(content: fileContent, throwIfDiagnostics: false);
    var rootUnit = result.unit.root;

    var missingImports = _parseImports(rootUnit, injectablesToAdd);
    var resultFile = StringBuffer();
    Set<String> imports = {};
    for (var missingImport in missingImports) {
      final importString = "import 'package:${missingImport.path}';";
      if (!imports.contains(importString)) {
        resultFile.writeln(importString);
      }
      imports.add(importString);
    }
    if (!_hasImport(rootUnit, _getGateProviderImport(buildStep))) {
      resultFile.writeln(_getGateProviderImport(buildStep));
    }
    if (!_hasPartDirective(rootUnit, _getPart(buildStep))) {
      int fileEndImportIndex = _getEndImportIndex(rootUnit);
      var firstPart = fileContent.substring(0, fileEndImportIndex + 1);
      var secondPart = fileContent.substring(fileEndImportIndex + 1, fileContent.length);
      fileContent = '$firstPart\n${_getPart(buildStep)}\n$secondPart';
    }
    resultFile.writeln(fileContent);
    var file = File(buildStep.inputId.path);
    await file.writeAsString(resultFile.toString());
  }

  Set<ClassSchema> _parseImports(AstNode rootUnit, Set<ClassSchema> injectablesToAdd) {
    List<ClassSchema> importedList = [];
    for (final node in rootUnit.childEntities) {
      if (node is ImportDirective) {
        var injectableAlreadyImported = injectablesToAdd.where((element) {
          return node.toString().contains(element.path);
        });
        if (injectableAlreadyImported.isNotEmpty) {
          importedList.addAll(injectableAlreadyImported);
        }
      }
    }
    return injectablesToAdd.difference(importedList.toSet());
  }

  bool _hasImport(AstNode rootUnit, String importString) {
    for (final node in rootUnit.childEntities) {
      if (node is ImportDirective && node.toString().contains(importString)) {
        return true;
      }
    }
    return false;
  }

  bool _hasPartDirective(AstNode rootUnit, String partString) {
    for (final node in rootUnit.childEntities) {
      if (node is PartDirective && node.toString().contains(partString)) {
        return true;
      }
    }
    return false;
  }

  int _getEndImportIndex(AstNode rootUnit) {
    SyntacticEntity? res;
    for (final node in rootUnit.childEntities) {
      if (node is ImportDirective) {
        res = node;
      }
    }
    if (res != null) {
      return res.offset + res.length;
    }
    return 0;
  }

  String _getGateProviderImport(BuildStep buildStep) {
    return "import 'package:${buildStep.inputId.package}/gate/gate_provider.dart';";
  }

  String _getPart(BuildStep buildStep) {
    return "part '${buildStep.inputId.uri.pathSegments.last.split(".dart")[0]}.gate_inject.g.part';";
  }
}
