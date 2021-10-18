import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../utils/string_analyser_utils.dart';

// ignore: subtype_of_sealed_class
class BuildStepMock extends Mock implements BuildStep {}

void main() {
  final buildTest = AssetId('build_test', 'lib/build_test.dart');
  final buildStepMock = BuildStepMock();

  setUpAll(() {});

  setUp(() async {});

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
    Type type = BuildStepMock;
    print("test ${type.runtimeType}");
    print("test ${type.toString()}");
    // expect(, matcher);
  });
}
