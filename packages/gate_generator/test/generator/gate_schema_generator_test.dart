import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:gate_generator/src/builder/json_builder.dart';
import 'package:gate_generator/src/generator/gate_schema_generator.dart';
import 'package:test/test.dart';

void main() {
  group('GateSchemaGenerator ', () {
    late PackageAssetReader reader;

    final buildTest = AssetId('build_test', 'lib/build_test.dart');

    setUp(() async {
      reader = await PackageAssetReader.currentIsolate(
        rootPackage: 'build_test',
      );
    });

    test('Create gate json schema files', () async {
      expect(await reader.canRead(buildTest), isTrue);
      expect(await reader.readAsString(buildTest), isNotEmpty);

      final classFile = '''
      import 'package:gate/gate.dart';

      @Injectable()
      class TodoService {
        TodoService._();

        @Provide()
        factory TodoService.bean() => TodoService._();
      }
      ''';
      final expectedJson = '''[
  {
    "path": "a/a.dart",
    "className": "TodoService",
    "constructor": "bean",
    "injectionType": "InjectionType.DYNAMIC",
    "dependencies": []
  }
]''';
      await testBuilder(
        JsonBuilder(GateSchemaGenerator()),
        {'a|lib/a.dart': classFile},
        outputs: {'a|lib/a.gate_schema.json': expectedJson},
        reader: reader,
        rootPackage: 'a',
      );
    });
  });
}
