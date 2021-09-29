// ignore_for_file: non_constant_identifier_names
// CoffeeService;
import '../coffee_service.dart';
// S1;
import '../coffee_service.dart';
// TodoService;
import '../todo.dart';

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
