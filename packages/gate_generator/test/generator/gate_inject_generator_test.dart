import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:gate_generator/src/generator/gate_inject_generator.dart';
import 'package:gate_generator/src/generator/graph_reader.dart';
import 'package:gate_generator/src/models/gate_provider_graph.dart';
import 'package:glob/glob.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';
import 'package:universal_io/io.dart';

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

  test(''' 
  @Inject(children: [
    InjectedChild('AuthenticationService', factoryName: 'build'),
    InjectedChild('BookRepository', factoryName: 'build'),
    InjectedChild('UserRepository', factoryName: 'build'),
    InjectedChild('LibraryRepository', factoryName: 'build'),
  ]) 
  class UserService {}

  => build should provide imports correctly
  import 'package:gate_example/gate/gate_provider.dart';

  part 'user_service.gate_inject.g.part';
  ''', () async {
    expect(await reader.canRead(buildTest), isTrue);
    expect(await reader.readAsString(buildTest), isNotEmpty);
    var graph = GateProviderGraph([]);
    final graphReader = GateGraphReader(folder: 'data/case1');

    await testBuilder(
      SharedPartBuilder([GateInjectGenerator(graphReader)], 'gate_inject'),
      {'a|test/data/case_0/injected.dart': reader},
      outputs: {'a|lib/gate/user_service.gate_inject.g.part': graph.appProviderFactory.toString()},
      reader: reader,
      rootPackage: 'a',
    );
    // expect(, matcher);
  });

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
    var inputAssetId = AssetId('gate_generator', 'test/data/case_0/injected.dart');
    List<AssetId> assets = [
      AssetId('gate_generator', 'test/data/case_0/s1.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_0/s2.gate_schema.json'),
      AssetId('gate_generator', 'test/data/case_0/s3.gate_schema.json'),
    ];
    when(() => buildStepMock.inputId).thenReturn(inputAssetId);
    when(() => buildStepMock.findAssets(any())).thenAnswer((_) => Stream.fromIterable(assets));
    when(() => buildStepMock.readAsString(inputAssetId)).thenAnswer((_) => File(inputAssetId.path).readAsString());
    for (var asset in assets) {
      when(() => buildStepMock.readAsString(asset)).thenAnswer((_) => File(asset.path).readAsString());
    }
    var library = await resolveSources({
      'gate_generator|test/data/case_0/injected.dart': useAssetReader,
    }, (resolver) => resolver.findLibraryByName(''));

    var generatedString = await gateInjectGenerator.generate(LibraryReader(library!), buildStepMock);

    print("*****************");
    print("*****************");
    print("$generatedString");
    print("*****************");
    print("*****************");
  });
}
