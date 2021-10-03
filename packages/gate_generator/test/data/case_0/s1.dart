// ***********************************
// Normal simple case
// ***********************************
import 'package:gate/gate.dart';
import 'package:gate_generator/src/gate_provider.dart';

@Injectable()
class S1 {
  S1._();

  @Provide()
  factory S1.build() => S1._();

  void test() {
    print("S1 it's working");
  }
}
