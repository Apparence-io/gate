import 'package:gate_example/coffee_service.dart' as _i1;
import 'package:gate_example/todo.dart' as _i2;

// ********************************
// Gate AppProvider generated file
// Do not modify by hand
// ********************************
class AppProvider {
  AppProvider._();

  static final AppProvider instance = AppProvider._();

// CoffeeService singleton
  late final _i1.CoffeeService _coffeeService = _i1.CoffeeService.simple(
    getS1Build(),
  );

// S2B singleton
  late final _i1.S2B _s2B = _i1.S2B.build(
    getCoffeeServiceSimple(),
  );

// injected CoffeeService
  _i1.CoffeeService getCoffeeServiceSimple() => _coffeeService;
// injected S1
  _i1.S1 getS1Build() => _i1.S1.build();
// injected S2B
  _i1.S2B getS2BBuild() => _s2B;
// injected TodoService
  _i2.TodoService getTodoServiceBean() => _i2.TodoService.bean();
}
