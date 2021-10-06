import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:gate_generator/src/generator/gate_provider_generator.dart';
import 'package:gate_generator/src/generator/json_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:path/path.dart' as p;
import 'package:glob/glob.dart';
import 'dart:async';

class AggregatingBuilder implements Builder {
  static final inputFiles = Glob('lib/**');
  final bool allowSyntaxErrors = true;
  final Generator generator;

  AggregatingBuilder(this.generator);

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      r'$lib$': const ['gate/gate_provider.dart']
    };
  }

  static AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      p.join('lib', 'gate/gate_provider.dart'),
    );
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final output = _allFileOutput(buildStep);
    var res = StringBuffer();
    await for (final input in buildStep.findAssets(inputFiles)) {
      final lib = await buildStep.resolver
          .libraryFor(input, allowSyntaxErrors: allowSyntaxErrors);
      res.writeln(await _generate(lib, [generator], buildStep));
    }
    return buildStep.writeAsString(output, res.toString());
  }

  Future _generate(
    LibraryElement library,
    List<Generator> generators,
    BuildStep buildStep,
  ) async {
    final libraryReader = LibraryReader(library);
    for (var i = 0; i < generators.length; i++) {
      final gen = generators[i];
      await gen.generate(libraryReader, buildStep);
    }
  }
}
