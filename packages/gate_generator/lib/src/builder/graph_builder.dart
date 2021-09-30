import 'package:build/build.dart';
import 'package:gate_generator/src/generator/json_generator.dart';
import 'package:path/path.dart' as p;
import 'package:glob/glob.dart';
import 'dart:async';

class GateGraphBuilder implements Builder {
  static final inputFiles = Glob('lib/**.json');
  final bool allowSyntaxErrors = true;
  final GeneratorForJson generator;

  GateGraphBuilder(this.generator);

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
    await for (final input in buildStep.findAssets(inputFiles)) {
      log.info("### GateGraphBuilder Processing:  ${input.path}");
      generator.parse(await buildStep.readAsString(input));
    }
    return buildStep.writeAsString(output, generator.generate());
  }
}
