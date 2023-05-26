import 'dart:convert';

import 'package:gate_generator/src/models/class_model.dart';
import 'package:test/test.dart';

void main() {
  test('parse a list of ClassSchema', () {
    var json = '''
    [
      {
        "path": "/gate_example/lib/coffee_service.dart",
        "className": "CoffeeService",
        "constructor": "simple",
        "injectionType": "InjectionType.SINGLETON",
        "dependencies": []
      },
      {
        "path": "/gate_example/lib/coffee_service.dart",
        "className": "S1",
        "constructor": "build",
        "injectionType": "InjectionType.DYNAMIC",
        "dependencies": []
      }
    ]
    ''';
    List<dynamic> clazzList = jsonDecode(json);
    var res = clazzList.map((e) => ClassSchema.fromJson(e)).toList();
    expect(res.length, 2);
    expect(res[0].constructor, 'simple');
  });
}
