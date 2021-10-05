import 'package:gate_generator/src/models/class_model.dart';
import 'package:gate_generator/src/models/gate_provider_graph.dart';

// TODO use code_builder to generate code
class GateProviderFactory {
  final GateProviderGraph graph;

  GateProviderFactory(this.graph);

  @override
  String toString() {
    var res = StringBuffer();
    res.writeln("// ********************************");
    res.writeln("// Gate AppProvider generated file ");
    res.writeln("// Do not modify by hand           ");
    res.writeln("// ********************************");
    List<String> imports = [];
    for (var el in graph.injectables) {
      final importStatement = "import 'package:${el.path}';";
      if (!imports.contains(importStatement)) {
        res.writeln(importStatement);
        imports.add(importStatement);
      }
    }
    res.writeln("");
    res.writeln("class AppProvider {");
    res.writeln("  ");
    res.writeln('''  static final AppProvider instance = AppProvider._();''');
    res.writeln("  ");
    res.writeln('''  AppProvider._();''');
    res.writeln("  ");
    for (var el in graph.injectables) {
      res.writeln("  // ${el.className};");
      res.writeln(el.providerFactory.build());
    }
    res.writeln("  ");
    res.writeln("}");
    return res.toString();
  }
}
