import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:gate_generator/src/builder/aggregating_builder.dart';
import 'package:gate_generator/src/builder/graph_builder.dart';
import 'package:gate_generator/src/generator/gate_provider_generator.dart';
import 'package:gate_generator/src/generator/graph_reader.dart';
import 'package:gate_generator/src/models/class_model.dart';
import 'package:gate_generator/src/models/gate_provider_graph.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';
import 'package:glob/glob.dart';

import '../utils/string_analyser_utils.dart';

// ignore: subtype_of_sealed_class
class BuildStepMock extends Mock implements BuildStep {}

void main() {
  late PackageAssetReader reader;

  final buildAsset = AssetId('build', 'lib/src/gate_provider.dart');
  final buildTest = AssetId('build_test', 'lib/build_test.dart');
  final buildStepMock = BuildStepMock();

  setUpAll(() {
    registerFallbackValue(Glob('lib/**'));
  });

  setUp(() async {
    reader = await PackageAssetReader.currentIsolate(
      rootPackage: 'build_test',
    );
  });

  tearDown(() {
    reset(buildStepMock);
  });

  test('Create gate_provider class', () async {
    expect(await reader.canRead(buildTest), isTrue);
    expect(await reader.readAsString(buildTest), isNotEmpty);
    var graph = GateProviderGraph([]);
    final graphReader = GateGraphReader(folder: 'data/case1');

    await testBuilder(
      GateGraphBuilder(
        GateCodeGenerator(graphReader),
        outputMode: OutputMode.single,
        buildExtension: 'gate/gate_provider.dart',
      ),
      {'a|lib/a.txt': 'a'},
      outputs: {'a|lib/gate/gate_provider.dart': graph.toString()},
      reader: reader,
      rootPackage: 'a',
    );
  });

  test(''' 
  classes S1, S2, S3 are dynamic Injectables
  => Creates an AppProvider class with get methods for S1,S2,S3
  ''', () async {
    final graphReader = GateGraphReader(folder: 'data/case1');
    final gateCodeGenerator = GateCodeGenerator(graphReader);
    List<AssetId> assets = [
      AssetId('gate_generator', 'test/data/case_0/s1.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_0/s2.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_0/s3.gate_schema.json'),
    ];
    when(() => buildStepMock.findAssets(any())).thenAnswer((_) => Stream.fromIterable(assets));
    for (var asset in assets) {
      when(() => buildStepMock.readAsString(asset)).thenAnswer((_) => File(asset.path).readAsString());
    }
    var generatedString = await gateCodeGenerator.generate(buildStepMock);
    var analyzedClass = StringClassTestUtils.parse(generatedString);

    expect(analyzedClass.getters.length, 3);
    expect(analyzedClass.getters[0].name, "getS1Build");
    expect(analyzedClass.getters[1].name, "getS2Build");
    expect(analyzedClass.getters[2].name, "getS3Build");
  });

  test(''' 
  classes S1, S2, S3 are dynamic Injectables,
  S1 requires S2 as parameter
  => Creates an AppProvider class with get methods for S1,S2,S3
  ''', () async {
    // final gateCodeGenerator = GateCodeGenerator();
  });
}
