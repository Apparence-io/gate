import 'package:build/build.dart';
import 'package:gate_generator/src/generator/json_generator.dart';
import 'package:path/path.dart' as p;
import 'package:glob/glob.dart';
import 'dart:async';

enum OutputMode {
  single,
  multi,
}

class GateGraphBuilder implements Builder {
  final bool allowSyntaxErrors = true;
  final GeneratorForJson generator;
  final OutputMode outputMode;
  final String buildExtension;

  GateGraphBuilder(this.generator, {required this.outputMode, required this.buildExtension});

  AssetId _fileOutput(BuildStep buildStep) {
    if (outputMode == OutputMode.single) {
      return AssetId(
        buildStep.inputId.package,
        p.join('lib', buildExtension),
      );
    }
    return buildStep.inputId.changeExtension(buildExtension);
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final AssetId output = _fileOutput(buildStep);
    return buildStep.writeAsString(output, generator.generate(buildStep));
  }

  @override
  Map<String, List<String>> get buildExtensions {
    if (outputMode == OutputMode.single) {
      return {
        r'$lib$': [buildExtension]
      };
    }
    return {
      '.dart': [buildExtension]
    };
  }
}
