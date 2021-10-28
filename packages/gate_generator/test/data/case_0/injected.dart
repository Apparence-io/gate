import 'package:gate_generator/gate/gate_provider.dart';
import 'package:gate/gate.dart';
import 's1.dart';
import 's2.dart';

part 'injected.gate_inject.g.part';

@Inject(children: [
  InjectedChild(S1, factoryName: 'build'),
  InjectedChild(S2, factoryName: 'build'),
])
class UserService {}
