import 'package:gate/gate.dart';

@Injectable()
class TodoService {
  TodoService._();

  @Provide()
  factory TodoService.bean() => TodoService._();
}
