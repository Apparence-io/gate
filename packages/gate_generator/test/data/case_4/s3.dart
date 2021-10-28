import 'package:gate/gate.dart';

@Injectable()
class S3 {
  S3._();

  @Singleton()
  factory S3.build() => S3._();

  void test() {
    print("S1 it's working");
  }
}
