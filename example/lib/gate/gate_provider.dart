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

// CoffeeService mock
  _i1.CoffeeService? _coffeeServiceMock;

// S1 mock
  _i1.S1? _s1Mock;

// S2B singleton
  late final _i1.S2B _s2B = _i1.S2B.build(
    getCoffeeServiceSimple(),
  );

// S2B mock
  _i1.S2B? _s2BMock;

// TodoService mock
  _i2.TodoService? _todoServiceMock;

// injected CoffeeService
  _i1.CoffeeService getCoffeeServiceSimple() =>
      _coffeeServiceMock ?? _coffeeService;
// Set CoffeeService mock
  void setCoffeeServiceSimpleMock(_i1.CoffeeService mock) =>
      _coffeeServiceMock = mock;
// injected S1
  _i1.S1 getS1Build() => _s1Mock ?? _i1.S1.build();
// Set S1 mock
  void setS1BuildMock(_i1.S1 mock) => _s1Mock = mock;
// injected S2B
  _i1.S2B getS2BBuild() => _s2BMock ?? _s2B;
// Set S2B mock
  void setS2BBuildMock(_i1.S2B mock) => _s2BMock = mock;
// injected TodoService
  _i2.TodoService getTodoServiceBean() =>
      _todoServiceMock ?? _i2.TodoService.bean();
// Set TodoService mock
  void setTodoServiceBeanMock(_i2.TodoService mock) => _todoServiceMock = mock;
}

final AppProvider appProvider = AppProvider.instance;
