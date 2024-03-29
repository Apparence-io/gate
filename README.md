<p align="center">
<img src="https://github.com/Apparence-io/gate/raw/master/packages/gate_generator/doc/images/cover.png" alt="flutter anchored onboarding screen" />
</p>

<p align="center">
  <a href="https://pub.dev/packages/gate_generator"><img src="https://img.shields.io/pub/v/gate_generator" alt="pubdev" style="max-width: 100%;"></a>
  <a href="https://github.com/Apparence-io/gate/actions"><img src="https://github.com/Apparence-io/gate/workflows/Dart%20CI/badge.svg" alt="ci" style="max-width: 100%;"></a>
  <a href="https://opensource.org/licenses/MIT" rel="nofollow"><img src="https://camo.githubusercontent.com/83d3746e5881c1867665223424263d8e604df233d0a11aae0813e0414d433943/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6963656e73652d4d49542d626c75652e737667" alt="License: MIT" data-canonical-src="https://img.shields.io/badge/license-MIT-blue.svg" style="max-width: 100%;"></a>
</p>

## 💎&nbsp; Features
- Provide Injectable as a singleton
- Provide Injectable as a dynamic service
- Inject an Injectable class into another

## 💡&nbsp; Motivation
Providing Service should be independent from your pages or other code. 

The DI pattern separates the responsibility of creating an object of the service class out of the client class.
Also using code generation we can get rid of the boilerplate part. 

## 🚀&nbsp; Getting started
install gate with `build_runner` in you `pubspec.yaml` 
```
dependencies:
  build_runner: ^X.X.X
  gate: ^X.X.X

dev_dependencies:
  gate_generator: ^X.X.X
```
> Note: replace X.X.X with last available version on pub.dev.

## 📖&nbsp; Usage

### 1. Create a class you want to inject

```dart
import 'package:gate/gate.dart';

@Injectable()
class CoffeeService {
  final S1 s1;

  CoffeeService._(this.s1);

  @Singleton()
  factory CoffeeService.simple(S1 s1) => CoffeeService._(s1);

  void pump() {
    print("CoffeeService it's working");
  }
}
```

> You just have to 
> - add `@Injectable()` above your class
> - add `@Singleton()` or `@Provide()` above a factory 

### 2. Inject dependency 

We can now inject our Injectables using `@Inject` annotation.

InjectedChild use
- Type you want to inject
- the name of the factory you want to use (you can have multiple provided factories)
- the attribute name (just in case you want to rename it or make it private...)

```dart
import 'package:gate_example/gate/gate_provider.dart';
import 'package:gate_example/gate/coffee_service.dart';
part 'coffee_page.gate_inject.g.part';

@Inject(children: [
  InjectedChild(S1, factoryName: "build"),
  InjectedChild(CoffeeService, factoryName: "simple", attrName: "coffeeService"),
])
class CoffeePage extends StatelessWidget {
  const CoffeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    coffeeService.pump();
    return Container();
  }
}
```
You can inject as many dependency as you want into your class as long as their are Injectable. 
> ```part 'coffee_page.gate_inject.g.part';```  will be be added to your file
> this file will be genererated on next step
> don't forget to import "gate_provider.dart" that is generated next

### 3. Generate code
Using build runner you can run the command in your shell 
```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

Once build runner is done, you can run your flutter app and use all injected class. 

> If you change your factory or wants to inject other class... just rerun the `build_runner` 😀

## 📗&nbsp; Properties
| Annotation   |      Description                                                     | 
|--------------|---------------------------------------------------------------------:|
| Injectable   |  mark a class as containing Singleton or Provide factories           | 
| Singleton    |  mark a factory as a Singleton Injectable                            | 
| Provide      |  mark a factory as a Dymamic Injectable. Each time you inject will create a new instance of that class           | 
| Inject    |  mark a class to inject dependencies                           | 


### Inject annotation
| Property        |      Description                                                     | 
|-----------------|---------------------------------------------------------------------:|
| children        |  a list of InjectedChild                                             | 


### InjectedChild annotation
| Property        |      Description                                                     | 
|-----------------|---------------------------------------------------------------------:|
| type            |  The type to inject                                                  | 
| factoryName     |  The factory name to use                                             | 
| attrName        |  *(optionnal)* The attribute name to call it from your class         | 

## ✅&nbsp; Tests

### Run tests
```bash
dart pub global activate coverage
dart test --coverage="coverage"
format_coverage --lcov --in=coverage --out=coverage.lcov --packages=.packages --report-on=lib
```

### Mock an injected dependency for testing

To remplace your service by mocks, you have to set them, before testing.
Gate will generate all methods for you. 

First, declare your mocked services with your preferred libraries.

Then use the `appProvider` to set mocks.

Finally, don't forget to reset mocks by setting them to null.

```dart
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
```

## 📣&nbsp; Sponsor

<img src="https://github.com/Apparence-io/bart/raw/master/.github/img/apparence_logo.png" alt="logo apparence io" />
<br />
<br />

[Initiated and sponsored by Apparence.io.](https://apparence.io)

## 👥&nbsp; Contribution

Contributions are welcome.
Contribute by creating a PR or create an issue 🎉.