import 'package:gate/gate.dart';

@Injectable()
class S2 {
  S2._();

  @Singleton()
  factory S2.build() => S2._();

  void test() {
    print("S1 it's working");
  }
}
