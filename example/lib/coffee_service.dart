import 'package:gate/gate.dart';

@Injectable()
class CoffeeService {
  final S1 s1;

  CoffeeService._(this.s1) {
    print("...construct CoffeeService");
  }

  @Singleton()
  factory CoffeeService.simple(S1 s1) => CoffeeService._(s1);

  void pump() {
    print("CoffeeService it's working");
  }

  String getMenu() {
    return "No menu";
  }
}

@Injectable()
class S1 {
  S1._() {
    print("...construct S1");
  }

  @Provide()
  factory S1.build() => S1._();

  void test() {
    print("S1 it's working");
  }
}

@Injectable()
class S2B {
  CoffeeService coffeeService;

  S2B._(this.coffeeService) {
    print("...construct S2B");
  }

  @Singleton()
  factory S2B.build(CoffeeService coffeeService) => S2B._(coffeeService);

  void test() {
    print("S2B it's working");
  }
}

class GateProvider {
  static final GateProvider instance = GateProvider._();

  late final CoffeeService _coffeeService = CoffeeService.simple(getS1Build());

  GateProvider._();

  S1 getS1Build() => S1.build();

  S2B getS2BBuild() => S2B.build(getCoffeeServiceSimple());

  CoffeeService getCoffeeServiceSimple() {
    return _coffeeService;
  }
}
