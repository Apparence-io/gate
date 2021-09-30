import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:glob/glob.dart';
import 'dart:async';

class JsonBuilder implements Builder {
  static final inputFiles = Glob('lib/**');
  final String _generatedExtension = '.gate_schema.json';
  final bool allowSyntaxErrors = true;
  final Generator generator;

  JsonBuilder(this.generator);

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      '.dart': const ['.gate_schema.json']
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final outputId = buildStep.inputId.changeExtension(_generatedExtension);
    final lib = await buildStep.resolver.libraryFor(buildStep.inputId, allowSyntaxErrors: allowSyntaxErrors);
    final generatedOutputs = await _generate(lib, [generator], buildStep).toList();
    final contentBuffer = StringBuffer();
    for (var item in generatedOutputs) {
      contentBuffer.writeln(item);
    }
    buildStep.writeAsString(outputId, contentBuffer.toString());
  }

  Stream<String> _generate(
    LibraryElement library,
    List<Generator> generators,
    BuildStep buildStep,
  ) async* {
    final libraryReader = LibraryReader(library);
    for (var i = 0; i < generators.length; i++) {
      final gen = generators[i];
      String? createdUnit = await gen.generate(libraryReader, buildStep);
      yield createdUnit!;
    }
  }
}
