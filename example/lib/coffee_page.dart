import 'package:flutter/material.dart';
import 'package:gate/gate.dart';
import 'coffee_service.dart';

import 'package:gate_example/gate/gate_provider.dart';
part 'coffee_page.gate_inject.g.part';

@Inject(children: [
  InjectedChild("S1", factoryName: "build"),
  InjectedChild("CoffeeService", factoryName: "simple", attrName: "coffeeService"),
])
class CoffeePage extends StatelessWidget {
  const CoffeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    coffeeService.pump();
    return Container();
  }
}
