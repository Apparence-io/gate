// ********************************
// Gate AppProvider generated file 
// Do not modify by hand           
// ********************************
import 'package:gate_example/coffee_service.dart';
import 'package:gate_example/coffee_service.dart';
import 'package:gate_example/todo.dart';

class AppProvider {
  
  static final AppProvider instance = AppProvider._();
  
  AppProvider._();
  
  // CoffeeService;
  final CoffeeService _coffeeService = CoffeeService.simple(getS1());
  
  CoffeeService getCoffeeServiceSimple() => _coffeeService;
  

  // S1;
  S1 getS1Build() => S1.build();
  

  // TodoService;
  TodoService getTodoServiceBean() => TodoService.bean();
  

  
}
