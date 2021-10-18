import 'package:gate/gate.dart';
import 'package:gate_example/database/entities/library_entity.dart';

@Injectable()
class LibraryRepository {
  LibraryRepository._();

  @Singleton()
  factory LibraryRepository.build() => LibraryRepository._();

  LibraryEntity getFromId(String id) => LibraryEntity(id: id, name: "myLibrary");
}
