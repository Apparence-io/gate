// ********************************
// Gate AppProvider generated file 
// Do not modify by hand           
// ********************************
import 'package:gate_example/coffee_service.dart';
import 'package:gate_example/todo.dart';

class AppProvider {
  
  static final AppProvider instance = AppProvider._();
  
  AppProvider._();
  
  // CoffeeService;
  late final CoffeeService _coffeeService = CoffeeService.simple(getS1Build(),);
  
  CoffeeService getCoffeeServiceSimple() => _coffeeService;
  

  // S1;
  S1 getS1Build() => S1.build();
  

  // S2B;
  late final S2B _s2B = S2B.build(getCoffeeServiceSimple(),);
  
  S2B getS2BBuild() => _s2B;
  

  // TodoService;
  TodoService getTodoServiceBean() => TodoService.bean();
  

  
}
