// ***********************************
// Normal simple case
// ***********************************
import 'package:gate/gate.dart';
import 'package:gate_generator/src/gate_provider.dart';

@Injectable()
class S1 {
  final S2 s2Dependency;

  S1._(this.s2Dependency);

  @Provide()
  factory S1.build(S2 s) => S1._(s);

  void test() {
    print("S1 it's working");
  }
}
