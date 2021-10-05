import 'package:gate/gate.dart';

import 's1.dart';
import 's3.dart';

@Injectable()
class S2 {
  final S3 s;

  S2._(this.s);

  @Singleton()
  factory S2.build(S3 s) => S2._(s);

  void test() {
    print("S1 it's working");
  }
}
