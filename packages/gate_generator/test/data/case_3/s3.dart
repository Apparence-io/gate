import 'package:gate/gate.dart';

import 's1.dart';

@Injectable()
class S3 {
  final S1 s;

  S3._(this.s);

  @Singleton()
  factory S3.build(S1 s) => S3._(s);

  void test() {
    print("S1 it's working");
  }
}
