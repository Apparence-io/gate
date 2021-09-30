import 'package:gate_generator/src/models/class_model.dart';

class GateProviderGraph {
  final List<ClassSchema> injectables;

  GateProviderGraph(this.injectables);

  /// throws if dependency is not injected
  checkDependency(Dependency dependency) {
    if (!injectables.any((e) => e.className == dependency.type)) {
      throw "Dependency cannot be created. All your injection's dependencies must be injected.";
    }
  }

  @override
  String toString() {
    var res = StringBuffer();
    res.writeln("// ignore_for_file: non_constant_identifier_names");
    for (var el in injectables) {
      res.writeln("// ${el.className};");
      res.writeln("import 'package:${el.path}';");
    }
    res.writeln("");
    res.writeln("class AppProvider {");
    res.writeln("  ");
    res.writeln('''  static final AppProvider instance = AppProvider._();''');
    res.writeln("  ");
    res.writeln('''  AppProvider._();''');
    res.writeln("  ");
    for (var el in injectables) {
      res.writeln("  // ${el.className};");
      res.writeln(el.providerFactory.build());
    }
    res.writeln("  ");
    res.writeln("}");
    return res.toString();
  }
}
