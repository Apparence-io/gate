import 'package:gate_example/services/user_service.dart';
import 'package:gate_example/gate/gate_provider.dart';
import 'package:flutter/material.dart';
import 'package:gate/gate.dart';

part 'home_page.gate_inject.g.part';

@Inject(children: [
  InjectedChild('UserService', factoryName: 'build'),
])
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text("User", style: TextStyle(fontSize: 21)),
            Text(userService.getMe().name, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

