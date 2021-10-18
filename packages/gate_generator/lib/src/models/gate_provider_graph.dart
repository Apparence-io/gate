import 'dart:collection';

import 'package:build/build.dart';
import 'package:gate_generator/src/factories/gate_provider_factory.dart';
import 'package:gate_generator/src/generator/exceptions/gate_provider_exceptions.dart';
import 'package:gate_generator/src/models/class_model.dart';
import 'package:gate_generator/src/models/injected_model.dart';

class GateProviderGraph {
  final List<ClassSchema> injectables;

  GateProviderGraph(this.injectables);

  /// throws if dependency is not injected
  checkDependency(Dependency dependency) {
    if (!injectables.any((e) => e.className == dependency.type)) {
      throw "${dependency.type} Dependency cannot be created. All your injection's dependencies must be injected.";
    }
  }

  // push ClassSchema into ClassSchema's injectable
  injectDependencies() {
    for (var injectable in injectables) {
      for (var dependency in injectable.dependencies) {
        final injectableDependency = injectables.firstWhere(
          (element) => element.className == dependency.type,
          orElse: () => throw 'injectableDependency cannot be found',
        );
        dependency.classSchema = injectableDependency;
      }
    }
  }

  checkCyclicDependency() {
    final treeLog = StringBuffer();
    for (var injectable in injectables) {
      _getDependencyTree(injectable, {}, treeLog);
    }
    log.info("---------------------");
    log.info(" Dependency tree     ");
    log.info("---------------------");
    log.info("\n$treeLog");
  }

  /// returns a list of [ClassSchema] from an injectable dependency list
  _getDependencyTree(
    ClassSchema injectable,
    Set<ClassSchema> visitedDependencies,
    StringBuffer treeLog,
  ) {
    if (injectable.dependencies.isEmpty) {
      return;
    }
    treeLog.writeln("${injectable.className} -> ");
    for (var dependency in injectable.dependencies) {
      final injectableDependency = injectables.firstWhere(
        (element) => element.className == dependency.type,
        orElse: () => throw 'injectableDependency cannot be found',
      );
      if (visitedDependencies.contains(injectableDependency) || injectable == injectableDependency) {
        throw CyclicDepencyException(" on ${injectableDependency.className} as dependency");
      }
      visitedDependencies.add(injectableDependency);
      treeLog.writeln("   ${injectableDependency.className}");
      _getDependencyTree(injectableDependency, HashSet.from(visitedDependencies), treeLog);
    }
  }

  GateProviderFactory get appProviderFactory => GateProviderFactory(this);

  ClassSchema getInjected(Injected injected) => injectables.firstWhere((element) => element.className == injected.className);
}
