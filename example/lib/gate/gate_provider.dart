// ignore_for_file: non_constant_identifier_names
// CoffeeService;
import 'package:gate_example/coffee_service.dart';
// S1;
import 'package:gate_example/coffee_service.dart';
// TodoService;
import 'package:gate_example/todo.dart';

class AppProvider {
  
  static final AppProvider instance = AppProvider._();
  
  AppProvider._();
  
  // CoffeeService;
  final _coffeeService = CoffeeService.simple();
  
  CoffeeService getCoffeeServiceSimple() => _coffeeService;
  

  // S1;
  S1 getS1Build() => S1.build();
  

  // TodoService;
  TodoService getTodoServiceBean() => TodoService.bean();
  

  
}
