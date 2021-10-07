import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:gate_generator/src/builder/graph_builder.dart';
import 'package:gate_generator/src/generator/exceptions/gate_provider_exceptions.dart';
import 'package:gate_generator/src/generator/gate_provider_generator.dart';
import 'package:gate_generator/src/generator/graph_reader.dart';
import 'package:gate_generator/src/models/gate_provider_graph.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:glob/glob.dart';

import '../utils/string_analyser_utils.dart';

// ignore: subtype_of_sealed_class
class BuildStepMock extends Mock implements BuildStep {}

void main() {
  late PackageAssetReader reader;

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
      outputs: {
        'a|lib/gate/gate_provider.dart': graph.appProviderFactory.toString()
      },
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
    when(() => buildStepMock.findAssets(any()))
        .thenAnswer((_) => Stream.fromIterable(assets));
    for (var asset in assets) {
      when(() => buildStepMock.readAsString(asset))
          .thenAnswer((_) => File(asset.path).readAsString());
    }
    var generatedString = await gateCodeGenerator.generate(buildStepMock);
    var analyzedClass = StringClassTestUtils.parse(generatedString);

    expect(analyzedClass.attrs.length, 4);
    expect(analyzedClass.attrs[1].name, '_s1BuildMock');
    expect(analyzedClass.attrs[2].name, '_s2BuildMock');
    expect(analyzedClass.attrs[3].name, '_s3BuildMock');
    expect(analyzedClass.getters.length, 6);
    expect(analyzedClass.getters[0].name, "getS1Build");
    expect(analyzedClass.getters[1].name, "setS1BuildMock");
    expect(analyzedClass.getters[2].name, "getS2Build");
    expect(analyzedClass.getters[3].name, "setS2BuildMock");
    expect(analyzedClass.getters[4].name, "getS3Build");
    expect(analyzedClass.getters[5].name, "setS3BuildMock");
  });

  test(''' 
  classes S1, S2, S3 are dynamic Injectables,
  S1 requires S2 as parameter
  => Creates an AppProvider class with get methods for S1,S2,S3
  ''', () async {
    final graphReader = GateGraphReader(folder: 'data/case1');
    final gateCodeGenerator = GateCodeGenerator(graphReader);
    List<AssetId> assets = [
      AssetId('gate_generator', 'test/data/case_1/s1.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_1/s2.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_1/s3.gate_schema.json'),
    ];
    when(() => buildStepMock.findAssets(any()))
        .thenAnswer((_) => Stream.fromIterable(assets));
    for (var asset in assets) {
      when(() => buildStepMock.readAsString(asset))
          .thenAnswer((_) => File(asset.path).readAsString());
    }
    var generatedString = await gateCodeGenerator.generate(buildStepMock);
    var analyzedClass = StringClassTestUtils.parse(generatedString);

    expect(analyzedClass.attrs.length, 4);
    expect(analyzedClass.attrs[1].name, '_s1BuildMock');
    expect(analyzedClass.attrs[2].name, '_s2BuildMock');
    expect(analyzedClass.attrs[3].name, '_s3BuildMock');

    expect(analyzedClass.getters.length, 6);
    expect(analyzedClass.getters[0].name, "getS1Build");
    expect(analyzedClass.getters[1].name, "setS1BuildMock");
    expect(analyzedClass.getters[2].name, "getS2Build");
    expect(analyzedClass.getters[3].name, "setS2BuildMock");
    expect(analyzedClass.getters[4].name, "getS3Build");
    expect(analyzedClass.getters[5].name, "setS3BuildMock");
  });

  test(''' 
  classes S1, S2, S3 are singleton Injectables,
  S1 requires S2 as parameter
  => Creates an AppProvider class with get methods for S1,S2,S3, 1 attribute exists for each one
  ''', () async {
    final graphReader = GateGraphReader(folder: 'data/case1');
    final gateCodeGenerator = GateCodeGenerator(graphReader);
    List<AssetId> assets = [
      AssetId('gate_generator', 'test/data/case_2/s1.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_2/s2.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_2/s3.gate_schema.json'),
    ];
    when(() => buildStepMock.findAssets(any()))
        .thenAnswer((_) => Stream.fromIterable(assets));
    for (var asset in assets) {
      when(() => buildStepMock.readAsString(asset))
          .thenAnswer((_) => File(asset.path).readAsString());
    }
    var generatedString = await gateCodeGenerator.generate(buildStepMock);
    var analyzedClass = StringClassTestUtils.parse(generatedString);

    // 4 attrs because we got AppProvider instance attr first
    expect(analyzedClass.attrs.length, 7);
    expect(analyzedClass.attrs[1].name, '_s1Build');
    expect(analyzedClass.attrs[2].name, '_s1BuildMock');
    expect(analyzedClass.attrs[3].name, '_s2Build');
    expect(analyzedClass.attrs[4].name, '_s2BuildMock');
    expect(analyzedClass.attrs[5].name, '_s3Build');
    expect(analyzedClass.attrs[6].name, '_s3BuildMock');
    expect(analyzedClass.getters.length, 6);
    expect(analyzedClass.getters[0].name, "getS1Build");
    expect(analyzedClass.getters[1].name, "setS1BuildMock");
    expect(analyzedClass.getters[2].name, "getS2Build");
    expect(analyzedClass.getters[3].name, "setS2BuildMock");
    expect(analyzedClass.getters[4].name, "getS3Build");
    expect(analyzedClass.getters[5].name, "setS3BuildMock");
  });

  test(''' 
  classes S1, S2, S3 are dynamic Injectables,
  S1 requires S2 as parameter
  S2 requires S3 as parameter
  S3 requires S1 as parameter
  => throws a cyclic dependency as they both requires each other to build
  ''', () async {
    final graphReader = GateGraphReader(folder: 'data/case1');
    final gateCodeGenerator = GateCodeGenerator(graphReader);
    List<AssetId> assets = [
      AssetId('gate_generator', 'test/data/case_3/s1.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_3/s2.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_3/s3.gate_schema.json'),
    ];
    when(() => buildStepMock.findAssets(any()))
        .thenAnswer((_) => Stream.fromIterable(assets));
    for (var asset in assets) {
      when(() => buildStepMock.readAsString(asset))
          .thenAnswer((_) => File(asset.path).readAsString());
    }
    // await gateCodeGenerator.generate(buildStepMock);
    expect(() async => await gateCodeGenerator.generate(buildStepMock),
        throwsA(TypeMatcher<CyclicDepencyException>()));
  });
}
