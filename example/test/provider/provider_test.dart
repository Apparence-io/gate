// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:gate_example/coffee_service.dart';
import 'package:gate_example/gate/gate_provider.dart';
import 'package:gate_example/todo.dart';
import 'package:mocktail/mocktail.dart';

class CoffeeServiceMock extends Mock implements CoffeeService {}

class S1ServiceMock extends Mock implements S1 {}

class S2BServiceMock extends Mock implements S2B {}

class TodoServiceMock extends Mock implements TodoService {}

void main() {
  // Initialize mocks
  final CoffeeService coffeeServiceMock = CoffeeServiceMock();
  final S1 s1ServiceMock = S1ServiceMock();
  final S2B s2BServiceMock = S2BServiceMock();
  final TodoService todoServiceMock = TodoServiceMock();

  group('Mock injection group', () {
    setUp(() {
      when(() => coffeeServiceMock.getMenu()).thenReturn("Best menu");
      // Set injected services with mocks
      appProvider.setCoffeeServiceSimpleMock(coffeeServiceMock);
      appProvider.setS1BuildMock(s1ServiceMock);
      appProvider.setS2BBuildMock(s2BServiceMock);
      appProvider.setTodoServiceBeanMock(todoServiceMock);
    });

    tearDownAll(() {
      // Remove mocks from appProvider (real ones will be used)
      appProvider.setCoffeeServiceSimpleMock(null);
      appProvider.setS1BuildMock(null);
      appProvider.setS2BBuildMock(null);
      appProvider.setTodoServiceBeanMock(null);
    });

    test('Test mocks injection', () async {
      expect(appProvider.getCoffeeServiceSimple().getMenu(),
          equals('Best menu')); // Mocked returned value

      appProvider.setCoffeeServiceSimpleMock(null);

      expect(appProvider.getCoffeeServiceSimple().getMenu(),
          equals('No menu')); // True value (not mocked)
    });
  });
}
