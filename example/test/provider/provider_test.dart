// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:gate_example/coffee_service.dart';
import 'package:gate_example/gate/gate_provider.dart';
import 'package:mocktail/mocktail.dart';

class CoffeeServiceMock extends Mock implements CoffeeService {}

void main() {
  test('Test mocks', () async {
    expect(appProvider.getCoffeeServiceSimple().getMenu(), equals('No menu'));

    final CoffeeService coffeeService = CoffeeServiceMock();
    when(() => coffeeService.getMenu()).thenReturn("Best menu");
    appProvider.setCoffeeServiceSimpleMock(coffeeService);

    expect(appProvider.getCoffeeServiceSimple().getMenu(), equals('Best menu'));
  });
}
