import 'package:gate_generator/src/factories/gate_provider_factory.dart';
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

  GateProviderFactory get appProviderFactory => GateProviderFactory(this);
}
