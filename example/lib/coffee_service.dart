import 'package:gate/gate.dart';

@Injectable()
class CoffeeService {
  CoffeeService._();

  // @Provide()
  factory CoffeeService.bean(S1 a) => CoffeeService._();

  @Singleton()
  factory CoffeeService.simple() => CoffeeService._();

  void pump() {
    print("CoffeeService it's working");
  }
}

@Injectable()
class S1 {
  S1._();

  @Provide()
  factory S1.build() => S1._();

  void test() {
    print("S1 it's working");
  }
}
