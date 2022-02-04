import 'package:gate/gate.dart';

@Injectable()
class UserService {
  UserService._();

  @Singleton()
  factory UserService.build() => UserService._();

  String get userId => "31345421";
}

@Inject(children: [
  InjectedChild(UserService, factoryName: 'build'),
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
            Text(userService.userId, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
