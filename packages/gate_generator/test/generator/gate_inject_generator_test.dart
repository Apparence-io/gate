import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:gate_generator/src/generator/gate_inject_generator.dart';
import 'package:gate_generator/src/generator/graph_reader.dart';
import 'package:glob/glob.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

// ignore: subtype_of_sealed_class
class BuildStepMock extends Mock implements BuildStep {}

void main() {
  final buildStepMock = BuildStepMock();
  // late PackageAssetReader reader;
  // final inputAssetId0 = AssetId('build_test', 'lib/build_test.dart');

  setUpAll(() {
    registerFallbackValue(Glob('lib/**'));
  });

  setUp(() async {
    // reader = await PackageAssetReader.currentIsolate(
    //   rootPackage: 'build_test',
    // );
  });

  tearDown(() {
    reset(buildStepMock);
  });

  // TestBuilder not working with Part for weird reason
  // this test should work
  // test('''
  // => should create extension with getters for each InjectedChild';
  // ''', () async {
  //   var graph = GateProviderGraph([]);
  //   final graphReader = GateGraphReader(folder: 'data/case_0');
  //   String inputAssetPath = "test/data/case_0/injected.dart";
  //   var content = File(inputAssetPath).readAsString();
  //   await testBuilder(
  //     SharedPartBuilder([GateInjectGenerator(graphReader)], 'gate_inject', allowSyntaxErrors: true),
  //     {'a|$inputAssetPath': content},
  //     outputs: {
  //       'a|test/data/case_0/injected.gate_inject.g.part': graph.appProviderFactory.toString(),
  //       'a|test/data/case_0/injected.g.dart': graph.appProviderFactory.toString(),
  //     },
  //     reader: reader,
  //     rootPackage: 'a',
  //   );
  //   // expect(, matcher);
  // });

  test(''' 
    @Inject(children: [
      InjectedChild(S1, factoryName: 'build'),
      InjectedChild(S2, factoryName: 'build'),
    ]) 
    class UserService {}
    ==> should create inject extension correctly with S1 and S2
  ''', () async {
    final graphReader = GateGraphReader(folder: 'data/case1');
    final gateInjectGenerator = GateInjectGenerator(graphReader);
    var inputAssetId =
        AssetId('gate_generator', 'test/data/case_0/injected.dart');
    List<AssetId> assets = [
      AssetId('gate_generator', 'test/data/case_0/s1.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_0/s2.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_0/s3.gate_schema.json'),
    ];
    // when(() => buildStepMock.inputId.package).thenReturn("mypackage");
    // when(() => buildStepMock.inputId.uri).thenReturn(Uri.parse("test/data/case_0/s1.dart"));
    when(() => buildStepMock.inputId).thenReturn(inputAssetId);
    when(() => buildStepMock.findAssets(any()))
        .thenAnswer((_) => Stream.fromIterable(assets));
    when(() => buildStepMock.readAsString(inputAssetId))
        .thenAnswer((_) => File(inputAssetId.path).readAsString());
    for (var asset in assets) {
      when(() => buildStepMock.readAsString(asset))
          .thenAnswer((_) => File(asset.path).readAsString());
    }
    var library = await resolveSources({
      'gate_generator|test/data/case_0/injected.dart': useAssetReader,
    }, (resolver) => resolver.findLibraryByName(''));

    var generatedString = await gateInjectGenerator.generate(
        LibraryReader(library!), buildStepMock);
    expect(generatedString, '''part of 'injected.dart';

extension UserServiceInjection on UserService {

  S1 get s1 => AppProvider.instance.getS1Build();

  S2 get s2 => AppProvider.instance.getS2Build();
}''');
  });
}
