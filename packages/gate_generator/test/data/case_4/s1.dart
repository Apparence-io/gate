import 'package:gate/gate.dart';
import 'package:gate_generator/src/gate_provider.dart';

@Injectable()
class S1 {
  final S2 s2;
  final S3 s3;

  S1._(this.s2, this.s3);

  @Singleton()
  factory S1.build(S2 s, S3 s3) => S1._(s, s3);

  void test() {
    print("S1 it's working");
  }
}
