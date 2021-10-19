import 'package:gate_example/database/repositories/library_repository.dart';
import 'package:gate_example/database/entities/library_entity.dart';
import 'package:gate_example/database/entities/user_entity.dart';
import 'package:gate_example/services/auth_service.dart';
import 'package:gate_example/database/repositories/book_repository.dart';
import 'package:gate_example/database/repositories/user_repository.dart';
import 'package:gate_example/gate/gate_provider.dart';
import 'package:gate/gate.dart';

part 'user_service.gate_inject.g.part';

@Injectable()
@Inject(children: [
  InjectedChild(AuthenticationService, factoryName: 'build'),
  InjectedChild(BookRepository, factoryName: 'build'),
  InjectedChild(UserRepository, factoryName: 'build'),
  InjectedChild(LibraryRepository, factoryName: 'build'),
])
class UserService {
  UserService._();

  @Provide()
  factory UserService.build() => UserService._();

  UserEntity getMe() =>
      userRepository.getFromId(authenticationService.getUserId());

  LibraryEntity getLibrary() {
    return libraryRepository.getFromId("123134");
  }
}
