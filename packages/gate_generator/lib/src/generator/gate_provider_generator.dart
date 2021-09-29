import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:gate_generator/src/models/class_model.dart';
import 'package:source_gen/source_gen.dart';

import 'package:gate/gate.dart';

import 'gate_provider_helper.dart';
// import 'package:dart_style/dart_style.dart';
// import 'dart:async';

class GateCodeGenerator extends GeneratorForAnnotation<Injectable> {
  final gateProviderGraph = GateProviderGraph();
  AssetId? assetId;

  GateCodeGenerator();

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    String header = await super.generate(library, buildStep);
    return header;
  }

  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    log.info("### Processing: " + element.displayName);
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@Injectable()` can only be used on classes.',
        element: element,
      );
    }
    // String path = buildStep.inputId.path;
    // String name = annotation.peek('name')?.stringValue;
    String path = assetId!.path.replaceFirst('lib/', '');
    for (var el in element.constructors) {
      if (!el.isFactory) {
        continue;
      }
      if (isProvider(el)) {
        gateProviderGraph.add(ClassSchema.builder(element, el, path));
      } else if (isSingleton(el)) {
        gateProviderGraph.add(ClassSchema.singleton(element, el, path));
      }
    }
  }

  bool isProvider(Element element) => TypeChecker.fromRuntime(Provide).firstAnnotationOfExact(element) != null;

  bool isSingleton(Element element) => TypeChecker.fromRuntime(Singleton).firstAnnotationOfExact(element) != null;
}
