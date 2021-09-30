import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:gate_generator/src/builder/aggregating_builder.dart';
import 'package:gate_generator/src/generator/gate_provider_generator.dart';
import 'package:gate_generator/src/generator/gate_provider_helper.dart';
import 'package:test/test.dart';

void main() {
  group('AggregatingBuilder ', () {
    late PackageAssetReader reader;

    final buildAsset = AssetId('build', 'lib/src/gate_provider.dart');
    final buildTest = AssetId('build_test', 'lib/build_test.dart');

    setUp(() async {
      reader = await PackageAssetReader.currentIsolate(
        rootPackage: 'build_test',
      );
    });

    test('Create gate_provider class', () async {
      expect(await reader.canRead(buildTest), isTrue);
      expect(await reader.readAsString(buildTest), isNotEmpty);
      var graph = GateProviderGraph();
      await testBuilder(
        AggregatingBuilder(GateCodeGenerator()),
        {'a|lib/a.txt': 'a'},
        outputs: {'a|lib/gate/gate_provider.dart': graph.toString()},
        reader: reader,
        rootPackage: 'a',
      );
    });
  });
}
