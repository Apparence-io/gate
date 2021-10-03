// ***********************************
// Try to inject S2 into S1 without S2 as Injectable
// this fails
// ***********************************
import 'package:gate/gate.dart';

@Injectable()
class S3 {
  S3._();

  @Provide()
  factory S3.build() => S3._();

  void test() {
    print("S1 it's working");
  }
}
