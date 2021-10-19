import 'package:gate/gate.dart';

@Injectable()
class BookRepository {
  BookRepository._();

  @Singleton()
  factory BookRepository.build() => BookRepository._();
}
