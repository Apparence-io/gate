import 'package:gate/gate.dart';
import 'package:gate_example/database/entities/user_entity.dart';

@Injectable()
class UserRepository {
  UserRepository._();

  @Singleton()
  factory UserRepository.build() => UserRepository._();

  UserEntity getFromId(String id) => UserEntity(id: "31345421", name: "Seldon");
}
