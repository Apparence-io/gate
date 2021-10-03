// ***********************************
// Try to inject S2 into S1 without S2 as Injectable
// this fails
// ***********************************
import 'package:gate/gate.dart';

class S2 {
  S2._();

  factory S2.build() => S2._();

  void test() {
    print("S1 it's working");
  }
}
