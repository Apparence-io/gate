import 'package:gate/gate.dart';

@Injectable()
class AuthenticationService {
  AuthenticationService._();

  @Singleton()
  factory AuthenticationService.build() => AuthenticationService._();

  String getUserId() => "31345421";
}
