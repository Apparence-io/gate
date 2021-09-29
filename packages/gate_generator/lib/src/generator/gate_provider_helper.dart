import 'package:gate_generator/src/models/class_model.dart';

class GateProviderGraph {
  List<ClassSchema> injectables;

  GateProviderGraph() : injectables = [];

  add(ClassSchema injectable) {
    injectables.add(injectable);
  }

  /// throws if dependency is not injected
  checkDepency(Dependency dependency) {
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
      res.writeln("import '../${el.path}';");
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