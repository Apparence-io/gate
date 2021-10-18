import 'package:gate/gate.dart';

import 's1.dart';
import 's2.dart';

@Inject(children: [
  InjectedChild(S1, factoryName: 'build'),
  InjectedChild(S2, factoryName: 'build'),
])
class UserService {}
